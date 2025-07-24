import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../core/theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/index.dart';

/// ShowcaseView - Platform-aware showcase view with proper navigation back to Profile
class ShowcaseView extends StatelessWidget {
  const ShowcaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Venyu UI Showcase'),
        material: (_, __) => MaterialAppBarData(
          centerTitle: false,
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          // Large title automatically handled by flutter_platform_widgets
          // Back button will automatically show "Profile" as previous page title
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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
            
            // ActionButton demonstration
            const _ActionButtonDemo(),
            const SizedBox(height: 32),
            
            // SectionButton demonstration
            const _SectionButtonDemo(),
            const SizedBox(height: 32),
            
            // CardItem demonstration
            const _CardItemDemo(),
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
            borderRadius: BorderRadius.circular(AppModifiers.smallRadius),
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
  int currentStep = 1;
  final int totalSteps = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ProgressBar Demonstratie', style: AppTextStyles.headline),
        const SizedBox(height: 16),
        
        // Progress bar
        Text('Stap $currentStep van $totalSteps', style: AppTextStyles.subheadline),
        const SizedBox(height: 8),
        ProgressBar(
          pageNumber: currentStep,
          numberOfPages: totalSteps,
        ),
        const SizedBox(height: 16),
        
        // ActionButton controls
        Row(
          children: [
            Expanded(
              child: ActionButton(
                label: 'Vorige',
                style: ActionButtonType.secondary,
                icon: Icons.arrow_back,
                isDisabled: currentStep <= 1,
                onPressed: currentStep > 1 ? () {
                  setState(() {
                    currentStep--;
                  });
                } : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ActionButton(
                label: 'Volgende',
                style: ActionButtonType.primary,
                icon: Icons.arrow_forward,
                isDisabled: currentStep >= totalSteps,
                onPressed: currentStep < totalSteps ? () {
                  setState(() {
                    currentStep++;
                  });
                } : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// ActionButton demonstration - verschillende stijlen en variaties
class _ActionButtonDemo extends StatelessWidget {
  const _ActionButtonDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ActionButton Demonstratie', style: AppTextStyles.headline),
        const SizedBox(height: 16),
        
        // Primary buttons
        Text('Primary Style:', style: AppTextStyles.subheadline),
        const SizedBox(height: 8),
        
        ActionButton(
          label: 'Enable',
          icon: Icons.location_on,
          onPressed: () {
            debugPrint('Primary button with icon pressed');
          },
        ),
        const SizedBox(height: 8),
        
        ActionButton(
          label: 'Continue',
          onPressed: () {
            debugPrint('Primary button pressed');
          },
        ),
        const SizedBox(height: 16),
        
        // Secondary buttons
        Text('Secondary Style:', style: AppTextStyles.subheadline),
        const SizedBox(height: 8),
        
        ActionButton(
          label: 'Maybe later',
          style: ActionButtonType.secondary,
          onPressed: () {
            debugPrint('Secondary button pressed');
          },
        ),
        const SizedBox(height: 8),
        
        ActionButton(
          label: 'Cancel',
          style: ActionButtonType.secondary,
          icon: Icons.close,
          onPressed: () {
            debugPrint('Secondary button with icon pressed');
          },
        ),
        const SizedBox(height: 16),
        
        // Destructive buttons
        Text('Destructive Style:', style: AppTextStyles.subheadline),
        const SizedBox(height: 8),
        
        ActionButton(
          label: 'Delete Account',
          style: ActionButtonType.destructive,
          onPressed: () {
            debugPrint('Destructive button pressed');
          },
        ),
        const SizedBox(height: 8),
        
        ActionButton(
          label: 'Remove Photo',
          style: ActionButtonType.destructive,
          icon: Icons.delete,
          onPressed: () {
            debugPrint('Destructive button with icon pressed');
          },
        ),
        const SizedBox(height: 16),
        
        // Disabled states
        Text('Disabled States:', style: AppTextStyles.subheadline),
        const SizedBox(height: 8),
        
        const ActionButton(
          label: 'Disabled Primary',
          isDisabled: true,
        ),
        const SizedBox(height: 8),
        
        const ActionButton(
          label: 'Disabled Secondary',
          style: ActionButtonType.secondary,
          isDisabled: true,
        ),
        const SizedBox(height: 16),
        
        // LinkedIn button
        Text('LinkedIn Style:', style: AppTextStyles.subheadline),
        const SizedBox(height: 8),
        
        ActionButton(
          label: 'Connect on LinkedIn',
          style: ActionButtonType.linkedIn,
          icon: Icons.business,
          onPressed: () {
            debugPrint('LinkedIn button pressed');
          },
        ),
        
        const SizedBox(height: 16),
        
        // Two buttons side by side (zoals in screenshot)
        Text('Side by Side (zoals in je screenshot):', style: AppTextStyles.subheadline),
        const SizedBox(height: 8),
        
        Row(
          children: [
            Expanded(
              child: ActionButton(
                label: 'Maybe later',
                style: ActionButtonType.secondary,
                onPressed: () {
                  debugPrint('Maybe later pressed');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ActionButton(
                label: 'Enable',
                style: ActionButtonType.primary,
                icon: Icons.location_on,
                onPressed: () {
                  debugPrint('Enable pressed');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Icon-only buttons (zoals in nieuwe screenshot)
        Text('Icon-only Buttons (secondary):', style: AppTextStyles.subheadline),
        const SizedBox(height: 8),
        
        Row(
          children: [
            Expanded(
              child: ActionButton(
                icon: Icons.business, // LinkedIn icon
                style: ActionButtonType.secondary,
                isIconOnly: true,
                onPressed: () {
                  debugPrint('LinkedIn pressed');
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ActionButton(
                icon: Icons.email,
                style: ActionButtonType.secondary,
                isIconOnly: true,
                onPressed: () {
                  debugPrint('Email pressed');
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ActionButton(
                icon: Icons.link,
                style: ActionButtonType.secondary,
                isIconOnly: true,
                onPressed: () {
                  debugPrint('Link pressed');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// SectionButton demonstration
class _SectionButtonDemo extends StatefulWidget {
  const _SectionButtonDemo();

  @override
  State<_SectionButtonDemo> createState() => _SectionButtonDemoState();
}

class _SectionButtonDemoState extends State<_SectionButtonDemo> {
  ProfileSections selectedSection = ProfileSections.cards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SectionButton Demonstratie', style: AppTextStyles.headline),
        const SizedBox(height: 16),
        
        // SectionButtonBar zoals in screenshot
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
            border: Border.all(
              color: AppColors.secundair6Rocket,
              width: 0.5,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: SectionButtonBar<ProfileSections>(
            sections: ProfileSections.values,
            selectedSection: selectedSection,
            onSectionSelected: (section) {
              setState(() {
                selectedSection = section;
              });
              debugPrint('Selected section: ${section.title}');
            },
          ),
        ),
            
        const SizedBox(height: 24),
        
        // Info over geselecteerde sectie
        Container(
          decoration: BoxDecoration(
            color: AppColors.primair7Pearl,
            borderRadius: BorderRadius.circular(AppModifiers.smallRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Geselecteerde sectie:',
                style: AppTextStyles.footnote.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                selectedSection.title,
                style: AppTextStyles.headline,
              ),
              const SizedBox(height: 4),
              Text(
                selectedSection.description,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// CardItem demonstration - verschillende scenario's
class _CardItemDemo extends StatelessWidget {
  const _CardItemDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CardItem Demonstratie', style: AppTextStyles.headline),
        const SizedBox(height: 16),
        
        // Standalone card (zoals in BC50F31C screenshot)
        Text('Standalone Card met Status:', style: AppTextStyles.subheadline),
        const SizedBox(height: 8),
        
        CardItem(
          prompt: Prompt(
            promptID: '1',
            label: 'Ik zoek een ervaren marketeer die kan helpen met het uitbreiden van ons klantenbestand in de B2B sector.',
            interactionType: InteractionType.lookingForThis,
            status: PromptStatus.approved,
            profile: Profile(
              id: 'profile1',
              firstName: 'Sarah',
              lastName: 'Johnson',
              companyName: 'TechStart BV',
              isSuperAdmin: false,
            ),
            createdAt: DateTime.now(),
          ),
          onCardSelected: (prompt) {
            debugPrint('Standalone card selected: ${prompt.label}');
          },
        ),
        
        const SizedBox(height: 16),
        
        // Match detail card (zoals in AA297FCA screenshot)
        Text('Match Detail Card met Gradient:', style: AppTextStyles.subheadline),
        const SizedBox(height: 8),
        
        CardItem(
          prompt: Prompt(
            promptID: '2',
            label: 'Ik kan helpen met het opzetten van effectieve marketing campagnes voor startups en scale-ups.',
            interactionType: InteractionType.thisIsMe,
            matchInteractionType: InteractionType.lookingForThis,
            profile: Profile(
              id: 'profile2',
              firstName: 'Michael',
              lastName: 'Chen',
              companyName: 'Digital Growth Agency',
              isSuperAdmin: false,
            ),
            createdAt: DateTime.now(),
          ),
          showMatchInteraction: true,
          onCardSelected: (prompt) {
            debugPrint('Match card selected: ${prompt.label}');
          },
        ),
        
        const SizedBox(height: 16),
        
        // Reviewing mode cards
        Text('Reviewing Mode:', style: AppTextStyles.subheadline),
        const SizedBox(height: 8),
        
        CardItem(
          prompt: Prompt(
            promptID: '3',
            label: 'Zoek iemand die ervaring heeft met internationale expansie van tech bedrijven.',
            interactionType: InteractionType.knowSomeone,
            status: PromptStatus.pendingReview,
            profile: Profile(
              id: 'profile3',
              firstName: 'Emma',
              lastName: 'van der Berg',
              companyName: 'Global Ventures',
              isSuperAdmin: false,
            ),
            createdAt: DateTime.now(),
          ),
          reviewing: true,
          onCardSelected: (prompt) {
            debugPrint('Review card selected: ${prompt.label}');
          },
        ),
        
        const SizedBox(height: 8),
        
        // Different status examples
        Text('Verschillende Status Types:', style: AppTextStyles.subheadline),
        const SizedBox(height: 8),
        
        ...PromptStatus.values.map((status) => 
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CardItem(
              prompt: Prompt(
                promptID: 'status_${status.value}',
                label: 'Voorbeeldprompt voor ${status.value} status.',
                interactionType: InteractionType.values[PromptStatus.values.indexOf(status) % InteractionType.values.length],
                status: status,
                profile: Profile(
                  id: 'profile_${status.value}',
                  firstName: 'Test',
                  lastName: 'User',
                  companyName: 'Example Corp',
                  isSuperAdmin: false,
                ),
                createdAt: DateTime.now(),
              ),
              onCardSelected: (prompt) {
                debugPrint('Status card selected: ${prompt.label}');
              },
            ),
          ),
        ),
      ],
    );
  }
}