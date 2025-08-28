// /workspaces/finqly/lib/theme/colors.dart
import 'package:flutter/material.dart';

/// Centralized color definitions for the Finqly app.
/// Use these constants instead of hardcoding colors in widgets.
class AppColors {
  // --- Brand ---
  static const Color primary      = Color(0xFF4C4C9D); // Indigo/Purple brand
  static const Color accentPurple = Color(0xFF9E80FF);

  // --- Light backgrounds & surfaces ---
  static const Color background      = Color(0xFFF4F6FA); // Scaffold background
  static const Color cardBackground  = Colors.white;       // Card/surface
  static const Color inputBackground = Color(0xFFF0F0F5);  // TextField fill

  // --- Borders & Dividers ---
  static const Color border  = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFCCCCCC);

  // --- Text ---
  static const Color textPrimary   = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF555555);
  static const Color textMuted     = Color(0xFF888888);

  // --- Status ---
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color danger  = Color(0xFFF44336);
  static const Color info    = Color(0xFF2196F3);

  // --- Dark theme helpers ---
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard       = Color(0xFF1E1E1E);
  static const Color darkText       = Color(0xFFEAEAEA);
  static const Color darkMuted      = Color(0xFF9E9E9E);
}
