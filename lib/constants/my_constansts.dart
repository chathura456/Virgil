import 'package:flutter/material.dart';
import 'package:virgil/widgets/text_widget.dart';

Color myBackgroundColor = const Color(0xFF343541);
Color cardColor = const Color(0xFF444654);
Color newColor = const Color(0xFF17e1af);

final lightTheme = ThemeData.light(useMaterial3: true).colorScheme.copyWith(
  primary: Colors.white,
  onPrimary: Colors.black,
  secondary: const Color(0xFF17e1af),
  onSecondary: Colors.white
);

final darkTheme = ThemeData.dark(useMaterial3: true).colorScheme.copyWith(
    primary: const Color(0xFF343541),
    onPrimary: Colors.white,
    secondary: const Color(0xFF444654),
    onSecondary: Colors.white
);