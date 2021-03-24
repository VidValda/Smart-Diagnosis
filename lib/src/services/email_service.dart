import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in_test/src/models/userModel.dart';
import 'package:provider/provider.dart';

class EmailService {
  static FirebaseAuth _emailInstance = FirebaseAuth.instance;

  static Future<UserCredential> signInWithEmail(
      String email, String password, BuildContext context) async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    try {
      final UserCredential userCredential = await _emailInstance
          .signInWithEmailAndPassword(email: email, password: password);
      userModel.user = userCredential;
      Navigator.pushReplacementNamed(context, "map");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No se encontró usuario.';
      } else if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta.';
      }
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }
  }

  static Future<UserCredential> registerWithEmail(
      String email, String password, BuildContext context) async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    try {
      final UserCredential userCredential = await _emailInstance
          .createUserWithEmailAndPassword(email: email, password: password);
      userModel.user = userCredential;
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'La contraseña es demasiado débil.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Esta cuenta ya existe con este email.';
      } else if (e.code == "user-not-found") {
        message = "El usuartestio no se encontró";
      }
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> logOut(String email, String password) async {
    try {
      return await _emailInstance.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
