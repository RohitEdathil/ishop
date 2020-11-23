import 'package:flutter/material.dart';

class FancyTextFieldOne extends StatefulWidget {
  final String placeholder;
  final bool isObscured;
  final TextEditingController controller;

  FancyTextFieldOne({this.placeholder, this.controller, this.isObscured});

  @override
  _FancyTextFieldOneState createState() => _FancyTextFieldOneState();
}

class _FancyTextFieldOneState extends State<FancyTextFieldOne> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
          hintText: widget.placeholder,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple, width: 2))),
      obscureText: widget.isObscured == null ? false : true,
    );
  }
}
