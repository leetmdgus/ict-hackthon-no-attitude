
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFFF5252);
  static const secondary = Color(0xFFFFB300);
  static const background = Color(0xFFF8F9FF);
  static const text = Color(0xFF2D2D2D);
  static const textLight = Color(0xFF757575);
  static const error = Color(0xFFE53935);
  static const success = Color(0xFF43A047);

  static const gradientPrimary = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}