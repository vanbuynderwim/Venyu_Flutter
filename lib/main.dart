import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/supabase_constants.dart';
import 'models/models.dart';
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
            
            // TagView demonstration
            const _TagViewDemo(),
            const SizedBox(height: 32),
            
            // OptionButton with TagViews demonstration
            const _OptionButtonWithTagsDemo(),
            const SizedBox(height: 32),
            
            // ProgressBar demonstration
            const _ProgressBarDemo(),
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
            const SizedBox(height: 32),
            
            // Interaction buttons demonstration
            Text('Interaction Buttons:', style: AppTextStyles.headline),
            const SizedBox(height: 16),
            
            // Individual interaction buttons
            InteractionButton(
              interactionType: InteractionType.thisIsMe,
              onPressed: () => debugPrint('This is me pressed'),
              width: double.infinity,
            ),
            const SizedBox(height: 12),
            
            InteractionButton(
              interactionType: InteractionType.lookingForThis,
              onPressed: () => debugPrint('Looking for this pressed'),
              width: double.infinity,
            ),
            const SizedBox(height: 12),
            
            InteractionButton(
              interactionType: InteractionType.knowSomeone,
              onPressed: () => debugPrint('Know someone pressed'),
              width: double.infinity,
            ),
            const SizedBox(height: 12),
            
            InteractionButton(
              interactionType: InteractionType.notRelevant,
              onPressed: () => debugPrint('Not relevant pressed'),
              width: double.infinity,
            ),
            const SizedBox(height: 16),
            
            // Interaction button row
            Text('Interaction Button Row:', style: AppTextStyles.subheadline),
            const SizedBox(height: 8),
            
            InteractionButtonRow(
              onInteractionPressed: (type) {
                debugPrint('Interaction button pressed: ${type.value}');
              },
              spacing: 12,
            ),
            const SizedBox(height: 32),
            
            // OptionButton demonstration
            Text('Option Buttons:', style: AppTextStyles.headline),
            const SizedBox(height: 16),
            
            // Single select example (like countries)
            Text('Single Select (Countries):', style: AppTextStyles.subheadline),
            const SizedBox(height: 8),
            
            _SingleSelectDemo(),
            const SizedBox(height: 24),
            
            // Multi select example (like meeting preferences)
            Text('Multi Select (Meeting Preferences):', style: AppTextStyles.subheadline),
            const SizedBox(height: 8),
            
            _MultiSelectDemo(),
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

/// Demo voor single select OptionButtons (zoals landen)
class _SingleSelectDemo extends StatefulWidget {
  @override
  State<_SingleSelectDemo> createState() => _SingleSelectDemoState();
}

class _SingleSelectDemoState extends State<_SingleSelectDemo> {
  String? selectedCountry;

  final List<SimpleOption> countries = [
    SimpleOption(
      id: 'be',
      title: 'België',
      icon: 'location',
      color: AppColors.textPrimary,
    ),
    SimpleOption(
      id: 'nl',
      title: 'Nederland',
      icon: 'location',
      color: AppColors.textPrimary,
    ),
    SimpleOption(
      id: 'fr',
      title: 'Frankrijk',
      icon: 'location',
      color: AppColors.textPrimary,
    ),
    SimpleOption(
      id: 'de',
      title: 'Duitsland',
      icon: 'location',
      color: AppColors.textPrimary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: countries.map((country) => 
        OptionButton(
          option: country,
          isSelected: selectedCountry == country.id,
          isMultiSelect: false,
          onSelect: () {
            setState(() {
              selectedCountry = country.id;
            });
            debugPrint('Selected country: ${country.title}');
          },
        ),
      ).toList(),
    );
  }
}

/// Demo voor multi select OptionButtons (zoals ontmoetingsvoorkeuren)
class _MultiSelectDemo extends StatefulWidget {
  @override
  State<_MultiSelectDemo> createState() => _MultiSelectDemoState();
}

class _MultiSelectDemoState extends State<_MultiSelectDemo> {
  Set<String> selectedPreferences = {};

