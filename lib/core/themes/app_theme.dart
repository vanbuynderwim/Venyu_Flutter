import 'package:flutter/material.dart';
import 'dart:io';
import 'app_colors.dart';

class AppTheme {
  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;

  static ThemeData get lightTheme {
    if (isIOS) {
      return _iOSTheme;
    } else {
      return _androidTheme;
    }
  }

  static ThemeData get _iOSTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primair4Lilac,
        brightness: Brightness.light,
      ),
      useMaterial3: false, // iOS-like styling
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.black,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.tabBarSelected,
        unselectedItemColor: AppColors.tabBarUnselected,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 10),
        unselectedLabelStyle: TextStyle(fontSize: 10),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      splashFactory: NoSplash.splashFactory, // Remove splash animations
      highlightColor: Colors.transparent, // Remove highlight
      splashColor: Colors.transparent, // Remove splash
      scaffoldBackgroundColor: AppColors.white,
      cardColor: AppColors.white,
      dividerColor: AppColors.grey200,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: '.SF Pro Text',
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontFamily: '.SF Pro Text',
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: TextStyle(
          fontFamily: '.SF Pro Display',
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ThemeData get _androidTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primair4Lilac,
        brightness: Brightness.light,
      ),
      useMaterial3: true, // Material 3 for Android
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.tabBarSelected,
        unselectedItemColor: AppColors.tabBarUnselected,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      splashFactory: InkRipple.splashFactory, // Android ripple effect
      scaffoldBackgroundColor: AppColors.white,
      cardColor: AppColors.white,
      dividerColor: AppColors.grey200,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}