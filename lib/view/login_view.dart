




import 'package:database/services/auth/auth_exceptions.dart';
import 'package:database/view/dialog.dart';
import 'package:flutter/material.dart';
import 'package:database/services/auth/auth_service.dart';



class login_view extends StatefulWidget {
  const login_view({super.key});

  @override
  State<login_view> createState() => _login_viewState();
}

class _login_viewState extends State<login_view> {
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
      builder: (context, snapshot)  {
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
            decoration: const InputDecoration(
              hintText: "enter the email id"
            ),
          ),
          TextField(
            controller: _password,
            autocorrect: false,
            obscureText: true,
            enableSuggestions: false,
            decoration:const InputDecoration(
              hintText: "enter the password"
            ),
          ),
         Column(
            children:[
          TextButton(onPressed:() async{
            final user =AuthService.firebase();
            final email=_email.text;
            final password=_password.text;
            try{
        await user.Login(email: email, password: password);
        print(user.currentUser?.isEmailVerified);
          if(user.currentUser?.isEmailVerified??false){
            await showerrordialog(context,"you have logged in succesully\nnow enjoy the kinky photos\n", "Login Successful");
              Navigator.of(context).pushNamedAndRemoveUntil('/notes/', (route) => false);
          }
          else{  user.SendEmailVerification();
                Navigator.of(context).pushNamedAndRemoveUntil('/verify/', (route) => false);
             
          }
            }
            on UserNotFoundAuthException {
            await showerrordialog(context, "user is not present in data base", "uwu!! error occured!!");
            }
            on WrongPasswordAuthException{
              await showerrordialog(context, "password is incorrect", "uwu!! error occured!!");
            }
            on InvalidEmailAuthException{
              await showerrordialog(context, "the email id is invalid", "uwu!! error occured!!");
            }
            on GenericAuthException{
             await showerrordialog(context, "something went wrong", "uwu!! error occured!!");
            }
           
          },
          child: const Text("Login"),
          ),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
          },child: Text("not registered yet?"),),
       ])
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