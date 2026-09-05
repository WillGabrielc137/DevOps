import 'package:flutter/material.dart';

class AppTheme {
  static const Color purpleDark = Color(0xFF4A148C);
  static const Color purpleMedium = Color(0xFF6A1B9A);
  static const Color purpleLight = Color(0xFFBA68C8);

  static const Color white = Colors.white;
  static const Color greyText = Colors.grey;

  static LinearGradient mainGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF4A148C),
      Color(0xFF6A1B9A),
      Color(0xFFBA68C8),
    ],
  );

  static TextStyle titleTextStyle = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle subtitleTextStyle = const TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static ButtonStyle mainButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: purpleDark,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    textStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  );

  static InputDecoration inputDecoration({required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      border: InputBorder.none,
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
    );
  }

  static ButtonStyle socialButtonStyle(Color start, Color end) {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      backgroundColor: Colors.transparent,
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
