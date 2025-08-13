import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_spacing_theme.dart';

/// AppScaffold - Standardized scaffold with consistent horizontal padding
/// Background color is handled automatically by theme system
class AppScaffold extends StatelessWidget {
  final PlatformAppBar? appBar;
  final Widget body;
  final bool usePadding;
  final EdgeInsets? customPadding;
  final bool useSafeArea;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.usePadding = true,
    this.customPadding,
    this.useSafeArea = true,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    
    final content = usePadding
        ? Padding(
            padding: customPadding ?? spacing.pageHorizontalPadding,
            child: body,
          )
        : body;

    // PlatformScaffold doesn't support FAB, so use Material Scaffold when FAB is present
    // But we need to make it look exactly like PlatformScaffold
    if (floatingActionButton != null) {
      return PlatformScaffold(
        appBar: appBar,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: useSafeArea
            ? SafeArea(
                child: Stack(
                  children: [
                    content,
                    Positioned(
                      right: 32,
                      bottom: 32, // Above the tab bar
                      child: floatingActionButton!,
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  content,
                  Positioned(
                    right: 16,
                    bottom: 80, // Above the tab bar
                    child: floatingActionButton!,
                  ),
                ],
              ),
      );
    }

    return PlatformScaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: useSafeArea
          ? SafeArea(child: content)
          : content,
    );
  }
}

/// AppListScaffold - Specific variant for ListView-based screens
/// Automatically applies horizontal padding to ListView, background via theme
class AppListScaffold extends StatelessWidget {
  final PlatformAppBar? appBar;
  final List<Widget> children;
  final EdgeInsets? padding;

  const AppListScaffold({
    super.key,
    this.appBar,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    
    return PlatformScaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: padding ?? spacing.listViewPadding,
          children: children,
        ),
      ),
    );
  }
}