import 'package:flutter/material.dart';

/// Venyu App Colors - Exact match with Swift Theme.swift
class AppColors {
  AppColors._();

  // Base colors
  static const Color alabasterWhite = Color(0xFFFAFAFA);
  static const Color softCloudGray = Color(0xFFF5F5F5);

  // Primary colors (7 shades of blue/purple)
  static const Color primair1Galaxy = Color(0xFF020249);
  static const Color primair2Midnight = Color(0xFF2C2C8C);
  static const Color primair3Berry = Color(0xFF5252DB);
  static const Color primair4Lilac = Color(0xFF7171FF);
  static const Color primair5Lavender = Color(0xFFB6B6FF);
  static const Color primair6Periwinkel = Color(0xFFE6E6FF);
  static const Color primair7Pearl = Color(0xFFFAFAFF);

  // Secondary colors (7 shades of grey/black)
  static const Color secundair1Deepblack = Color(0xFF121212);
  static const Color secundair2Offblack = Color(0xFF383939);
  static const Color secundair3Slategray = Color(0xFF6A6C6B);
  static const Color secundair4Quicksilver = Color(0xFF9D9F9D);
  static const Color secundair5Pinball = Color(0xFFB8B8B7);
  static const Color secundair6Rocket = Color(0xFFD1D1D1);
  static const Color secundair7Cascadingwhite = Color(0xFFEBEAEA);

  // Accent colors (4 shades of orange/red)
  static const Color accent1Tangerine = Color(0xFFFF6855);
  static const Color accent2Coral = Color(0xFFFF978A);
  static const Color accent3Peach = Color(0xFFFFC4BD);
  static const Color accent4Bluch = Color(0xFFFFF0F0);

  // Action colors (special colors for interactions)
  //static const Color me = Color(0xFF14AE5C);
  //static const Color need = Color(0xFF30B0C7);
  //static const Color know = Color(0xFFFF9500);
  //static const Color na = Color(0xFFFF6955);

  //static const Color me = Color(0xFFb1cd5d);
  //static const Color need = Color(0xFF6bb4db);
  //static const Color know = Color(0xFFe8ab6d);
  //static const Color na = Color(0xFFea867e);

//static const Color me = Color(0xFF8ac926);
//static const Color need = Color(0xFF1982c4);
//static const Color know = Color(0xFFffca3a);
//static const Color na = Color(0xFFff595e);

static const Color me = Color(0xFF7fb800);
static const Color need = Color(0xFF00a6ed);
static const Color know = Color(0xFFffb400);
static const Color na = Color(0xFFf6511d);

  // Brand colors
  static const Color linkedIn = Color(0xFF0A66C2);

  // Convenience getters for common usage
  static Color get primary => primair4Lilac;
  static Color get primaryDark => primair1Galaxy;
  static Color get primaryLight => primair6Periwinkel;
  
  static Color get secondary => secundair3Slategray;
  static Color get secondaryDark => secundair1Deepblack;
  static Color get secondaryLight => secundair6Rocket;
  
  static Color get accent => accent1Tangerine;
  static Color get accentLight => accent3Peach;
  
  static Color get background => primair7Pearl;
  static Color get surface => softCloudGray;
  static Color get white => Colors.white;
  static Color get black => secundair1Deepblack;

  // Text colors
  static Color get textPrimary => secundair2Offblack;
  static Color get textSecondary => secundair3Slategray;
  static Color get textLight => secundair4Quicksilver;
  static Color get textOnPrimary => white;
  static Color get textOnAccent => white;

  // Status colors
  static Color get success => me;
  static Color get warning => know;
  static Color get error => na;
  static Color get info => need;
  
  // Dark mode specific colors
  static Color get backgroundDark => secundair1Deepblack;
  static Color get surfaceDark => secundair2Offblack;
  
  // Context-aware color getters
  static Color backgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? backgroundDark : background;
  }
  
  static Color surfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? surfaceDark : white;
  }
  
  static Color textPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? white : textPrimary;
  }
  
  static Color textSecondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? secundair5Pinball : textSecondary;
  }
}