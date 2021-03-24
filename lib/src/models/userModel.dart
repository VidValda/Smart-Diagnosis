import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  UserCredential _user;

  UserCredential get user => this._user;
  set user(UserCredential user) {
    _user = user;
  }
}
