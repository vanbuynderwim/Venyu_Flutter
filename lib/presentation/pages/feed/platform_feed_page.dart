import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class PlatformFeedPage extends StatefulWidget {
  const PlatformFeedPage({super.key});

  @override
  State<PlatformFeedPage> createState() => _PlatformFeedPageState();
}

class _PlatformFeedPageState extends State<PlatformFeedPage> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoPage();
    } else {
      return _buildMaterialPage();
    }
  }

  Widget _buildCupertinoPage() {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Venyu'),
        backgroundColor: CupertinoColors.systemBackground,
        border: Border(bottom: BorderSide.none),
      ),
      child: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.home,
                size: 64,
                color: CupertinoColors.systemGrey,
              ),
              SizedBox(height: 16),
              Text(
                'Feed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Deze pagina wordt later geïmplementeerd',
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venyu'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Feed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Deze pagina wordt later geïmplementeerd',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}