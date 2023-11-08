import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latihan/Service%20API/api.dart';
import 'package:latihan/Model/firebase_user_model.dart';
import 'package:latihan/Model/loading_model.dart';
import 'package:latihan/Model/user_model.dart';

class UserViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void changeState(ViewState s) {
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

  Future<void> getUserdata() async {
    final currentuser = FirebaseAuth.instance.currentUser!;
    try {
      final data = await FirebaseAPI().getData(uid: currentuser.uid);
      changeState(ViewState.done);
    } catch (e) {
      changeState(ViewState.error);
    }
  }

  void addViewModel({
    required String firstname,
    required String email,
    required String noHp,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
    notifyListeners();
    await FirebaseAPI().putData(
        uid: user!.uid,
        userData: UserModel(firstname: firstname, email: email, noHp: noHp));
  }
}
