import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';


class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Register User
  Future register(
      String email, String password) async {
    UserCredential userCredential =
        await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user?.sendEmailVerification();
    

    return userCredential.user;
  }

// Sign In User
  Future signin(
      String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user?.emailVerified ?? false) {
      
      
      return userCredential.user;
    } else {
      return null;
    }
  }

  //reset password
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  //send verification code
  Future<void> sendVerificationCode(String email) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      // Handle exceptions if needed
    }
  }

  //signout
  Future signOut() async {
    try {
      return firebaseAuth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
