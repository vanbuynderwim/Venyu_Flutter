import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'section_type.dart';

/// SectionButton - Flutter equivalent van Swift SectionButton
class SectionButton<T extends SectionType> extends StatelessWidget {
  final T section;
  final bool isSelected;
  final VoidCallback? onPressed;

  const SectionButton({
    super.key,
    required this.section,
    required this.isSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primair6Periwinkel : Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              _buildIcon(),
              const SizedBox(height: 4),
              
              // Title
              Text(
                section.title,
                style: AppTextStyles.caption1.copyWith(
                  color: isSelected 
                      ? AppColors.primair4Lilac 
                      : AppColors.secundair3Slategray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    // Probeer eerst de asset te laden
    try {
      final iconPath = isSelected 
          ? 'assets/images/icons/${section.icon}_selected.png'
          : 'assets/images/icons/${section.icon}_regular.png';
          
      return Image.asset(
        iconPath,
        width: 24,
        height: 24,
        errorBuilder: (context, error, stackTrace) {
          // Fallback naar een default icon
          return Icon(
            _getDefaultIcon(section.icon),
            size: 24,
            color: isSelected 
                ? AppColors.primair4Lilac 
                : AppColors.secundair3Slategray,
          );
        },
      );
    } catch (e) {
      // Fallback naar icon
      return Icon(
        _getDefaultIcon(section.icon),
        size: 24,
        color: isSelected 
            ? AppColors.primair4Lilac 
            : AppColors.secundair3Slategray,
      );
    }
  }

  IconData _getDefaultIcon(String iconName) {
    switch (iconName) {
      case 'cards':
      case 'card':
        return Icons.credit_card;
      case 'venues':
      case 'venue':
      case 'group':
        return Icons.group;
      case 'reviews':
      case 'verified':
        return Icons.verified;
      case 'home':
        return Icons.home;
      default:
        return Icons.folder;
    }
  }
}

/// Widget voor een rij van SectionButtons met onderliggende indicator
class SectionButtonBar<T extends SectionType> extends StatelessWidget {
  final List<T> sections;
  final T? selectedSection;
  final ValueChanged<T>? onSectionSelected;

  const SectionButtonBar({
    super.key,
    required this.sections,
    this.selectedSection,
    this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  // Background line (invisible)
                  Container(
                    height: 3,
                    color: Colors.transparent,
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
                        color: AppColors.primair4Lilac,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}