import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final String text;
  final bool invert;
  final void Function() onPressed;
  const BlueButton(
    this.text, {
    this.invert = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w800,
          color: invert ? Color(0xFF3397FF) : Colors.white,
        ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(double.infinity, 48),
        ),
        side: MaterialStateProperty.all(
          BorderSide(
            color: Color(0xFF3397FF),
            width: 1.5,
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          invert ? Colors.white : Color(0xFF3397FF),
        ),
      ),
    );
  }
}
