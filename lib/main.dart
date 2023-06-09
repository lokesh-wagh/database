import 'package:database/view/newnote_view.dart';
import 'package:database/view/notes_view.dart';
import 'constant/route.dart';
import 'view/login_view.dart';
import 'view/verify_view.dart';
import'package:database/view/register_view.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import  'package:firebase_core/firebase_core.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
    
        primarySwatch: Colors.purple,
      ),
      home: const homepage(),
      routes: {
        login:(context) => const login_view(),

        verify:(context) => const verify_view(),
        register:(context) => const register_view(),
        notes:(context) => const notes_view(),
        newnote:(context)=>const newnote_view(),
      },
    ),);
}

class homepage extends StatelessWidget {
  const homepage({super.key});

    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body:  FutureBuilder (
      future:   Firebase.initializeApp(
          
          options:  DefaultFirebaseOptions.currentPlatform,
          ),
      builder: (context, snapshot){
         switch(snapshot.connectionState){
          case ConnectionState.done:
         return const login_view();
         
         
          default:
          return const Center(child: Text("loading..."),);
        
         
        }
      }
    )
  );
}
}
