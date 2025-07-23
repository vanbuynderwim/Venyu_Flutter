import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

/// A reusable scaffold for views that are displayed within tabs
/// Handles platform differences and large titles automatically
class TabViewScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool scrollable;

  const TabViewScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      cupertino: (_, __) => _buildCupertinoView(),
      material: (_, __) => _buildMaterialView(),
    );
  }

  Widget _buildCupertinoView() {
    if (scrollable) {
      return CupertinoPageScaffold(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text(title),
              trailing: actions != null ? Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              ) : null,
            ),
            SliverFillRemaining(
              child: body,
            ),
          ],
        ),
      );
    } else {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(title),
          trailing: actions != null ? Row(
            mainAxisSize: MainAxisSize.min,
            children: actions!,
          ) : null,
        ),
        child: body,
      );
    }
  }

  Widget _buildMaterialView() {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        actions: actions,
      ),
      body: body,
    );
  }
}