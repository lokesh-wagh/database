import 'package:database/view/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:database/view/login_view.dart';

import '../firebase_options.dart';

class verify_view extends StatefulWidget {
  const verify_view({super.key});

  @override
  State<verify_view> createState() => _verify_viewState();
}

class _verify_viewState extends State<verify_view> {
 
  Widget build(BuildContext context) {
   
    return  Scaffold(appBar: AppBar(
      title: Text("verify view"),
      
    ),
    body: FutureBuilder(
      future:    
      Firebase.initializeApp(
                  
                   options:  DefaultFirebaseOptions.currentPlatform,
          ),
      builder: (context, snapshot) {
        
        switch(snapshot.connectionState){
          
      
          case ConnectionState.done:
                 return 
                  Column(
        children: [
         Center(
          child:
          
          TextButton(onPressed: (){
             Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
          }, child: Text("go to login"))),
          Center(
            child:
             TextButton(onPressed: ()async{
               final user=FirebaseAuth.instance.currentUser;     
              user?.sendEmailVerification(); 
              final l =user?.emailVerified??false;
              user?.reload();
              if(l==true){
                await showerrordialog(context, "you have verified sucessfully\n", "Verification Successful");
                Navigator.pop(context);
              }
            await showerrordialog(context, "Verification email has been sent\n","Email Sent");
          }, 
          child:Text("Resend verification email") ))
        ],
      
      );
        default:
        return const Text("loading..");
       

        }
   
  }
  )
  );
     
  }
}