import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../core/constants/app_assets.dart';
import '../../models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../common/tag_view.dart';

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

class _OptionButtonState extends State<OptionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _shadowAnimation = Tween<double>(
      begin: 0.0,
      end: 4.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(OptionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Alleen animeren als er een selectie mogelijk is (checkbox/radiobutton zichtbaar)
    if (widget.isCheckmarkVisible && widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: widget.disabled 
                  ? AppColors.secundair7Cascadingwhite
                  : AppColors.white,
              borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
              border: Border.all(
                color: AppColors.secundair6Rocket,
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secundair6Rocket.withValues(alpha: 0.1),
                  blurRadius: _shadowAnimation.value,
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
                              style: AppTextStyles.body.copyWith(
                                color: widget.disabled 
                                    ? AppColors.textLight 
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            
                            // Description
                            if (widget.withDescription && widget.option.description.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  widget.option.description,
                                  style: AppTextStyles.footnote.copyWith(
                                    color: AppColors.textSecondary,
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
                                      iconSize: 12,
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
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon() {
    final iconColor = widget.iconColor ?? widget.option.color;
    
    // Emoji has priority
    if (widget.option.emoji != null) {
      return Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Text(
          widget.option.emoji!,
          style: const TextStyle(fontSize: 20),
        ),
      );
    }
    
    // Icon fallback
    if (widget.option.icon != null) {
      return Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Icon(
          _getIconData(widget.option.icon!),
          color: widget.disabled ? AppColors.textLight : iconColor,
          size: 20,
        ),
      );
    }
    
    // Empty placeholder
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      child: Icon(
        Icons.circle,
        color: widget.disabled ? AppColors.textLight : iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildSelectionIndicator() {
    if (widget.isMultiSelect) {
      // Checkbox voor multiselect - gebruik assets
      return SizedBox(
        width: 24,
        height: 24,
        child: Image.asset(
          widget.isSelected 
              ? AppAssets.icons.checkboxOn.selected
              : AppAssets.icons.checkboxOff.regular,
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
              ? AppAssets.icons.radiobuttonOn.selected
              : AppAssets.icons.radiobuttonOff.regular,
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
    if (widget.isSelectable && widget.onSelect != null) {
      widget.onSelect!();
    }
  }

  IconData _getIconData(String iconName) {
    // Simple mapping van string naar IconData
    switch (iconName) {
      case 'person':
        return Icons.person;
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'location':
        return Icons.location_on;
      case 'work':
        return Icons.work;
      case 'coffee':
        return Icons.coffee;
      case 'restaurant':
        return Icons.restaurant;
      case 'fitness':
        return Icons.fitness_center;
      case 'bike':
        return Icons.directions_bike;
      case 'video':
        return Icons.videocam;
      case 'linkedin':
        return Icons.business;
      // ProfileEditType icons
      case 'profile':
        return Icons.person;
      case 'company':
        return Icons.business;
      case 'settings':
        return Icons.settings;
      case 'block_user':
        return Icons.block;
      case 'account':
        return Icons.account_circle;
      default:
        return Icons.circle;
    }
  }
}