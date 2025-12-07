import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../common/section_type.dart';
import '../../core/theme/app_layout_styles.dart';


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
///   badgeCount: 5, // Optional badge
/// )
/// ```
class SectionButton<T extends SectionType> extends StatefulWidget {
  /// The section data to display.
  final T section;

  /// Whether this button is currently selected.
  final bool isSelected;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Optional badge count to display on the button.
  final int? badgeCount;

  const SectionButton({
    super.key,
    required this.section,
    required this.isSelected,
    this.onPressed,
    this.badgeCount,
  });

  @override
  State<SectionButton<T>> createState() => _SectionButtonState<T>();
}

class _SectionButtonState<T extends SectionType> extends State<SectionButton<T>> {
  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    final isDisabled = widget.onPressed == null;
    
    // Use proper background and icon colors based on theme and state
    final backgroundColor = widget.isSelected 
        ? venyuTheme.primary.withValues(alpha: 0.15)
        : Colors.transparent;

    // Text color logic:
    // - Selected in light mode: primary color (lilac)
    // - Selected in dark mode: white
    // - Not selected: secondary text color in both modes
    final textColor = widget.isSelected 
        ? (Theme.of(context).brightness == Brightness.dark 
            ? venyuTheme.primaryText 
            : venyuTheme.primary)
        : venyuTheme.secondaryText;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : widget.onPressed,
        splashFactory: NoSplash.splashFactory,
        highlightColor: venyuTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.zero, // No border radius for section buttons
        child: Container(
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(
            minHeight: 60,
          ),
          color: backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with optional badge
              _buildIconWithBadge(context),
              const SizedBox(height: 4),

              // Title
              Text(
                widget.section.title(context),
                style: AppTextStyles.caption3.copyWith(
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return context.themedIcon(widget.section.icon, selected: widget.isSelected);
  }

  Widget _buildIconWithBadge(BuildContext context) {
    final icon = _buildIcon(context);

    if (widget.badgeCount != null && widget.badgeCount! > 0) {
      return Badge.count(
        count: widget.badgeCount!,
        child: icon,
      );
    }

    return icon;
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

  /// Optional badge counts for each section (by section ID).
  final Map<String, int>? badgeCounts;

  const SectionButtonBar({
    super.key,
    required this.sections,
    this.selectedSection,
    this.onSectionSelected,
    this.badgeCounts,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Container(
      decoration: AppLayoutStyles.cardDecoration(context),
      // Clip the content to match the border radius
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Buttons
          Row(
            children: sections.map((section) {
              final badgeCount = badgeCounts?[section.id];
              return Expanded(
                child: SectionButton<T>(
                  section: section,
                  isSelected: selectedSection?.id == section.id,
                  onPressed: () => onSectionSelected?.call(section),
                  badgeCount: badgeCount,
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
                            color: venyuTheme.primary,
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