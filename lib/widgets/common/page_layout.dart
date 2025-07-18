import 'package:flutter/material.dart';
import '../../core/theme/app_modifiers.dart';

/// StandardPageLayout - Wrapper widget voor consistente pagina layout
/// Zorgt voor standaard 16px horizontal padding op alle pagina's
class StandardPageLayout extends StatelessWidget {
  final Widget child;
  final EdgeInsets? customPadding;
  final bool scrollable;
  final ScrollPhysics? physics;

  const StandardPageLayout({
    super.key,
    required this.child,
    this.customPadding,
    this.scrollable = true,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = customPadding ?? AppModifiers.pagePadding;
    
    if (scrollable) {
      return SingleChildScrollView(
        physics: physics,
        padding: effectivePadding,
        child: child,
      );
    } else {
      return Padding(
        padding: effectivePadding,
        child: child,
      );
    }
  }
}

/// PagePadding - Voor als je alleen de horizontal padding wilt
class PagePadding extends StatelessWidget {
  final Widget child;
  final bool onlyHorizontal;

  const PagePadding({
    super.key,
    required this.child,
    this.onlyHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: onlyHorizontal 
          ? AppModifiers.pagePaddingHorizontal
          : AppModifiers.pagePadding,
      child: child,
    );
  }
}