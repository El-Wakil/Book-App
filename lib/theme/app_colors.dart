import 'package:flutter/material.dart';

class AppColors {
  // Dark Mode Primary colors with glassmorphism
  static const Color primary = Color(0xFF8B5FFF);
  static const Color primaryDark = Color(0xFF6B3FDF);
  static const Color primaryLight = Color(0xFFAB7FFF);

  // Dark Mode Secondary colors with neon accents
  static const Color secondary = Color(0xFFFF6B9D);
  static const Color secondaryDark = Color(0xFFE5487D);
  static const Color secondaryLight = Color(0xFFFF8EBD);

  // Dark Mode Accent colors with cyan glow
  static const Color accent = Color(0xFF00FFFF);
  static const Color accentDark = Color(0xFF00D5D5);
  static const Color accentLight = Color(0xFF4DFFFF);

  // Dark Mode Background colors
  static const Color background = Color(0xFF0A0A0F);
  static const Color backgroundSecondary = Color(0xFF111116);
  static const Color surface = Color(0xFF1A1A20);
  static const Color surfaceVariant = Color(0xFF202028);
  static const Color glass = Color(0x20FFFFFF);
  static const Color glassStrong = Color(0x30FFFFFF);

  // Dark Mode Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8B8C8);
  static const Color textLight = Color(0xFF808090);

  // Dark Mode Glassmorphism Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight, accent],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight, primary],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentLight, primary],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, backgroundSecondary, Color(0xFF050508)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x30FFFFFF), Color(0x10FFFFFF)],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x40FFFFFF), Color(0x20FFFFFF), Color(0x10FFFFFF)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x80000000), Color(0x40000000), Color(0x60000000)],
  );

  // Glassmorphism Box Decoration
  static BoxDecoration get glassContainer => BoxDecoration(
    gradient: glassGradient,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Color(0x30FFFFFF), width: 1),
    boxShadow: [
      BoxShadow(color: Color(0x40000000), blurRadius: 20, offset: Offset(0, 8)),
      BoxShadow(
        color: Color(0x10FFFFFF),
        blurRadius: 10,
        offset: Offset(0, -2),
      ),
    ],
  );

  static BoxDecoration get cardDecoration => BoxDecoration(
    gradient: cardGradient,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Color(0x20FFFFFF), width: 1),
    boxShadow: [
      BoxShadow(color: Color(0x60000000), blurRadius: 15, offset: Offset(0, 5)),
    ],
  );
}
