import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../common/section_type.dart';

/// A button widget representing a section with icon and label.
/// 
/// This widget provides a tappable section button that integrates with
/// the VenyuTheme system. It supports both light and dark modes with
/// proper selected state visualization.
/// 
/// The button has two visual states:
/// - Default: Transparent background with theme-appropriate icon
/// - Selected: Primary color background (no individual borders)
/// 
/// Note: This button is designed to be used within a container that
/// provides the overall border and border radius for the button group.
/// 
/// Features:
/// - Theme-aware colors and styling
/// - Smooth transitions for selection state
/// - Proper dark mode support with theme-based icon suffixes
/// - No individual borders or border radius (handled by container)
/// 
/// Example usage:
/// ```dart
/// SectionButton<ProfileSections>(
///   section: ProfileSections.cards,
///   isSelected: true,
///   onPressed: () => print('Cards selected'),
/// )
/// ```
class SectionButton<T extends SectionType> extends StatelessWidget {
  /// The section data to display.
  final T section;
  
  /// Whether this button is currently selected.
  final bool isSelected;
  
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  const SectionButton({
    super.key,
    required this.section,
    required this.isSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    // Use proper background and icon colors based on theme and state
    final backgroundColor = isSelected 
        ? venyuTheme.selectionColor.withValues(alpha: 0.15)
        : Colors.transparent;

    // Text color logic:
    // - Selected in light mode: primary color (lilac)
    // - Selected in dark mode: white
    // - Not selected: secondary text color in both modes
    final textColor = isSelected 
        ? (Theme.of(context).brightness == Brightness.dark 
            ? Colors.white 
            : venyuTheme.primary)
        : venyuTheme.secondaryText;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        splashFactory: NoSplash.splashFactory,
        child: Container(
          padding: const EdgeInsets.all(10),
          constraints: const BoxConstraints(
            minHeight: 60,
          ),
          color: backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              _buildIcon(context, textColor),
              const SizedBox(height: 4),
              
              // Title
              Text(
                section.title,
                style: AppTextStyles.caption1.copyWith(
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, Color iconColor) {
    // Icon suffix logic:
    // - Light + selected: _selected
    // - Light + unselected: _regular
    // - Dark + selected: _white
    // - Dark + unselected: _regular
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String iconSuffix;
    if (isSelected) {
      iconSuffix = isDarkMode ? '_white' : '_selected';
    } else {
      iconSuffix = '_regular';
    }
    final iconPath = 'assets/images/icons/${section.icon}$iconSuffix.png';
    
    return Image.asset(
      iconPath,
      width: 24,
      height: 24,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to Material icon if asset not found
        return Icon(
          _getDefaultIcon(section.icon),
          size: 24,
          color: iconColor,
        );
      },
    );
  }

  IconData _getDefaultIcon(String iconName) {
    switch (iconName) {
      case 'cards':
      case 'card':
        return Icons.credit_card_outlined;
      case 'venues':
      case 'venue':
      case 'group':
        return Icons.group_outlined;
      case 'reviews':
      case 'verified':
        return Icons.verified_outlined;
      case 'home':
        return Icons.home_outlined;
      default:
        return Icons.folder_outlined;
    }
  }
}

/// A widget that displays a row of section buttons with an animated indicator.
/// 
/// This widget creates a horizontal bar of [SectionButton]s with a sliding
/// indicator that shows the currently selected section. It includes a themed
/// container with border and border radius, ensuring consistent styling
/// throughout the app.
/// 
/// Features:
/// - Built-in container with theme-aware styling
/// - Animated selection indicator
/// - Equal width distribution of buttons
/// - Proper clipping for selected button backgrounds
/// - Smooth transitions between selections
/// 
/// Example usage:
/// ```dart
/// SectionButtonBar<ProfileSections>(
///   sections: ProfileSections.values,
///   selectedSection: _currentSection,
///   onSectionSelected: (section) {
///     setState(() => _currentSection = section);
///   },
/// )
/// ```
class SectionButtonBar<T extends SectionType> extends StatelessWidget {
  /// List of sections to display as buttons.
  final List<T> sections;
  
  /// The currently selected section.
  final T? selectedSection;
  
  /// Callback when a section is selected.
  final ValueChanged<T>? onSectionSelected;

  const SectionButtonBar({
    super.key,
    required this.sections,
    this.selectedSection,
    this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Container(
      decoration: BoxDecoration(
        color: venyuTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: venyuTheme.borderColor,
          width: 0.5,
        ),
      ),
      // Clip the content to match the border radius
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Buttons
          Row(
            children: sections.map((section) {
              return Expanded(
                child: SectionButton<T>(
                  section: section,
                  isSelected: selectedSection?.id == section.id,
                  onPressed: () => onSectionSelected?.call(section),
                ),
              );
            }).toList(),
          ),
          
          // Bottom indicator line
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final sectionWidth = constraints.maxWidth / sections.length;
                final selectedIndex = selectedSection != null 
                    ? sections.indexWhere((s) => s.id == selectedSection!.id)
                    : -1;
                    
                return Stack(
                  children: [
                    // Background line (subtle)
                    Container(
                      height: 3,
                      color: venyuTheme.borderColor.withValues(alpha: 0.1),
                    ),
                    
                    // Active indicator
                    if (selectedIndex >= 0)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        left: selectedIndex * sectionWidth,
                        width: sectionWidth,
                        height: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: venyuTheme.selectionColor,
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}