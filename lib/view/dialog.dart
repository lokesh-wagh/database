import 'package:flutter/material.dart';

Future<bool> showlogoutdialog(BuildContext context){
  return showDialog<bool>
  (
    context: context, 
    builder: (context)
    {
    return AlertDialog(
      title: const Text("Logout"),
      content: const Text("do you want to logout?"),
      actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop(false);
       
      }, child:const Text("Cancel") ),
      TextButton(onPressed: (){
         Navigator.of(context).pop(true);
      }, child:const Text("Logout") ),
    ],
    );
  }).then((value) => value??false);
}
Future<bool> showbooldialog(BuildContext context){
  return showDialog<bool>
  (
    context: context, 
    builder: (context)
    {
    return AlertDialog(
      title: const Text("Blank Note"),
      content: const Text("you just made a blank note,do you want to go back to making new note?"),
      actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop(false);
       
      }, child:const Text("No") ),
      TextButton(onPressed: (){
         Navigator.of(context).pop(true);
      }, child:const Text("Yes") ),
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

Future<String?>showupdatedialog(BuildContext context,String text,String title,String preexistingmesssage){
  return showDialog<String>(context: context, builder:(context){
    final TextEditingController _message=TextEditingController(text: preexistingmesssage);
 
   return AlertDialog(
    title:  Text(title),
    content:  Text(text),
    actions: [
      TextField(
        controller: _message,
        
        decoration: const InputDecoration(hintText:"enter the updated string"),
      ),
      TextButton(onPressed: (){
        Navigator.of(context).pop(_message.text.toString());
      }, child: const Text("Edit"))
    ],
   );
  });
}



