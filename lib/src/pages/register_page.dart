import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in_test/src/models/signInRegister.dart';
import 'package:google_sign_in_test/src/services/google_service.dart';
import 'package:google_sign_in_test/src/widgets/blue_button.dart';
import 'package:google_sign_in_test/src/widgets/blue_header_1.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              BackgroundHeader(),
              FormDetails(),
            ],
          ),
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}

class FormDetails extends StatelessWidget {
  const FormDetails({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 107),
          Text(
            "Tu doctor en línea",
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 8),
          Text(
            "Contacta con cientos de doctores,\n ellos están esperando tus consultas.",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          TextFields(),
          LoginRegisterButtons(),
          SizedBox(height: 15),
          Center(
            child: Text(
              "o\nIngresa con tus redes sociales",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
          SocialButtons(),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                "¿Olvidaste tu contraseña?",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3397FF),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextFields extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final signInModel =
        Provider.of<SignInRegisterModel>(context, listen: false);
    signInModel.formKey = _formKey;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          Text(
            "Correo",
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.bold),
          ),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "ejemplo@correo.com",
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (!isEmail(value)) {
                return "Email incorrecto";
              }
              return null;
            },
            onSaved: (newValue) {
              signInModel.email = newValue.trim();
            },
          ),
          SizedBox(height: 30),
          Text(
            "Contraseña",
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.bold),
          ),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "**************",
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            validator: (value) {
              if (value.length < 6) {
                return "La contraseña debe tener más de 6 carácteres";
              }
              return null;
            },
            onSaved: (newValue) {
              signInModel.password = newValue.trim();
            },
          ),
        ],
      ),
    );
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
}

class LoginRegisterButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 18),
        Hero(
            child: BlueButton(
              "Iniciar sesión",
              onPressed: () => _login(context),
            ),
            tag: "boton"),
        SizedBox(height: 6),
        BlueButton(
          "Regístrate",
          invert: true,
          onPressed: () => _register(context),
        ),
      ],
    );
  }

  void _login(BuildContext context) async {
    UserCredential user;
    final signInModel =
        Provider.of<SignInRegisterModel>(context, listen: false);
    final formState = signInModel.formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: signInModel.email,
          password: signInModel.password,
        );

        //TODO: Navegar a pantalla de inicio
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'No se encontró usuario.';
        } else if (e.code == 'wrong-password') {
          message = 'Contraseña incorrecta.';
        }
        final snackBar = SnackBar(content: Text(message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        print(e);
      }
    }
    print(user);
  }

  void _register(BuildContext context) async {
    final signInModel =
        Provider.of<SignInRegisterModel>(context, listen: false);
    final formState = signInModel.formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        UserCredential user =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: signInModel.email,
          password: signInModel.password,
        );
        // User currentUser = FirebaseAuth.instance.currentUser;
        // if (!currentUser.emailVerified) {
        //   await currentUser.sendEmailVerification();
        // }
        //TODO: Navegar a pantalla de inicio
        // Navigator.pushReplacementNamed(context, "home");
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
      } catch (e) {
        print(e);
      }
    }
  }
}

class SocialButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          highlightColor: Colors.transparent,
          icon: FaIcon(
            FontAwesomeIcons.facebook,
            size: 40,
            color: Color(0xFF3397FF),
          ),
          // onPressed: () => facebookSignIn(),
          onPressed: () {},
        ),
        SizedBox(width: 30),
        IconButton(
          highlightColor: Colors.transparent,
          icon: FaIcon(
            FontAwesomeIcons.google,
            size: 40,
            color: Color(0xFF3397FF),
          ),
          // onPressed: () {},
          onPressed: () async {
            await GoogleService.singInWithGoogle();
          },
        ),
      ],
    );
  }

  // Future<UserCredential> googleSignIn() async {
  //   try {
  //     final GoogleSignInAccount googleUser =
  //         await GoogleService.singInWithGoogle();

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final GoogleAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  // Future<UserCredential> facebookSignIn() async {
  //   try {
  //     final AccessToken result = await FacebookAuth.instance.login();
  //     final FacebookAuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(result.token);
  //     return await FirebaseAuth.instance
  //         .signInWithCredential(facebookAuthCredential);
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
}

class BackgroundHeader extends StatelessWidget {
  const BackgroundHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      child: Hero(child: BlueHeader1(), tag: "header"),
    );
  }
}
