import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier
{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //Sign in user
  Future<UserCredential> signInWithEmailAndPassword(String email,String password) async{
    try{
      //Sign in
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
    //If any error is thrown
    on FirebaseAuthException catch(e)
    {
      throw Exception(e.code);
    }
  }

  //create a new user
  Future<UserCredential> signUpWithEmailAndPassword(String email,String password) async{
    try{

      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
    //If any error is thrown
    on FirebaseAuthException catch(e)
    {
      throw Exception(e.code);
    }
  }

  //Sign out User
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}