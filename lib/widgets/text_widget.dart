import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {Key? key,
        required this.label,
        this.fontSize = 18,
        this.color,
        this.fontWeight, this.textAlign, this.textHeight})
      : super(key: key);

  final String label;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final double? textHeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      // textAlign: TextAlign.justify,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w500,
        height: textHeight??1.0
      ),
      textAlign: textAlign?? TextAlign.center,
    );
  }}
