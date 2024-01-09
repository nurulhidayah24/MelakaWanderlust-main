import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:melaka_wanderlust/pages/home.dart';
import 'package:melaka_wanderlust/pages/login_register.dart';

import '../pages/login.dart';
import '../pages/register.dart';


//class AuthPage{

//  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign up method
//  Future<User?> signUpWithEmailAndPassword(String email, String password) async{
    
//    try {
//    UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//      return credential.user;
//    } catch (e) {
//      print("Error occured");
//    }
//    return null;
//  }

  // login method
//  Future<User?> signInWithEmailAndPassword(String email, String password) async{

//    try {
//      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
//      return credential.user;
//    } catch (e) {
//      print("Error occured");
//    }
//    return null;
//  }
//}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?> (
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user logged in
          if (snapshot.hasData) {
            return HomePage();
          }
          // user NOT logged in
          else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
