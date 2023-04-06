import 'package:database/services/auth/auth_service.dart';

import 'package:flutter/material.dart';

import '../services/auth/auth_exceptions.dart';
import 'dialog.dart';



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
      future:   AuthService.firebase().initialize(),
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
            try{
            final email = _email.text;
            final password = _password.text;
          await AuthService.firebase().Createuser(email: email, password: password);
            } 
            on UserNotFoundAuthException {
            await showerrordialog(context, "user is not present in data base", "uwu!! error occured!!");
            }
            on WeakPasswordAuthException{
              await showerrordialog(context, "password is weak", "uwu!! error occured!!");
            }
            on InvalidEmailAuthException{
              await showerrordialog(context, "the email id is invalid", "uwu!! error occured!!");
            }
            on EmailAlreadyInUseAuthException{
              await showerrordialog(context, "the email id is already in use", "uwu!! error occured!!");
            }
            on WrongPasswordAuthException{
              await showerrordialog(context, "password is incorrect", "uwu!! error occured!!");
            }
            on GenericAuthException{
             await showerrordialog(context, "something went wrong", "uwu!! error occured!!");
            }
            on UserNotLoggedInAuthException{
              await showerrordialog(context,"you have sucessfully registered","registration sucessful!!");
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
  

        }
   
  }
  )
  );
     
  
    
  }
}