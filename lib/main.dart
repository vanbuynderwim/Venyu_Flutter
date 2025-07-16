import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/supabase_constants.dart';
import 'models/test_models.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Test models
  TestModels.runTests();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );
  
  runApp(const VenyuApp());
}

class VenyuApp extends StatelessWidget {
  const VenyuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Venyu',
      theme: AppTheme.theme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venyu'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Title with Graphie font
            Text(
              'venyu',
              style: AppTextStyles.appTitle,
            ),
            const SizedBox(height: 8),
            
            // App Subtitle with Graphie font
            Text(
              'Make the net work',
              style: AppTextStyles.appSubtitle,
            ),
            const SizedBox(height: 32),
            
            // Typography demonstration
            Text('Typography Scale:', style: AppTextStyles.headline),
            const SizedBox(height: 16),
            
            Text('Extra Large Title', style: AppTextStyles.extraLargeTitle),
            Text('Large Title', style: AppTextStyles.largeTitle),
            Text('Title 1', style: AppTextStyles.title1),
            Text('Title 2', style: AppTextStyles.title2),
            Text('Title 3', style: AppTextStyles.title3),
            Text('Headline', style: AppTextStyles.headline),
            Text('Subheadline', style: AppTextStyles.subheadline),
            Text('Body text', style: AppTextStyles.body),
            Text('Callout', style: AppTextStyles.callout),
            Text('Footnote', style: AppTextStyles.footnote),
            Text('Caption 1', style: AppTextStyles.caption1),
            Text('Caption 2', style: AppTextStyles.caption2),
            const SizedBox(height: 32),
            
            // Color demonstration
            Text('Color Palette:', style: AppTextStyles.headline),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ColorBox('Primary', AppColors.primary),
                _ColorBox('Secondary', AppColors.secondary),
                _ColorBox('Accent', AppColors.accent),
                _ColorBox('Me', AppColors.me),
                _ColorBox('Need', AppColors.need),
                _ColorBox('Know', AppColors.know),
                _ColorBox('N/A', AppColors.na),
              ],
            ),
            const SizedBox(height: 32),
            
            // Button demonstration
            Text('Buttons:', style: AppTextStyles.headline),
            const SizedBox(height: 16),
            
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Elevated'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  final String name;
  final Color color;
  
  const _ColorBox(this.name, this.color);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.secondaryLight),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: AppTextStyles.caption1),
      ],
    );
  }
}