  final List<SimpleOption> preferences = [
    SimpleOption(
      id: 'linkedin',
      title: 'LinkedIn',
      emoji: '💼',
      color: AppColors.primary,
    ),
    SimpleOption(
      id: 'video',
      title: 'Videocall',
      emoji: '📹',
      color: AppColors.primary,
    ),
    SimpleOption(
      id: 'phone',
      title: 'Telefoon',
      emoji: '📞',
      color: AppColors.primary,
    ),
    SimpleOption(
      id: 'office',
      title: 'Kantoor',
      emoji: '🏢',
      color: AppColors.primary,
    ),
    SimpleOption(
      id: 'coffee',
      title: 'Koffie',
      emoji: '☕',
      color: AppColors.primary,
      badge: 2,
    ),
    SimpleOption(
      id: 'lunch',
      title: 'Lunch',
      emoji: '🍽️',
      color: AppColors.primary,
    ),
    SimpleOption(
      id: 'walk',
      title: 'Wandeling',
      emoji: '🚶',
      color: AppColors.primary,
    ),
    SimpleOption(
      id: 'bike',
      title: 'Fietsen',
      emoji: '🚴',
      color: AppColors.primary,
      list: [
        Tag(id: '1', label: 'Recreatief', emoji: '😊'),
        Tag(id: '2', label: 'Sportief', icon: 'fitness'),
        Tag(id: '3', label: 'Stad', emoji: '🏙️'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: preferences.map((preference) => 
        OptionButton(
          option: preference,
          isSelected: selectedPreferences.contains(preference.id),
          isMultiSelect: true,
          onSelect: () {
            setState(() {
              if (selectedPreferences.contains(preference.id)) {
                selectedPreferences.remove(preference.id);
              } else {
                selectedPreferences.add(preference.id);
              }
            });
            debugPrint('Selected preferences: $selectedPreferences');
          },
        ),
      ).toList(),
    );
  }
}

/// TagView demonstration - verschillende categorieën zoals in de Swift app
class _TagViewDemo extends StatelessWidget {
  const _TagViewDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TagView Demonstratie', style: AppTextStyles.headline),
        const SizedBox(height: 16),
        
        // Ontmoetingsvoorkeuren
        _buildTagSection('Ontmoetingsvoorkeur', [
          Tag(id: '1', label: 'LinkedIn', emoji: '💼'),
          Tag(id: '2', label: 'Koffie', emoji: '☕'),
        ]),
        
        const SizedBox(height: 16),
        
        // Netwerkdoelen
        _buildTagSection('Netwerkdoelen', [
          Tag(id: '3', label: 'Netwerk uitbreiden', emoji: '🌐'),
          Tag(id: '4', label: 'Bedrijfsgroei', emoji: '📈'),
        ]),
        
        const SizedBox(height: 16),
        
        // Ondernemerservaring
        _buildTagSection('Ondernemerservaring', [
          Tag(id: '5', label: '11-20 jaar ervaring', emoji: '👨‍💼'),
        ]),
        
        const SizedBox(height: 16),
        
        // Talen
        _buildTagSection('Talen', [
          Tag(id: '6', label: 'Engels', emoji: '🇬🇧'),
          Tag(id: '7', label: 'Nederlands', emoji: '🇳🇱'),
        ]),
        
        const SizedBox(height: 16),
        
        // Land
        _buildTagSection('Land', [
          Tag(id: '8', label: 'België', emoji: '🇧🇪'),
        ]),
        
        const SizedBox(height: 16),
        
        // Mixed tags met icons en emoji's
        _buildTagSection('Mixed Icons & Emojis', [
          Tag(id: '9', label: 'Technologie', icon: 'bulb'),
          Tag(id: '10', label: 'Startup', emoji: '🚀'),
          Tag(id: '11', label: 'Marketing', icon: 'card'),
          Tag(id: '12', label: 'Financiën', emoji: '💰'),
          Tag(id: '13', label: 'Healthcare', icon: 'handshake'),
          Tag(id: '14', label: 'Sport', emoji: '⚽'),
          Tag(id: '15', label: 'Muziek', emoji: '🎵'),
        ]),
      ],
    );
  }
  
  Widget _buildTagSection(String title, List<Tag> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.footnote.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) => 
            TagView(
              id: tag.id,
              label: tag.label,
              icon: tag.icon,
              emoji: tag.emoji,
              fontSize: AppTextStyles.footnote,
              iconSize: 14,
            ),
          ).toList(),
        ),
      ],
    );
  }
}

/// OptionButton with TagViews demonstration - zoals in de Swift app screenshot
class _OptionButtonWithTagsDemo extends StatefulWidget {
  const _OptionButtonWithTagsDemo();

