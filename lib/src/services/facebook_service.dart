import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in_test/src/models/userModel.dart';
import 'package:provider/provider.dart';

class FaceBookService {
  static FacebookAuth _facebookAuth = FacebookAuth.instance;
  static Future<UserCredential> signInwithFacebook(BuildContext context) async {
    final userModel = Provider.of<UserModel>(context);
    try {
      final AccessToken result = await _facebookAuth.login();
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.token);
      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
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
      await _facebookAuth.logOut();
    } catch (e) {
      print(e);
    }
  }
}
