import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../core/theme/app_theme.dart';
import '../models/tag_group.dart';
import '../models/tag.dart';
import '../widgets/buttons/option_button.dart';
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
    return AppListScaffold(
      appBar: PlatformAppBar(
        title: Text(_currentTagGroup?.label ?? widget.tagGroup.label),
        trailingActions: [
          if (!_isLoading && _currentTagGroup != null)
            PlatformTextButton(
              onPressed: _isSaving ? null : _saveChanges,
              child: _isSaving 
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: PlatformCircularProgressIndicator(),
                  )
                : const Text('Save'),
            ),
        ],
      ),
      children: _buildContent(),
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
      
      children.add(
        OptionButton(
          option: tag,
          isSelected: isSelected,
          isMultiSelect: _currentTagGroup!.isMultiSelect ?? false,
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
    setState(() {
      final isCurrentlySelected = _selectedTags.any((selectedTag) => selectedTag.id == tag.id);
      
      if (_currentTagGroup!.isMultiSelect ?? false) {
        // Multi-select mode: toggle selection
        if (isCurrentlySelected) {
          _selectedTags.removeWhere((selectedTag) => selectedTag.id == tag.id);
        } else {
          _selectedTags.add(tag);
        }
      } else {
        // Single-select mode: replace selection
        if (isCurrentlySelected) {
          _selectedTags.clear(); // Deselect if already selected
        } else {
          _selectedTags.clear();
          _selectedTags.add(tag);
        }
      }
    });
  }

  Future<void> _saveChanges() async {
    if (_isSaving || _currentTagGroup == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Use the appropriate upsert method based on selection type
      if (_currentTagGroup!.isMultiSelect ?? false) {
        // Multi-select: upsert all selected tags
        await _supabaseManager.upsertProfileTags(_currentTagGroup!.code, _selectedTags);
      } else {
        // Single-select: upsert single tag or clear if none selected
        if (_selectedTags.isNotEmpty) {
          await _supabaseManager.upsertProfileTag(_currentTagGroup!.code, _selectedTags.first);
        } else {
          // Clear selection by upserting empty list
          await _supabaseManager.upsertProfileTags(_currentTagGroup!.code, []);
        }
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