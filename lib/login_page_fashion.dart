import 'package:flutter/material.dart';

class LoginPageFashion {
  static const textColor = Colors.grey;

  static OutlineInputBorder _inputBorder({required Color color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        width: 4,
        color: color,
      ),
    );
  }

  static InputDecoration inputTextDecoration({required String hintText}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(20),
      hintStyle: const TextStyle(color: textColor),
      floatingLabelStyle: const TextStyle(color: textColor),
      hintText: hintText,
      fillColor: Colors.white,
      hoverColor: Colors.tealAccent,
      focusedBorder: _inputBorder(color: Colors.tealAccent),
      errorBorder: _inputBorder(color: Colors.redAccent),
      disabledBorder: _inputBorder(color: Colors.redAccent),
      enabledBorder: _inputBorder(color: textColor),
      focusedErrorBorder: _inputBorder(color: Colors.redAccent),
    );
  }
}
