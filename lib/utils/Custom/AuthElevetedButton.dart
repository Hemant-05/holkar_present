import 'package:flutter/material.dart';
import 'package:holkar_present/utils/Coolers.dart';

class AuthElevatedButton extends StatelessWidget {
  const AuthElevatedButton({super.key, required this.text, required this.fun});

  final String text;
  final VoidCallback fun;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: fun,
        style: ElevatedButton.styleFrom(
          backgroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 26, fontWeight: FontWeight.w600, color: black),
        ),
      ),
    );
  }
}
