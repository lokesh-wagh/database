

import 'package:database/constant/route.dart';
import 'package:database/services/auth/auth_service.dart';
import 'package:database/services/crud/notes_service.dart';
import 'package:database/view/newnote_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dialog.dart';

class notes_view extends StatefulWidget {
  const notes_view({super.key});

  @override
  State<notes_view> createState() => _notes_viewState();
}
enum menuaction{
  logout ;
}
class _notes_viewState extends State<notes_view> {

 DatabaseNotes? text; 
late final NotesService _access;
late final String email;
 

 @override
 void initState()  {
   final user=AuthService.firebase().currentUser!;
   email=user.email!;
   _access=NotesService(); 
    super.initState();
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Notes"),
      actions: [
        IconButton(onPressed: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>newnote_view()));
        },icon: const Icon(Icons.add),),
       PopupMenuButton<menuaction>(onSelected:(value)async{
       switch(value){
        case menuaction.logout:
        final what=await showlogoutdialog(context);
        if(what){
          
           AuthService.firebase().Logout();
           Navigator.of(context).pushNamedAndRemoveUntil(login, (route) => false);
           }
        break;
       }
      
       },itemBuilder: (context){
        return [
        PopupMenuItem<menuaction>(value:menuaction.logout,child: Text("logout"))
        ];
       })

        ]),
        body:FutureBuilder(
          future: _access.getOrCreateUser(email: email) ,
          builder:((context, snapshot) {
            switch(snapshot.connectionState){
              
              
              
              case ConnectionState.done:
               return StreamBuilder(
                stream: _access.allnotes,
                builder:((context, snapshot) {
                switch(snapshot.connectionState){
                  
                
                  case ConnectionState.waiting:
                   
                  case ConnectionState.active:
                  if(snapshot.hasData){
                    print("activated");
                    
                  final list=snapshot.data as List<DatabaseNotes>;
                  final l =list.length;
                  print(l);
                    return ListView.builder(
                      itemCount:list.length ,
                      itemBuilder: (context,index){
                        if(index%2==0){
                          return ListTile(title: Text(list[index].note,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,),
                          tileColor:Colors.yellow,
                          trailing:
                           IconButton(onPressed: ()async{
                           
                            await _access.deletenote(id: list[index].id);
                          },icon: Icon(Icons.delete),),
                          iconColor: Colors.red,
                       
                          );
                      }
                      
                      else{
                         return ListTile(title: Text(list[index].note,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,),
                          tileColor:Colors.purple,
                          trailing: IconButton(onPressed: ()async{
                                await _access.deletenote(id: list[index].id);
                          },icon: Icon(Icons.delete),),
                          iconColor: Colors.red,
                          
                          );
                      }},
                    );
                  }
                  else{
                    return const CircularProgressIndicator(); 
                  }  
                  default:
                  return const CircularProgressIndicator();               
                }
                 
                }));
                
              default:
              return CircularProgressIndicator();
            }
          }),
        )
      
      ,);
      
    
    
  }
}

