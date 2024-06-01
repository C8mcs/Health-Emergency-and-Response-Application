import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Color hintTextColor;
  final Color textColor;
  final Color textFieldColor;
  final Function(String)? onChanged;
  final Widget? suffixIcon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.hintTextColor,
    required this.textColor,
    required this.textFieldColor,
    this.onChanged,
    this.suffixIcon,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText && _obscureText,
      style: TextStyle(color: widget.textColor),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: widget.hintTextColor),
        filled: true,
        fillColor: widget.textFieldColor,
        suffixIcon: widget.obscureText
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: widget.suffixIcon ??
                    Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: widget.hintTextColor,
                    ),
              )
            : null,
      ),
    );
  }
}
