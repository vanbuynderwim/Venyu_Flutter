import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../core/constants/app_assets.dart';
import '../../models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../common/tag_view.dart';
import '../common/option_icon_view.dart';

/// OptionType protocol equivalent - interface for option data
abstract class OptionType {
  String get id;
  String get title;
  String get description;
  Color get color;
  String? get icon;
  String? get emoji;
  int get badge;
  List<Tag>? get list;
}

/// Simple implementation of OptionType
class SimpleOption implements OptionType {
  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final Color color;
  @override
  final String? icon;
  @override
  final String? emoji;
  @override
  final int badge;
  @override
  final List<Tag>? list;

  const SimpleOption({
    required this.id,
    required this.title,
    this.description = '',
    this.color = Colors.blue,
    this.icon,
    this.emoji,
    this.badge = 0,
    this.list,
  });
}

/// Flutter equivalent van Swift OptionButton
class OptionButton extends StatefulWidget {
  final OptionType option;
  final bool isSelected;
  final bool isMultiSelect;
  final bool isSelectable;
  final bool isCheckmarkVisible;
  final VoidCallback? onSelect;
  final bool? toggleIsOn;
  final ValueChanged<bool>? onToggle;
  final bool disabled;
  final bool isChevronVisible;
  final bool isButton;
  final Color? iconColor;
  final bool withDescription;

  const OptionButton({
    super.key,
    required this.option,
    this.isSelected = false,
    this.isMultiSelect = false,
    this.isSelectable = true,
    this.isCheckmarkVisible = true,
    this.onSelect,
    this.toggleIsOn,
    this.onToggle,
    this.disabled = false,
    this.isChevronVisible = false,
    this.isButton = false,
    this.iconColor,
    this.withDescription = false,
  });

  @override
  State<OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton> {

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: widget.disabled 
            ? venyuTheme.disabledBackground
            : venyuTheme.cardBackground, // Pure white for cards
        borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
        border: Border.all(
          color: venyuTheme.borderColor,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: venyuTheme.borderColor.withValues(alpha: 0.1),
            blurRadius: 2.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.disabled ? null : _handleTap,
                splashFactory: NoSplash.splashFactory,
                borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Icon/Emoji
                      _buildIcon(),
                      const SizedBox(width: 12),                      
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              widget.option.title,
                              style: AppTextStyles.headline.copyWith(
                                color: widget.disabled 
                                    ? venyuTheme.disabledText 
                                    : venyuTheme.primaryText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            
                            // Description
                            if (widget.withDescription && widget.option.description.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  widget.option.description,
                                  style: AppTextStyles.subheadline.copyWith(
                                    color: venyuTheme.secondaryText,
                                  ),
                                ),
                              ),
                            
                            // Tag list
                            if (widget.option.list != null && widget.option.list!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: widget.option.list!.map((tag) => 
                                    TagView(
                                      id: tag.id,
                                      label: tag.label,
                                      icon: tag.icon,
                                      emoji: tag.emoji,
                                      fontSize: AppTextStyles.caption1,
                                      backgroundColor: venyuTheme.tagBackground, // Light gray for tags in buttons
                                    ),
                                  ).toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Badge
                      if (widget.option.badge > 0)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
                          ),
                          child: Text(
                            widget.option.badge.toString(),
                            style: AppTextStyles.caption1.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      
                      // Toggle switch
                      if (widget.onToggle != null)
                        PlatformSwitch(
                          value: widget.toggleIsOn ?? false,
                          onChanged: widget.disabled ? null : widget.onToggle,
                          material: (_, __) => MaterialSwitchData(
                            activeColor: AppColors.primary,
                          ),
                          cupertino: (_, __) => CupertinoSwitchData(
                            activeColor: AppColors.primary,
                          ),
                        ),
                      
                      // Selection indicator
                      if (widget.isCheckmarkVisible && widget.isSelectable)
                        _buildSelectionIndicator(),
                      
                      // Chevron
                      if (widget.isChevronVisible)
                        Image.asset(
                          Theme.of(context).brightness == Brightness.dark 
                              ? AppAssets.icons.chevron.white 
                              : AppAssets.icons.chevron.outlined,
                          width: 20,
                          height: 20
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildIcon() {
    final venyuTheme = context.venyuTheme;
    final iconColor = widget.disabled 
        ? venyuTheme.disabledText 
        : (widget.iconColor ?? widget.option.color);
    
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      child: OptionIconView(
        icon: widget.option.icon,
        emoji: widget.option.emoji,
        size: 24,
        color: iconColor,
        placeholder: 'hashtag',
        opacity: 1.0,
        isLocal: true, // OptionButton gebruikt altijd local icons
      ),
    );
  }

  Widget _buildSelectionIndicator() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (widget.isMultiSelect) {
      // Checkbox voor multiselect - gebruik assets
      return SizedBox(
        width: 24,
        height: 24,
        child: Image.asset(
          widget.isSelected 
              ? (isDark ? AppAssets.icons.checkboxOn.white : AppAssets.icons.checkboxOn.selected)
              : (isDark ? AppAssets.icons.checkboxOff.white : AppAssets.icons.checkboxOff.regular),
          width: 24,
          height: 24,
          errorBuilder: (context, error, stackTrace) {
            // Fallback naar default checkbox als asset niet gevonden
            return Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(AppModifiers.miniRadius),
                border: Border.all(
                  color: widget.isSelected ? AppColors.primary : AppColors.secundair6Rocket,
                  width: 2,
                ),
                color: widget.isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: widget.isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            );
          },
        ),
      );
    } else {
      // Radio button voor single select - gebruik assets
      return SizedBox(
        width: 24,
        height: 24,
        child: Image.asset(
          widget.isSelected 
              ? (isDark ? AppAssets.icons.radiobuttonOn.white : AppAssets.icons.radiobuttonOn.selected)
              : (isDark ? AppAssets.icons.radiobuttonOff.white : AppAssets.icons.radiobuttonOff.regular),
          width: 24,
          height: 24,
          errorBuilder: (context, error, stackTrace) {
            // Fallback naar default radio button als asset niet gevonden
            return Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isSelected ? AppColors.primary : AppColors.secundair6Rocket,
                  width: 2,
                ),
              ),
              child: widget.isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            );
          },
        ),
      );
    }
  }

  void _handleTap() {
    if ((widget.isSelectable || widget.isButton) && widget.onSelect != null) {
      widget.onSelect!();
    }
  }

}