import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  String text;
  String hintText;
  bool password;
  TextEditingController controller;
  FormFieldValidator<String> validator;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  FocusNode focusNode;
  FocusNode nextFocus;

  AppText(this.text, this.hintText,
      {this.password = false,
      this.controller,
      this.validator,
      this.keyboardType,
      this.textInputAction,
      this.focusNode,
      this.nextFocus});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: password,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: (String text) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      style: TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: text,
        hintText: hintText,
        labelStyle: TextStyle(
          fontSize: 25,
        ),
      ),
    );
  }
}
