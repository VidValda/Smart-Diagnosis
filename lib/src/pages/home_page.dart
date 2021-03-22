import 'package:flutter/material.dart';
import 'package:google_sign_in_test/src/widgets/blue_button.dart';
import 'package:google_sign_in_test/src/widgets/blue_header_1.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Stack(
            children: [
              BackgroundHeader(),
              Center(
                child: Details(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Details extends StatelessWidget {
  const Details({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 78),
        Text(
          "TuDocEnLinea",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 10,
          ),
          child: Text(
            "Todos los doctores, clinicas, farmacias al alcance de tu mano",
            style: TextStyle(
              color: Colors.black38,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 78),
        Container(
          child: Hero(
              child: BlueButton(
                "¡Empecemos!",
                onPressed: () {
                  Navigator.of(context).pushNamed("register");
                },
              ),
              tag: "boton"),
          width: 200,
        ),
      ],
    );
  }
}

class BackgroundHeader extends StatelessWidget {
  const BackgroundHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Hero(child: BlueHeader1(), tag: "header"),
    );
  }
}
