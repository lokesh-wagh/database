

import 'dart:async';

import 'package:database/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart' show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart' ;

import 'crud_exceptions.dart';

class NotesService{
Database ? _db;
List<DatabaseNotes> _notes=[];
NotesService._private(){
   _notestreamcontroller= StreamController<List<DatabaseNotes>>.broadcast(
    onListen: (){
      _notestreamcontroller.sink.add(_notes);
    }
   );
   
}
static final _shared=NotesService._private();
factory NotesService()=>_shared;

late final _notestreamcontroller;
Stream<List<DatabaseNotes>> get allnotes=>_notestreamcontroller.stream;


Future<void>_ensuredatabaseisopen()async{
  try{
    await open();
  }
  on DatabaseAlreadyOpen{
    //empty
  }

}

Future<DatabaseUser>getOrCreateUser({required String email})async{
try{
  await _ensuredatabaseisopen();
return await getuser(email: email);
}
on CouldNotFindUser{
try{
  return await createUser(email: email);
}
catch(e){
  rethrow;
}

}
}

Future<void> _cacheNotes()async{
  final user=AuthService.firebase().currentUser!;
 final user1=await getOrCreateUser(email: user.email!);
    await _ensuredatabaseisopen();
 try{
   final notes = await getAllNotes( user1);
    _notes=notes.toList();
  _notestreamcontroller.add(_notes);
 }
 catch(e){
  //
 }
 
}

Future<DatabaseNotes> updateNotes({required DatabaseNotes note,required String text })async{
  await _ensuredatabaseisopen();
final db = _getdatabaseorthrow();
await getnote(id: note.id);
final n = await db.update("notes",{"id":note.id,"user_id":note.user_id,"text":"$text"},where: "id=?",whereArgs: [note.id] );
if(n==0){
throw CouldNotUpdateNote();
}
final note1 =await getnote(id: note.id);
_notes.removeWhere((element) => element.id==note.id);
_notes.add(note1);
_notestreamcontroller.add(_notes);
return note1;
}

Future<Iterable<DatabaseNotes>> getAllNotes(DatabaseUser user)async{
    await _ensuredatabaseisopen();
  final db = _getdatabaseorthrow();
  final l = await db.query("notes",where: "user_id=?",whereArgs: [user.id]);
  if(l.isEmpty){
   return [];
  }
  final t = l.map((e) => DatabaseNotes.fromnote(e));
  return t;
}

Future<DatabaseNotes> getnote({required int id})async{
    await _ensuredatabaseisopen();
  final db = _getdatabaseorthrow();
  final l  = await db.query("notes",where:"id=?",whereArgs: [id]);
  if(l.isEmpty){
    throw CouldNotFindNote;
  }
  
 final note = DatabaseNotes.fromnote(l[0]);
 print("$note");
 _notes.removeWhere((element) => element.id==id);
 _notes.add(note);
 _notestreamcontroller.add(_notes);
 return note;
}

Future<void> deletenote({required int id})async{
    await _ensuredatabaseisopen();
  final db =_getdatabaseorthrow();
  final i=await db.delete("notes",where:"id=?",whereArgs: [id]);
  if(i==0){
    throw CouldNotDeleteNote();
  }
  final countbefore=_notes.length;
  
  _notes.removeWhere((note) => note.id==id );
  if(countbefore!=_notes.length){
  _notestreamcontroller.add(_notes);
  }
}

Future<DatabaseNotes> createnote({required DatabaseUser owner}) async {
     await _ensuredatabaseisopen();
   final db = _getdatabaseorthrow();
   final user= await getuser(email: owner.email);
   if(user!=owner){
    throw CouldNotFindUser();  //this is a security feature to ensure 
   }                           //that the database has not been manually manipulted
                              //bcoz then they would have different id's
   final text = '';
   final noteid = await db.insert("notes",{
    "user_id":owner.id,
    "text":text,
   });
   
   final note = DatabaseNotes.fromnote({
    "id":noteid,
    "user_id":owner.id,
    "text":text,
   });
   _notes.add(note);
   _notestreamcontroller.add(_notes);
   return note;
   
}

Future<DatabaseUser> getuser({required String email})async{
  await _ensuredatabaseisopen();
final db=_getdatabaseorthrow();
final l= await db.query("user",limit:1,where: "email=?",whereArgs: [email.toLowerCase()]);
if(l.isEmpty){
  throw CouldNotFindUser();
}
return DatabaseUser.fromuser(l[0]);
}

Future<void> deleteUser({required String email})async{
   await _ensuredatabaseisopen();
  final db = _getdatabaseorthrow();
 final deletedcount = await db.delete(
  "user", //this function will delete an entire row
  where: "email=?",
  whereArgs: [email.toLowerCase()]);
  if(deletedcount!=1){
    throw CouldNotDeleteUser();
  }
}

Future<DatabaseUser> createUser({required String email})async{
    await _ensuredatabaseisopen();
  final db = _getdatabaseorthrow();
  final l= await db.query("user",limit:1,where: "email=?",whereArgs: [email.toLowerCase()]);
 if(l.isNotEmpty){
  throw UserAlreadyExists;

 }
 else{
  
final UserId = await db.insert("user",{"email":email.toLowerCase()} );
return DatabaseUser(id : UserId,email : email.toLowerCase());

 }

}

Database _getdatabaseorthrow(){
  final db=_db;
if(db==null){
  throw DatabaseIsNotOpen();
}
else{
  return db;
}

}

Future<void>close()async{
  final db =_db;
  if(db==null){
    throw DatabaseIsNotOpen();
  }
 await db.close();
}

Future<void>open()async{
  if(_db!=null){
    throw DatabaseAlreadyOpen();
  }
 
  try{
    final docspath = await getApplicationDocumentsDirectory();//this will return the directory where your app data will be stored
    final dbpath = join(docspath.path,"testing");//this joins the database name with the directory path to create a proper path to the database
    final db = await openDatabase(dbpath);//this takes the above created path and opens the database
    _db = db;
    await db.execute('''CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);''');// creates user table in data base
    await db.execute('''CREATE TABLE IF NOT EXISTS "notes" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);''');//creates notes table in data base
await _cacheNotes();
  }
  
  on MissingPlatformDirectoryException{
    throw UnableToGetDocumentsDirectory();
  }

}

}



@immutable
class DatabaseUser{
final id;
final email;

 const DatabaseUser({required this.email,required this.id});

 
 DatabaseUser.fromuser(Map<String,Object?>map):
            email=map["email"] as String,
            id=map["id"] as int;
  @override
  bool operator ==(covariant DatabaseUser other)=>id==other.id;
  @override
  int get hashCode =>id.hashCode;
  @override
  String toString() {
   return "id : $id     email : $email ";
  }

}
@immutable
class DatabaseNotes{
final id;
final user_id;
final note;
DatabaseNotes.fromnote(Map<String,Object?>map):
  id=map["id"] as int,
  user_id=map["user_id"] as int,
  note=map["text"] as String;


 @override
  bool operator ==(covariant DatabaseUser other)=>id==other.id;
  @override
  int get hashCode =>id.hashCode;

@override
  String toString() {
   return "id : $id , user_id : $user_id , note : $note ";
  }

}