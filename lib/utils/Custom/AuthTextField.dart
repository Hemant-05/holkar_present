import 'package:flutter/material.dart';
import 'package:holkar_present/utils/Coolers.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.isObscure, required this.inputType});

  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final TextInputType inputType;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  OutlineInputBorder _border([Color color = Colors.black]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isObscure,
      keyboardType: widget.inputType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 22,vertical: 18),
          hintText: widget.hintText,
          fillColor: white,
          filled: true ,
          disabledBorder: _border(),
        enabledBorder: _border(),
        border: _border(),
        errorBorder: _border(Colors.red),
        focusedBorder: _border()
      ),
    );
  }
}
