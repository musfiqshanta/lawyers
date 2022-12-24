import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authservice {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future checkuser() async {
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
      } else {
        debugPrint('User is signed in!');
      }
    });
  }

  //Sign In anonimus

  Future signinAnn() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      debugPrint(e.toString());
      //return null;
    }
  }

  //Sign up for
  Future signup(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //  User user = result.user;
      // return _firebaseUsers(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//sign in
  Future signin(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      // User user = result.user;
      //return _firebaseUsers(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    }
  }

//sign out

  Future sinout() async {
    try {
      return await auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
