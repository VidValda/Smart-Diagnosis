import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      "email",
    ],
  );

  static Future<UserCredential> singInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      final googleKey = await account.authentication;

      final GoogleAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleKey.accessToken,
        idToken: googleKey.idToken,
      );

      return await FirebaseAuth.instance
          .signInWithCredential(googleAuthCredential);
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
