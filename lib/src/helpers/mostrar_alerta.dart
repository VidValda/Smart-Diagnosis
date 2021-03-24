import 'package:flutter/material.dart';

crearAlerta(String texto, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Text(
        texto,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline5,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK"),
        ),
      ],
    ),
  );
}
