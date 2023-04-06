

import 'package:database/constant/route.dart';
import 'package:database/services/auth/auth_service.dart';

import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Main UI"),
      actions: [
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
        body:Column(
        children:[ const Text("thjis is notes"),
        ]
      )
      
      ,);
      
    
    
  }
}

