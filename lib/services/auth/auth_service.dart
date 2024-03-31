import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //instance of firestore 
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //Sign in user
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      //Sign in
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      //adds a new document for the user in user's collection if doesn't already exists
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
      },SetOptions(merge: true));

      return userCredential;
    }
    //If any error is thrown
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //create a new user
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      //after creating a new user. Create a new document for the user in the user collection.
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
      });

      return userCredential;
    }
    //If any error is thrown
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //Sign out User
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
