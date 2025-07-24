import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../core/theme/app_theme.dart';
import '../models/tag_group.dart';
import '../models/tag.dart';
import '../models/enums/action_button_type.dart';
import '../widgets/buttons/option_button.dart';
import '../widgets/buttons/action_button.dart';
import '../widgets/scaffolds/app_scaffold.dart';
import '../services/supabase_manager.dart';

/// EditTagGroupView - Flutter equivalent of iOS EditTagGroupView
/// 
/// This view allows users to select/deselect tags within a specific TagGroup.
/// It supports both single-select and multi-select modes based on the TagGroup configuration.
class EditTagGroupView extends StatefulWidget {
  final TagGroup tagGroup;

  const EditTagGroupView({
    super.key,
    required this.tagGroup,
  });

  @override
  State<EditTagGroupView> createState() => _EditTagGroupViewState();
}

class _EditTagGroupViewState extends State<EditTagGroupView> {
  final SupabaseManager _supabaseManager = SupabaseManager.shared;
  TagGroup? _currentTagGroup;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  
  // Track selected tags
  List<Tag> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _initializeView();
  }

  Future<void> _initializeView() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Fetch the complete TagGroup with all tags
      final updatedTagGroup = await _supabaseManager.fetchTagGroup(widget.tagGroup);
      
      // Initialize selected tags based on current state
      final selectedTags = updatedTagGroup.tags?.where((tag) => tag.isSelected == true).toList() ?? [];
      
      // Ensure at least 1 tag is selected - if none are selected, select the first one
      if (selectedTags.isEmpty && updatedTagGroup.tags != null && updatedTagGroup.tags!.isNotEmpty) {
        selectedTags.add(updatedTagGroup.tags!.first);
      }
      
      setState(() {
        _currentTagGroup = updatedTagGroup;
        _selectedTags = List.from(selectedTags);
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Error fetching tag group: $error');
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(_currentTagGroup?.label ?? widget.tagGroup.label),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 16),
              children: _buildContent(),
            ),
          ),
          if (!_isLoading && _currentTagGroup != null)
            Container(
              padding: const EdgeInsets.all(0),
              child: ActionButton(
                label: _isSaving ? 'Saving...' : 'Save',
                onPressed: _isSaving ? null : _saveChanges,
                style: ActionButtonType.primary,
                isDisabled: _isSaving,
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildContent() {
    if (_isLoading) {
      return [
        SizedBox(
          height: 200,
          child: Center(
            child: PlatformCircularProgressIndicator(),
          ),
        ),
      ];
    }

    if (_error != null) {
      return [
        SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load tags',
                  style: AppTextStyles.headline,
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                PlatformElevatedButton(
                  onPressed: _initializeView,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    if (_currentTagGroup?.tags == null || _currentTagGroup!.tags!.isEmpty) {
      return [
        const SizedBox(
          height: 200,
          child: Center(
            child: Text('No tags available'),
          ),
        ),
      ];
    }

    final List<Widget> children = [];

    // Add description if available
    if (_currentTagGroup!.description.isNotEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            _currentTagGroup!.description,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    // Add tags as OptionButtons
    for (final tag in _currentTagGroup!.tags!) {
      final isSelected = _selectedTags.any((selectedTag) => selectedTag.id == tag.id);
      final isMultiSelect = _currentTagGroup!.isMultiSelect ?? false;
      
      children.add(
        OptionButton(
          option: tag,
          isSelected: isSelected,
          isMultiSelect: isMultiSelect,
          isSelectable: true,
          isCheckmarkVisible: true,
          isChevronVisible: false,
          withDescription: false,
          onSelect: () {
            _handleTagTap(tag);
          },
        ),
      );
    }

    return children;
  }

  void _handleTagTap(Tag tag) {
    final isCurrentlySelected = _selectedTags.any((selectedTag) => selectedTag.id == tag.id);
    
    // Provide haptic feedback only when SELECTING (not deselecting)
    if (!isCurrentlySelected) {
      HapticFeedback.selectionClick();
    }
    
    setState(() {
      if (_currentTagGroup!.isMultiSelect ?? false) {
        // Multi-select mode: toggle selection, but keep at least 1 selected
        if (isCurrentlySelected) {
          // Only allow deselection if there are other selected tags
          if (_selectedTags.length > 1) {
            _selectedTags.removeWhere((selectedTag) => selectedTag.id == tag.id);
          }
          // If only 1 tag selected, ignore tap (can't deselect last tag)
        } else {
          _selectedTags.add(tag);
        }
      } else {
        // Single-select mode: can only switch to different tag, never deselect
        if (!isCurrentlySelected) {
          _selectedTags.clear();
          _selectedTags.add(tag);
        }
        // If already selected, ignore tap (can't deselect in single-select)
      }
    });
  }

  Future<void> _saveChanges() async {
    if (_isSaving || _currentTagGroup == null) return;

    // Validation: ensure at least 1 tag is selected
    if (_selectedTags.isEmpty) {
      debugPrint('⚠️ Cannot save: no tags selected');
      return; // Don't save if no tags selected
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Use the appropriate upsert method based on selection type
      if (_currentTagGroup!.isMultiSelect ?? false) {
        // Multi-select: upsert all selected tags (guaranteed non-empty)
        await _supabaseManager.upsertProfileTags(_currentTagGroup!.code, _selectedTags);
      } else {
        // Single-select: upsert single tag (guaranteed non-empty)
        await _supabaseManager.upsertProfileTag(_currentTagGroup!.code, _selectedTags.first);
      }

      // Show success feedback and navigate back
      if (mounted) {
        // You could show a success snackbar here if needed
        Navigator.of(context).pop(true); // Return true to indicate changes were saved
      }
    } catch (error) {
      debugPrint('Error saving tag changes: $error');
      
      if (mounted) {
        // Show error dialog or snackbar
        showPlatformDialog(
          context: context,
          builder: (context) => PlatformAlertDialog(
            title: const Text('Error'),
            content: Text('Failed to save changes: ${error.toString()}'),
            actions: [
              PlatformDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}