  @override
  State<_OptionButtonWithTagsDemo> createState() => _OptionButtonWithTagsDemoState();
}

class _OptionButtonWithTagsDemoState extends State<_OptionButtonWithTagsDemo> {
  String? selectedOption;

  final List<SimpleOption> profileOptions = [
    SimpleOption(
      id: 'networking_goals',
      title: 'Netwerkdoelen',
      description: 'Wat je hoopt te bereiken door te netwerken met andere ondernemers',
      icon: 'bulb',
      color: AppColors.primair4Lilac,
      list: [
        Tag(id: '1', label: 'Netwerk uitbreiden', emoji: '🌐'),
        Tag(id: '2', label: 'Bedrijfsgroei', emoji: '📈'),
      ],
    ),
    SimpleOption(
      id: 'entrepreneur_experience',
      title: 'Ondernemerservaring',
      description: 'Hoeveel jaar ervaring je hebt als ondernemer',
      icon: 'company',
      color: AppColors.primair4Lilac,
      list: [
        Tag(id: '3', label: '11-20 jaar ervaring', emoji: '👨‍💼'),
      ],
    ),
    SimpleOption(
      id: 'languages',
      title: 'Talen',
      description: 'Welke talen je spreekt voor zakelijke communicatie',
      icon: 'chat',
      color: AppColors.primair4Lilac,
      list: [
        Tag(id: '4', label: 'Engels', emoji: '🇬🇧'),
        Tag(id: '5', label: 'Nederlands', emoji: '🇳🇱'),
        Tag(id: '6', label: 'Frans', emoji: '🇫🇷'),
        Tag(id: '7', label: 'Spaans', emoji: '🇪🇸'),
      ],
    ),
    SimpleOption(
      id: 'country',
      title: 'Land',
      description: 'Het land waar je woont of gevestigd bent',
      icon: 'location',
      color: AppColors.primair4Lilac,
      list: [
        Tag(id: '8', label: 'België', emoji: '🇧🇪'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('OptionButton met TagViews', style: AppTextStyles.headline),
        const SizedBox(height: 16),
        
        ...profileOptions.map((option) => 
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: OptionButton(
              option: option,
              isSelected: selectedOption == option.id,
              isMultiSelect: false,
              withDescription: true,
              isChevronVisible: true,
              isCheckmarkVisible: false,
              onSelect: () {
                setState(() {
                  selectedOption = option.id;
                });
                debugPrint('Selected option: ${option.title}');
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// ProgressBar demonstration - 2 instanties met 10 stappen
class _ProgressBarDemo extends StatefulWidget {
  const _ProgressBarDemo();

  @override
  State<_ProgressBarDemo> createState() => _ProgressBarDemoState();
}

class _ProgressBarDemoState extends State<_ProgressBarDemo> {
  int currentStep1 = 1;
  int currentStep2 = 6;
  final int totalSteps = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ProgressBar Demonstratie', style: AppTextStyles.headline),
        const SizedBox(height: 16),
        
        // Eerste progress bar - stap 1
        Text('Stap $currentStep1 van $totalSteps', style: AppTextStyles.subheadline),
        const SizedBox(height: 8),
        ProgressBar(
          pageNumber: currentStep1,
          numberOfPages: totalSteps,
        ),
        const SizedBox(height: 16),
        
        // Controls voor eerste progress bar
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: currentStep1 > 1 ? () {
                setState(() {
                  currentStep1--;
                });
              } : null,
              child: const Text('Vorige'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: currentStep1 < totalSteps ? () {
                setState(() {
                  currentStep1++;
                });
              } : null,
              child: const Text('Volgende'),
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Tweede progress bar - stap 6
        Text('Stap $currentStep2 van $totalSteps', style: AppTextStyles.subheadline),
        const SizedBox(height: 8),
        ProgressBar(
          pageNumber: currentStep2,
          numberOfPages: totalSteps,
        ),
        const SizedBox(height: 16),
        
        // Controls voor tweede progress bar
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: currentStep2 > 1 ? () {
                setState(() {
                  currentStep2--;
                });
              } : null,
              child: const Text('Vorige'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: currentStep2 < totalSteps ? () {
                setState(() {
                  currentStep2++;
                });
              } : null,
              child: const Text('Volgende'),
            ),
          ],
        ),
      ],
    );
  }
}