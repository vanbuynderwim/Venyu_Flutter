import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../core/theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/index.dart';

/// Simplified ShowcaseView that works
class ShowcaseView extends StatelessWidget {
  const ShowcaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Venyu UI Showcase'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // App Title
            Text('venyu', style: AppTextStyles.appTitle),
            const SizedBox(height: 8),
            Text('Make the net work', style: AppTextStyles.appSubtitle),
            const SizedBox(height: 32),
            
            // Typography
            _buildSection('Typography', [
              Text('Large Title', style: AppTextStyles.largeTitle),
              Text('Title 1', style: AppTextStyles.title1),
              Text('Title 2', style: AppTextStyles.title2),
              Text('Headline', style: AppTextStyles.headline),
              Text('Body', style: AppTextStyles.body),
              Text('Caption', style: AppTextStyles.caption1),
            ]),
            
            // Colors
            _buildSection('Colors', [
              _buildColorRow('Primary', AppColors.primary),
              _buildColorRow('Secondary', AppColors.secondary),
              _buildColorRow('Accent', AppColors.accent),
            ]),
            
            // Buttons
            _buildSection('Buttons', [
              ActionButton(
                label: 'Primary Button',
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              ActionButton(
                label: 'Secondary Button',
                style: ActionButtonType.secondary,
                onPressed: () {},
              ),
            ]),
            
            // Tags
            _buildSection('Tags', [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  TagView(
                    id: '1',
                    label: 'Flutter',
                    emoji: '💙',
                  ),
                  TagView(
                    id: '2', 
                    label: 'Dart',
                    icon: 'bulb',
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.headline),
        const SizedBox(height: 16),
        ...children,
        const SizedBox(height: 32),
      ],
    );
  }
  
  Widget _buildColorRow(String name, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 16),
          Text(name, style: AppTextStyles.body),
        ],
      ),
    );
  }
}