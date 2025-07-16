import 'package:flutter/material.dart';

class AppIconWidget extends StatelessWidget {
  final String iconPath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const AppIconWidget({
    super.key,
    required this.iconPath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      iconPath,
      width: width,
      height: height,
      color: color,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.broken_image,
          size: width ?? height ?? 24,
          color: color ?? Colors.grey,
        );
      },
    );
  }
}

// Extension to make icon usage even easier
extension AppIconExtension on String {
  Widget toIcon({
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    return AppIconWidget(
      iconPath: this,
      width: width,
      height: height,
      color: color,
      fit: fit,
    );
  }
}