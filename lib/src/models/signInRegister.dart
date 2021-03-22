import 'package:flutter/material.dart';

class SignInRegisterModel with ChangeNotifier {
  bool _isValidEmail;
  bool _isValidPassword;
  GlobalKey<FormState> _formKey;
  String _email;
  String _password;

  bool get isValidEmail => this._isValidEmail;

  set isValidEmail(bool isValidEmail) {
    _isValidEmail = isValidEmail;
  }

  bool get isValidPassword => this._isValidPassword;

  set isValidPassword(bool isValidPassword) {
    _isValidPassword = isValidPassword;
  }

  GlobalKey<FormState> get formKey => this._formKey;

  set formKey(GlobalKey<FormState> formKey) {
    _formKey = formKey;
  }

  String get email => this._email;

  set email(String email) {
    _email = email;
  }

  String get password => this._password;

  set password(String password) {
    _password = password;
  }
}
