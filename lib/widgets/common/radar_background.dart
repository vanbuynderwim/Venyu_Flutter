import 'package:flutter/material.dart';

/// A reusable radar background widget that adapts to light/dark theme.
/// 
/// Displays a full-screen radar pattern background with:
/// - Light theme: Regular colored radar image
/// - Dark theme: Greyscale radar image with reduced opacity
/// 
/// Used in onboarding and registration completion screens.
class RadarBackground extends StatelessWidget {
  /// Opacity for the dark theme image (default: 0.4)
  final double darkModeOpacity;
  
  const RadarBackground({
    super.key,
    this.darkModeOpacity = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Positioned.fill(
      child: isDarkMode
          ? Opacity(
              opacity: darkModeOpacity,
              child: ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0,      0,      0,      1, 0,
                ]),
                child: Image.asset(
                  'assets/images/visuals/radar_dark.png',
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Image.asset(
              'assets/images/visuals/radar.png',
              fit: BoxFit.cover,
            ),
    );
  }
}