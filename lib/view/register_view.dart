import 'package:database/view/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../firebase_options.dart';

class register_view extends StatefulWidget {
  const register_view({super.key});

  @override
  State<register_view> createState() => _register_view();
}

class _register_view extends State<register_view> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email=TextEditingController();
    _password=TextEditingController();
    
    super.initState();
  }

 @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("lauda"),
      
    ),
    body: FutureBuilder(
      future:   Firebase.initializeApp(
          
                   options:  DefaultFirebaseOptions.currentPlatform,
          ),
      builder: (context, snapshot) {
        switch(snapshot.connectionState){
          
     
          case ConnectionState.done:
                 return 
                  Column(
        children: [
          TextField(
    
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "enter the email id"
            ),
          ),
          TextField(
            controller: _password,
            autocorrect: false,
            obscureText: true,
            enableSuggestions: false,
            decoration:InputDecoration(
              hintText: "enter the password"
            ),
          ),
          TextButton(onPressed:() async{
             
         try{ final email=_email.text;
              final password=_password.text;
           
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password)  ;        
              FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user == null) {
      print('User is currently signed out!');
    } else {
     await showerrordialog(context,"you have been sucessfully registered\nyou can now log in\n", "Registration Sucessful");
       Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
    }
  });
          }
          on FirebaseAuthException
          catch (e){
       
            switch(e.code){
              
             case "wrong-password":
             await showerrordialog(context,"wrong password" , "woah Bhosadike");
             break;
             case "invalid-email":
              await showerrordialog(context, "invalid email", "woah Bhosadike");
             break;
          
              case "user-not-found":
             await showerrordialog(context,"user doesn't exist" , "woah Bhosadike");
             break;
              case "email-already-in-use":
               await showerrordialog(context,"email already in use" , "woah Bhosadike");
              break;
              case "weak-password":
               await showerrordialog(context,"password is too weak", "woah Bhosadike");
              break;
              default:
               await showerrordialog(context,"something went wrong" , "woah Bhosadike");
              
              break;
    
            }
             
          }
          }
          ,
          child: Text("Register"),
          ),
        TextButton(onPressed: (){
           Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
        }, child: Text("go to login"))
        ],
      
      );
        default:
        return const Text("loading..");
        break;

        }
   
  }
  )
  );
     
  
    
  }
}