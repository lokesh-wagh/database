
import 'package:database/view/notes_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../firebase_options.dart';
import 'dialog.dart';

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
         Column(
            children:[
          TextButton(onPressed:() async{
            try{ 
              
              final email=_email.text;
              final password=_password.text;
             
            await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email, 
            password: password

            );
            final user =FirebaseAuth.instance.currentUser ;
        
           final l=user?.emailVerified??false;
           
          
            if(l==false){
            final user=FirebaseAuth.instance.currentUser;     
              user?.sendEmailVerification(); 
              await showerrordialog(context,"verifivcation email has been sent to our id\nbe sure to check the sapm folder\n","Verification Email Sent");
           Navigator.of(context).pushNamed('/verify/');
            }
            else{
               Navigator.of(context).pushNamedAndRemoveUntil('/notes/', (route) => false);
            };
             }
          on FirebaseAuthException  catch (e){
            
            switch(e.code){
             case "wrong-password":
             await showerrordialog(context,'wrong password',"woah bhosadike");
             break;
             case "invalid-email":
             await showerrordialog(context,'invalid email',"woah bhosadike");
             break;
          
              case "user-not-found":
            await showerrordialog(context,'user doesnt exist',"woah bhosadike");
             break;

              default: await showerrordialog(context,'something went wrong',"woah bhosadike");
            }
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