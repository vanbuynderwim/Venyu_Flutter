import 'package:flutter/material.dart';

/// A reusable radar background overlay widget with semi-transparent effect.
///
/// Displays a radar pattern background with:
/// - Fixed 50% opacity overlay
/// - Dark mode support with grayscale filter
/// - Graceful error handling
/// - Consistent positioning as Positioned.fill
///
/// Used in prompt flows where a semi-transparent radar effect is needed
/// over gradient backgrounds.
class RadarBackgroundOverlay extends StatelessWidget {
  /// Opacity for the radar overlay (default: 0.5)
  final double opacity;

  const RadarBackgroundOverlay({
    super.key,
    this.opacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Widget radarImage = Image.asset(
      'assets/images/visuals/radar.png',
      fit: BoxFit.cover,
      opacity: AlwaysStoppedAnimation(opacity),
      errorBuilder: (context, error, stackTrace) {
        // If image fails to load, just show nothing
        return const SizedBox.shrink();
      },
    );

    // Apply grayscale filter in dark mode
    if (isDarkMode) {
      radarImage = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          // Grayscale matrix - converts to grayscale
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0,      0,      0,      1, 0,
        ]),
        child: radarImage,
      );
    }

    return Positioned.fill(
      child: radarImage,
    );
  }
}