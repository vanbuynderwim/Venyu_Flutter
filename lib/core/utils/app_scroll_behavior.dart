import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

/// Custom scroll behavior to remove overscroll effects
class AppScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Return child without any overscroll indicator
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // Use ClampingScrollPhysics to prevent overscroll
    return const ClampingScrollPhysics();
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}