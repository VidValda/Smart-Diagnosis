import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_test/src/models/userModel.dart';
import 'package:provider/provider.dart';

class GoogleService {
  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      "email",
    ],
  );

  static Future<UserCredential> singInWithGoogle(BuildContext context) async {
    final userModel = Provider.of<UserModel>(context);
    try {
      final account = await _googleSignIn.signIn();
      final googleKey = await account.authentication;

      final GoogleAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleKey.accessToken,
        idToken: googleKey.idToken,
      );

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(googleAuthCredential);
      userModel.user = userCredential;
      Navigator.pushReplacementNamed(context, "map");
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {}
  }
}
