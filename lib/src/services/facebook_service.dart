import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FaceBookService {
  static FacebookAuth _facebookAuth = FacebookAuth.instance;
  static Future<UserCredential> signInwithFacebook() async {
    try {
      final AccessToken result = await _facebookAuth.login();
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.token);
      return await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
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
