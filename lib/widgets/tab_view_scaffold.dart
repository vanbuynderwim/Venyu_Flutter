import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TabViewScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const TabViewScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      cupertino: (_, __) => CupertinoPageScaffold(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text(title),
              trailing: actions != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions!,
                    )
                  : null,
            ),
            SliverFillRemaining(child: body),
          ],
        ),
      ),
      material: (_, __) => Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: actions,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: body,
          ),
        ),
      ),
    );
  }
}