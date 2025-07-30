import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/models.dart';
import '../common/option_icon_view.dart';
import '../common/tag_view.dart';

/// Interface defining the structure for selectable option data.
/// 
/// This abstract class provides the contract for option items that can be
/// displayed in [OptionButton] widgets. It includes all necessary properties
/// for rendering options with icons, descriptions, badges, and associated tags.
/// 
/// Example implementation:
/// ```dart
/// class CustomOption implements OptionType {
///   @override
///   final String id = 'custom_1';
///   
///   @override
///   final String title = 'Custom Option';
///   
///   // ... implement other required properties
/// }
/// ```
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

/// A simple, concrete implementation of [OptionType].
/// 
/// Provides a straightforward way to create option instances without
/// defining custom classes. Useful for static option lists and testing.
/// 
/// Example usage:
/// ```dart
/// final option = SimpleOption(
///   id: 'opt_1',
///   title: 'Option 1',
///   description: 'First option description',
///   color: Colors.blue,
///   icon: 'star',
///   badge: 3,
/// );
/// ```
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

/// A customizable option selection button with rich content support.
/// 
/// This widget displays selectable options with support for icons, text, descriptions,
/// badges, tag lists, toggles, and selection indicators. It provides a consistent
/// interface for option selection throughout the app.
/// 
/// The button supports multiple interaction modes:
/// - Single selection with radio button indicators
/// - Multi-selection with checkbox indicators
/// - Toggle switches for boolean options
/// - Navigation chevrons for drill-down options
/// 
/// Example usage:
/// ```dart
/// // Basic selectable option
/// OptionButton(
///   option: myOption,
///   isSelected: selectedItems.contains(myOption.id),
///   onSelect: () => toggleSelection(myOption.id),
/// )
/// 
/// // Multi-select with checkbox
/// OptionButton(
///   option: myOption,
///   isMultiSelect: true,
///   isSelected: selectedItems.contains(myOption.id),
///   onSelect: () => toggleMultiSelection(myOption.id),
/// )
/// 
/// // Toggle option
/// OptionButton(
///   option: myOption,
///   toggleIsOn: currentValue,
///   onToggle: (value) => updateSetting(value),
/// )
/// 
/// // Navigation option with chevron
/// OptionButton(
///   option: myOption,
///   isChevronVisible: true,
///   onSelect: () => navigateToDetail(myOption),
/// )
/// ```
/// 
/// See also:
/// * [OptionType] for option data structure
/// * [ActionButton] for simple action buttons
class OptionButton extends StatefulWidget {
  /// The option data to display in this button.
  final OptionType option;
  
  /// Whether this option is currently selected. Defaults to false.
  final bool isSelected;
  
  /// Whether this button supports multi-selection (checkbox) or single selection (radio).
  /// Defaults to false (single selection).
  final bool isMultiSelect;
  
  /// Whether this option can be selected. Defaults to true.
  /// When false, the option is display-only.
  final bool isSelectable;
  
  /// Whether to show selection indicators (checkbox/radio button). Defaults to true.
  final bool isCheckmarkVisible;
  
  /// Called when the option is selected/deselected.
  final VoidCallback? onSelect;
  
  /// The current state of the toggle switch (if this is a toggle option).
  final bool? toggleIsOn;
  
  /// Called when the toggle switch value changes.
  final ValueChanged<bool>? onToggle;
  
  /// Whether this option should appear disabled. Defaults to false.
  /// When disabled, the option is non-interactive and uses muted colors.
  final bool disabled;
  
  /// Whether to show a navigation chevron on the right. Defaults to false.
  final bool isChevronVisible;
  
  /// Whether this option acts as a button (no selection state). Defaults to false.
  final bool isButton;
  
  /// Optional override for the icon color. Uses option.color if not specified.
  final Color? iconColor;
  
  /// Whether to display the option's description text. Defaults to false.
  final bool withDescription;

  /// Creates an [OptionButton] widget.
  /// 
  /// The [option] parameter is required and contains the data to display.
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
  /// Tracks whether the button is currently being pressed for visual feedback
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: widget.disabled 
          ? AppLayoutStyles.disabledDecoration(context)
          : AppLayoutStyles.cardDecoration(context),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.disabled ? null : _handleTap,
                onTapDown: widget.disabled ? null : (_) => setState(() => isPressed = true),
                onTapUp: widget.disabled ? null : (_) => setState(() => isPressed = false),
                onTapCancel: widget.disabled ? null : () => setState(() => isPressed = false),
                splashFactory: NoSplash.splashFactory,
                borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
                child: Opacity(
                  opacity: context.getInteractiveOpacity(
                    isDisabled: widget.disabled, 
                    isPressed: isPressed,
                  ),
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
                            color: venyuTheme.primary,
                            borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
                          ),
                          child: Text(
                            widget.option.badge.toString(),
                            style: AppTextStyles.caption1.copyWith(
                              color: venyuTheme.cardBackground, // White in light mode
                            ),
                          ),
                        ),
                      
                      // Toggle switch
                      if (widget.onToggle != null)
                        PlatformSwitch(
                          value: widget.toggleIsOn ?? false,
                          onChanged: widget.disabled ? null : widget.onToggle,
                          material: (_, __) => MaterialSwitchData(
                            activeColor: venyuTheme.primary,
                          ),
                          cupertino: (_, __) => CupertinoSwitchData(
                            activeColor: venyuTheme.primary,
                          ),
                        ),
                      
                      // Selection indicator
                      if (widget.isCheckmarkVisible && widget.isSelectable)
                        _buildSelectionIndicator(),
                      
                      // Chevron
                      if (widget.isChevronVisible)
                        context.themedIcon('chevron', size: 16),
                    ],
                  ),
                  ),
                ),
              ),
            ),
          );
  }

  /// Builds the icon or emoji display for the option.
  /// 
  /// Uses [OptionIconView] to handle both local icons and emoji rendering
  /// with appropriate sizing and color theming.
  Widget _buildIcon() {
    final venyuTheme = context.venyuTheme;
    final iconColor = widget.disabled 
        ? venyuTheme.disabledText 
        : (widget.iconColor ?? venyuTheme.primary);
    
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

  /// Builds the selection indicator (checkbox or radio button).
  /// 
  /// Returns the appropriate selection UI based on [isMultiSelect]:
  /// - Checkbox for multi-selection
  /// - Radio button for single selection
  /// 
  /// Uses simplified themed assets with coloring.
  Widget _buildSelectionIndicator() {
    if (widget.isMultiSelect) {
      // Checkbox for multi-select
      return context.themedIcon('checkbox', selected: widget.isSelected);
    } else {
      // Radio button for single select
      return context.themedIcon('radiobutton', selected: widget.isSelected);
    }
  }

  /// Handles tap interactions on the option button.
  /// 
  /// Calls [onSelect] if the option is selectable or acts as a button.
  void _handleTap() {
    if ((widget.isSelectable || widget.isButton) && widget.onSelect != null) {
      widget.onSelect!();
    }
  }

}