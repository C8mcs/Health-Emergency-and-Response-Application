import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLines;
  final bool enabled;
  final bool readOnly;

  const CustomTextField({
    required this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.minLines,
    this.maxLines,
    this.fillColor,
    required this.enabled,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                  color: fillColor, fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          TextFormField(
            minLines: minLines,
            maxLines: maxLines,
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            enabled: enabled,
            readOnly: readOnly,
            style: GoogleFonts.montserrat(
              textStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: labelText,
              labelStyle: GoogleFonts.montserrat(
                textStyle: TextStyle(color: Colors.white, fontSize: 15),
              ),
              filled: true,
              fillColor: fillColor,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: fillColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: fillColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MeasurementHeightWeight extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool enabled;
  final bool readOnly;

  const MeasurementHeightWeight({
    required this.labelText,
    required this.controller,
    required this.keyboardType,
    required this.enabled,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: TextFormField(
          enabled: enabled,
          readOnly: readOnly,
          controller: controller,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          keyboardType: keyboardType,
          autofocus: true,
          obscureText: false,
          style: GoogleFonts.montserrat(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          decoration: InputDecoration(
            labelText: labelText,
            filled: true,
            fillColor: const Color(0xFFD9D9D9),
            labelStyle: GoogleFonts.montserrat(
              textStyle: TextStyle(
                  color: Colors.red, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
