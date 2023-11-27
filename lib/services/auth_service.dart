import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_details/models/userModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final container = ProviderContainer();

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register User
  Future register(String email, String password, String division,
      String district, String firstName, String lastName) async {
    UserCredential userCredential =
        await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    //create database
    UserModel userModel;

    if (userCredential.additionalUserInfo!.isNewUser) {
      userModel = UserModel(
        firstname: firstName,
        lastname: lastName,
        email: email,
        uid: userCredential.user!.uid,
        division: division,
        district: district,
      );

      await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());
    } else {
      userModel = await getUserData(userCredential.user!.uid).first;
    }

    return userCredential.user;
  }

  Stream<UserModel> getUserData(String uid) {
    return _firestore.collection("users").doc(uid).snapshots().map(
          (event) => UserModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }

// Sign In User
  Future signin(String email, String password, WidgetRef ref) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    String userUid = userCredential.user!.uid;
 
    ref.read(userProvider.notifier).login(userUid);

   
   

    return userCredential.user;
  }

  //reset password
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
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

class UserState extends StateNotifier<String?> {
  UserState() : super(null); // The initial state is null

  void login(String uid) {
    state = uid;
  }
}

final userProvider = StateNotifierProvider<UserState, String?>((ref) {
  return UserState();
});
