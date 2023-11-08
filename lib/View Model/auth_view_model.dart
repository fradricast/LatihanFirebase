import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latihan/Service%20API/api.dart';
import 'package:latihan/Model/firebase_user_model.dart';
import 'package:latihan/Model/loading_model.dart';
import 'package:latihan/Model/login_model.dart';
import 'package:latihan/Model/user_model.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ViewState _state = ViewState.none;
  ViewState get state => _state;
  void changeState(ViewState s) {
    _state = s;
    notifyListeners();
  }

//create user object base on Firebase User
  FirebaseUser? _firebaseUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<FirebaseUser?> get user {
    return _auth.authStateChanges().map(_firebaseUser);
  }

//sign in email and address
  Future signInEmailPassword(LoginUser login) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: login.email.toString(),
              password: login.password.toString());
      User? user = userCredential.user;
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    }
  }

//register
  Future<void> signUp({
    required String email,
    required String password,
    required String noHp,
    required String firstname,
  }) async {
    changeState(ViewState.loading);
    final auth = FirebaseAuth.instance;
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = auth.currentUser;
      await FirebaseAPI().putUserData(
          uid: user!.uid,
          userData: UserModel(
            firstname: firstname,
            email: email,
            noHp: noHp,
          ));
      changeState(ViewState.done);
    } catch (e) {
      changeState(ViewState.error);
    }
  }

//sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
