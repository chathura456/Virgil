import 'package:flutter/material.dart';
import 'package:virgil/widgets/text_widget.dart';

Color myBackgroundColor = const Color(0xFF343541);
Color cardColor = const Color(0xFF444654);
Color newColor = const Color(0xFF17e1af);

final lightTheme = ThemeData(
  colorScheme: ThemeData.light().colorScheme.copyWith(
    tertiary: Colors.grey[100],
      onSurface: Colors.grey[100],
      onTertiary: const Color(0xFF17e1af),
      inversePrimary: Colors.white,
      background: Colors.white,
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: const Color(0xFF17e1af),
      onSecondary: const Color(0xFF17e1af),
    surface: const Color(0xFF17e1af).withOpacity(0.4),
  )
);

final darkTheme = ThemeData(
  colorScheme: ThemeData.dark(useMaterial3: true).colorScheme.copyWith(
    tertiary: const Color(0xFF444654),
    onTertiary: const Color(0xFF343541),
    inversePrimary: const Color(0xFF444654),
    background: const Color(0xFF343541),
      primary: const Color(0xFF343541),
      onPrimary: Colors.white,
      secondary: const Color(0xFF444654),
      surface: Colors.grey[100],
      onSecondary: Colors.white,
    onSurface: const Color(0xFF444654),
  )
);