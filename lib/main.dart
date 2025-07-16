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
      scrollBehavior: VenyuScrollBehavior(),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: VenyuScrollBehavior(),
          child: NoRippleTheme(
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
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
            
            // Button styles
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: AppButtonStyles.primary,
                  child: const Text('Primary'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: AppButtonStyles.secondary,
                  child: const Text('Secondary'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: AppButtonStyles.destructive,
                  child: const Text('Destructive'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: AppButtonStyles.success,
                  child: const Text('Success'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: AppButtonStyles.outlined,
                  child: const Text('Outlined'),
                ),
                TextButton(
                  onPressed: () {},
                  style: AppButtonStyles.text,
                  child: const Text('Text'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Small buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: AppButtonStyles.primarySmall,
                  child: const Text('Small'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: AppButtonStyles.primaryLarge,
                  child: const Text('Large'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Gradient button
            GradientButton(
              onPressed: () {},
              decoration: AppButtonStyles.primaryGradientDecoration,
              child: Text(
                'Gradient Button',
                style: AppTextStyles.headline.copyWith(color: AppColors.white),
              ),
            ),
            const SizedBox(height: 32),
            
            // Input field demonstration
            Text('Input Fields:', style: AppTextStyles.headline),
            const SizedBox(height: 16),
            
            TextFormField(
              decoration: AppInputStyles.base.copyWith(
                labelText: 'Name',
                hintText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              decoration: AppInputStyles.email.copyWith(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              decoration: AppInputStyles.search,
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              decoration: AppInputStyles.success.copyWith(
                labelText: 'Valid Input',
                hintText: 'This is valid',
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              decoration: AppInputStyles.base.copyWith(
                labelText: 'Error Input',
                hintText: 'This has an error',
                errorText: 'This field is required',
              ),
            ),
            const SizedBox(height: 32),
            
            // Layout demonstration
            Text('Layout Styles:', style: AppTextStyles.headline),
            const SizedBox(height: 16),
            
            Container(
              padding: AppModifiers.paddingMedium,
              decoration: AppLayoutStyles.containerElevated,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Card Layout', style: AppTextStyles.subheadline),
                  const SizedBox(height: 8),
                  Text('This is a card with elevation and rounded corners.', 
                       style: AppTextStyles.body),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: AppModifiers.paddingMedium,
              decoration: AppLayoutStyles.containerWithBorder,
              child: Row(
                children: [
                  Container(
                    padding: AppModifiers.paddingSmall,
                    decoration: AppLayoutStyles.badge,
                    child: Text('NEW', style: AppTextStyles.caption1.copyWith(
                      color: AppColors.white,
                    )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Container with border and badge', 
                               style: AppTextStyles.body),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Text layouts
            Text('Text Layouts:', style: AppTextStyles.headline),
            const SizedBox(height: 16),
            
            AppTextLayouts.centeredText('Centered Text', AppTextStyles.subheadline),
            const SizedBox(height: 8),
            
            AppTextLayouts.textWithBackground(
              text: 'Text with Background',
              style: AppTextStyles.callout,
              backgroundColor: AppColors.primaryLight,
            ),
            const SizedBox(height: 8),
            
            AppTextLayouts.textWithIcon(
              text: 'Text with Icon',
              icon: Icons.star,
              style: AppTextStyles.callout,
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