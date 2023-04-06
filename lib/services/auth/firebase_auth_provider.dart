import 'package:database/services/auth/auth_exceptions.dart';
import 'package:database/services/auth/auth_provider.dart';
import 'package:database/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> Createuser({required email, required password})async{
    try{
   await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password)  ;
    final user = currentUser;//this is the getter of authuser
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    if(user!=null){
      return user;
    }
    else{
     throw UserNotLoggedInAuthException();
    }
    }
    on FirebaseAuthException catch(e){
        
            switch(e.code){
             case "wrong-password":
             throw WrongPasswordAuthException();
             case "invalid-email":
             throw InvalidEmailAuthException();
             case "user-not-found":
             throw UserNotFoundAuthException();
             case "email-already-in-use":
             throw EmailAlreadyInUseAuthException();
             default: 
            
             throw GenericAuthException();
            }
    }
   
              
  }

  @override
  Future<AuthUser> Login({required email, required password})async {
  try{ 
   await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  final user =currentUser;
   if(user!=null){
    return user;
   }
   else{
   throw UserNotLoggedInAuthException();
   }
  }
  on FirebaseAuthException catch(e){
      switch(e.code){
             case "wrong-password":
             throw WrongPasswordAuthException();
             case "invalid-email":
             throw InvalidEmailAuthException();
             case "user-not-found":
             throw UserNotFoundAuthException();
             default: 
             throw GenericAuthException();
            }
  }
  }

  @override
  Future<void> Logout() async{
    await FirebaseAuth.instance.signOut();    
  }
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;//this line gets user from firebase
    if(user!=null){
    return AuthUser.fromfirebase(user);//this line converts user to authuser for UI
  }
  else{
    return null;
  }
  }
  @override
  Future<void> SendEmailVerification() async {
   final user = FirebaseAuth.instance.currentUser;
   if(user!=null) {
   await user.sendEmailVerification();
     } 
     else{
     throw UserNotLoggedInAuthException();
     }
     }
     
       @override
       Future<void> initialize() async{
        await Firebase.initializeApp(
          
                   options:  DefaultFirebaseOptions.currentPlatform,
          );
       }

}