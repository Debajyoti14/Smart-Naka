import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final bool obscureText;
  final TextEditingController? controller;
  final Function? onChanged;
  final FormFieldSetter? onSaved;
  final FormFieldValidator? validator;
  final int? initialValue;
  final String hintText;
  const CustomTextField({
    super.key,
    this.obscureText = false,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.initialValue,
    required this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.white,
      decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 7,
            horizontal: 13,
          ),
          hintText: hintText),
      onSaved: onSaved,
      validator: validator,
    );
  }
}
