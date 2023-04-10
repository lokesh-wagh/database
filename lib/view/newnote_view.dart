import 'package:database/constant/route.dart';
import 'package:database/services/auth/auth_service.dart';
import 'package:database/services/crud/notes_service.dart';
import 'package:flutter/material.dart';


class newnote_view extends StatefulWidget {
  const newnote_view({super.key});

  @override
  State<newnote_view> createState() => _newnote_viewState();
}

class _newnote_viewState extends State<newnote_view> {
  late final TextEditingController _newnote;
  late final NotesService _access;
  DatabaseNotes? _note;
  @override
  void initState() {
    _access=NotesService();
    _newnote = TextEditingController(); 
    super.initState();
  }


 Future<DatabaseNotes>create_a_newnote()async{
     final note=_note;
     if(note!=null){
      return note;
     }
    final email =  AuthService.firebase().currentUser!.email!;
    final user = await _access.getOrCreateUser(email: email);
     return  await _access.createnote(owner: user); 
  }


  void _deleteonexiting()async{
    final note=_note;
    if(_newnote.text.toString()==""&&note!=null){
    await _access.deletenote(id: _note?.id);
      }
  }


void _updatenotewhentextfieldchange()async{
  print("$_note lsls");
  final note=_note;
  if(note!=null&&_newnote.text.isNotEmpty){
  await _access.updateNotes(note:_note! , text: _newnote.text);
  }
}


void _listenerfunction()async{
  final note=_note;
  if(note==null){
    return;
  }
  await _access.updateNotes(note: note, text:_newnote.text);

}


void _listenerfunctionsetter(){
_newnote.removeListener(_listenerfunction);
_newnote.addListener(_listenerfunction);
}
  
  @override
  void dispose() {
    _updatenotewhentextfieldchange();
    _deleteonexiting();
   print ("$_note");
    _newnote.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Add New Notes"),
    ),
    body: FutureBuilder(
      future: create_a_newnote(),
      builder:(context,snapshot){
        switch(snapshot.connectionState){
         
          case ConnectionState.done:
            _note=snapshot.data as DatabaseNotes;
            _listenerfunctionsetter();  
            
            return
            Column(
              children:[ TextField(controller: _newnote,
            decoration: InputDecoration(hintText: "enter your note"),
            maxLines: null,keyboardType: TextInputType.multiline,),
            TextButton(onPressed: _updatenotewhentextfieldchange, child: Text("add")),
        ]);
          default:
          return const CircularProgressIndicator();
        }
      } ,
    ));
  }
}
