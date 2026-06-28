import 'package:flutter/material.dart';

/// Raw brand hex values — single source of truth for the SPA color palette.
///
/// Tuned from the SPA 2026 poster (navy + cyan glow) and Leger des Heils red.
class AppPalette {
  AppPalette._();

  // SPA 2026 poster
  static const spaNavy = Color(0xFF0B1B2E);
  static const spaCyan = Color(0xFF2EC4D6);
  static const spaNavyMuted = Color(0xFF1A2D42);

  // Leger des Heils brand red
  static const saRed = Color(0xFFE31B23);

  // Supporting accent
  static const amber = Color(0xFFF5A623);

  // Neutrals
  static const onDark = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFF8FAFC);
  static const surfaceContainerLight = Color(0xFFEEF2F6);
  static const onSurfaceLight = Color(0xFF1A1A1A);
  static const onSurfaceVariantLight = Color(0xFF505050);
  static const outlineLight = Color(0xFFB0B8C4);

  static const surfaceDark = Color(0xFF0F1A28);
  static const surfaceContainerDark = Color(0xFF1A2D42);
  static const onSurfaceDark = Color(0xFFE8ECF0);
  static const onSurfaceVariantDark = Color(0xFFB0B8C4);
  static const outlineDark = Color(0xFF4A5568);

  // Feedback
  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFF57C00);
  static const error = Color(0xFFD32F2F);
}
