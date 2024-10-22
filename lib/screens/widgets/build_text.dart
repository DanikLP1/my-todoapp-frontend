import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  const BuildText({
    required this.text,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
    required this.color,
    required this.fontSize,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
      style: GoogleFonts.roboto(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
