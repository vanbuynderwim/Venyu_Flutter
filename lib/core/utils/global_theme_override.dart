import 'package:flutter/material.dart';
import '../theme/app_modifiers.dart';

/// Global theme override to ensure no ripple effects anywhere
class GlobalThemeOverride extends StatelessWidget {
  final Widget child;

  const GlobalThemeOverride({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        // Global splash factory
        splashFactory: NoSplash.splashFactory,
        
        // Remove all interaction colors
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        
        // Update color scheme
        colorScheme: Theme.of(context).colorScheme.copyWith(
          surfaceTint: Colors.transparent,
        ),
        
        // Override all button themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
            ),
          ),
        ),
        
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            foregroundColor: Theme.of(context).colorScheme.primary,
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
            ),
          ),
        ),
        
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        
        // Override Material and InkWell behavior
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: child,
    );
  }
}