import 'package:flutter/material.dart';

/// App Animations - Consistent animation constants throughout the app
/// 
/// This class contains all animation-related constants including
/// durations, curves, and transition configurations.
class AppAnimations {
  AppAnimations._();

  /// Animation durations
  static const Duration instant = Duration.zero;
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration slower = Duration(milliseconds: 500);

  /// Common animation curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve entranceCurve = Curves.easeOut;
  static const Curve exitCurve = Curves.easeIn;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve emphasizedCurve = Curves.easeInOutCubicEmphasized;

  /// Transition durations
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Duration modalTransition = Duration(milliseconds: 250);
  static const Duration dialogTransition = Duration(milliseconds: 200);
  static const Duration bottomSheetTransition = Duration(milliseconds: 300);

  /// Interaction feedback durations
  static const Duration buttonPress = Duration(milliseconds: 100);
  static const Duration hoverFeedback = Duration(milliseconds: 150);
  static const Duration rippleAnimation = Duration(milliseconds: 200);

  /// Loading and shimmer durations
  static const Duration shimmer = Duration(milliseconds: 1500);
  static const Duration loadingSpinner = Duration(milliseconds: 800);
  static const Duration fadeTransition = normal;

  /// Helper method to create common transitions
  static Widget fadeTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation.drive(
        Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: defaultCurve),
        ),
      ),
      child: child,
    );
  }

  static Widget slideTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
          CurveTween(curve: defaultCurve),
        ),
      ),
      child: child,
    );
  }
}