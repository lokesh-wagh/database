import 'package:flutter/material.dart';

Future<bool> showlogoutdialog(BuildContext context){
  return showDialog<bool>
  (
    context: context, 
    builder: (context)
    {
    return AlertDialog(
      title: Text("Logout"),
      content: Text("do you want to logout?"),
      actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop(false);
       
      }, child:Text("Cancel") ),
      TextButton(onPressed: (){
         Navigator.of(context).pop(true);
      }, child:Text("Logout") ),
    ],
    );
  }).then((value) => value??false);
}
Future<void>showerrordialog(BuildContext context,String text,String title){
  return showDialog<void>(context: context, builder:(context){
   return AlertDialog(
    title:  Text(title),
    content:  Text(text),
    actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop();
      }, child: const Text("OK"))
    ],
   );
  });
}


