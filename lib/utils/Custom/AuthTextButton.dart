import 'package:flutter/material.dart';

class AuthTextButton extends StatelessWidget {
  const AuthTextButton({super.key, required this.fun, required this.text});

  final VoidCallback fun;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: fun,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
