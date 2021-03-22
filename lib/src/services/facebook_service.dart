// import 'package:google_sign_in/google_sign_in.dart';

// class GoogleService {
//   static GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: [
//       "email",
//     ],
//   );

//   static Future<GoogleSignInAccount> singInWithGoogle() async {
//     try {
//       final account = await _googleSignIn.signIn();
//       final googleKey = await account.authentication;
//       print(account);
//       print(googleKey.idToken);

//       // final signInWithGoogleEndpoint = Uri(
//       //   scheme: "https",
//       //   host: "google-apple-sign-in.herokuapp.com",
//       //   path: "/google",
//       // );

//       // final session = await http.post(
//       //   signInWithGoogleEndpoint,
//       //   body: {
//       //     "token": googleKey.idToken,
//       //   },
//       // );
//       // session.body;

//       return account;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   static Future signOut() async {
//     try {
//       await _googleSignIn.signOut();
//     } catch (e) {}
//   }
// }
