import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_theme.dart';
import '../../models/enums/action_button_type.dart';
import '../../models/tag.dart';
import '../../models/tag_group.dart';
import '../../services/supabase_manager.dart';
import '../../services/session_manager.dart';
import '../../models/enums/registration_step.dart';
import '../../services/tag_group_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/buttons/option_button.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import 'edit_avatar_view.dart';

/// EditTagGroupView - Flutter equivalent of iOS EditTagGroupView
/// 
/// This view allows users to select/deselect tags within a specific TagGroup.
/// It supports both single-select and multi-select modes based on the TagGroup configuration.
class EditTagGroupView extends StatefulWidget {
  final TagGroup tagGroup;
  final bool registrationWizard;
  final RegistrationStep? currentStep;

  const EditTagGroupView({
    super.key,
    required this.tagGroup,
    this.registrationWizard = false,
    this.currentStep,
  });

  @override
  State<EditTagGroupView> createState() => _EditTagGroupViewState();
}

class _EditTagGroupViewState extends State<EditTagGroupView> {
  final SupabaseManager _supabaseManager = SupabaseManager.shared;
  final SessionManager _sessionManager = SessionManager.shared;
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

  /// Get the progress bar page number based on current step
  int get _progressPageNumber {
    if (widget.currentStep == null) return 1;
    return widget.currentStep!.stepNumber;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(_currentTagGroup?.label ?? widget.tagGroup.label),
      ),
      body: Column(
        children: [
          // Progress bar outside of scrollable content for consistent positioning
          if (widget.registrationWizard && widget.currentStep != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: ProgressBar(
                pageNumber: _progressPageNumber,
                numberOfPages: 10, // 10 steps with progress bar (complete step has no progress bar)
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              children: _buildContent(),
            ),
          ),
          if (!_isLoading && _currentTagGroup != null)
            Container(
              padding: const EdgeInsets.all(0),
              child: ActionButton(
                label: _isSaving 
                    ? 'Saving...' 
                    : (widget.registrationWizard ? 'Next' : 'Save'),
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
    final List<Widget> content = [];
    
    if (_isLoading) {
      content.add(
        SizedBox(
          height: 200,
          child: Center(
            child: PlatformCircularProgressIndicator(),
          ),
        ),
      );
      return content;
    }

    if (_error != null) {
      content.add(
        SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: context.venyuTheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load tags',
                  style: AppTextStyles.headline,
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: AppTextStyles.body.secondary(context),
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
      );
      return content;
    }

    if (_currentTagGroup?.tags == null || _currentTagGroup!.tags!.isEmpty) {
      content.add(
        const SizedBox(
          height: 200,
          child: Center(
            child: Text('No tags available'),
          ),
        ),
      );
      return content;
    }

    // Add description if available
    if (_currentTagGroup!.desc != null && _currentTagGroup!.desc!.isNotEmpty) {
      content.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            _currentTagGroup!.desc!,
            style: AppTextStyles.body.secondary(context),
          ),
        ),
      );
    }

    // Add tags as OptionButtons
    for (final tag in _currentTagGroup!.tags!) {
      final isSelected = _selectedTags.any((selectedTag) => selectedTag.id == tag.id);
      final isMultiSelect = _currentTagGroup!.isMultiSelect ?? false;
      
      content.add(
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

    return content;
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

      // Update local SessionManager profile to reflect the changes
      _updateLocalProfile();

      // Show success feedback and navigate
      if (mounted) {
        if (widget.registrationWizard && widget.currentStep != null) {
          // Navigate to next step in wizard
          _navigateToNextStep();
        } else {
          // Normal mode: navigate back
          Navigator.of(context).pop(true); // Return true to indicate changes were saved
        }
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

  /// Updates the local SessionManager profile with the new tag selections
  /// This ensures that ProfileView updates immediately without requiring a refresh
  void _updateLocalProfile() {
    final currentProfile = _sessionManager.currentProfile;
    if (currentProfile?.taggroups == null || _currentTagGroup == null) {
      debugPrint('⚠️ Cannot update local profile - missing data');
      return;
    }

    debugPrint('🔄 Updating local profile taggroups for category: ${_currentTagGroup!.code}');

    // Create a copy of the current taggroups
    List<TagGroup> updatedTagGroups = List.from(currentProfile!.taggroups!);
    
    // Find the index of the taggroup we're updating
    final groupIndex = updatedTagGroups.indexWhere(
      (group) => group.code == _currentTagGroup!.code,
    );

    if (groupIndex != -1) {
      // Update the existing taggroup with the new selected tags
      final updatedTagGroup = TagGroup(
        id: _currentTagGroup!.id,
        label: _currentTagGroup!.label,
        desc: _currentTagGroup!.desc,
        icon: _currentTagGroup!.icon,
        type: _currentTagGroup!.type,
        isMultiSelect: _currentTagGroup!.isMultiSelect,
        code: _currentTagGroup!.code,
        tags: _selectedTags.map((tag) => tag.copyWith(isSelected: true)).toList(),
      );

      updatedTagGroups[groupIndex] = updatedTagGroup;

      // Update the SessionManager with the new taggroups
      _sessionManager.updateCurrentProfileFields(
        taggroups: updatedTagGroups,
      );

      debugPrint('✅ Local profile updated for ${_currentTagGroup!.code}');
    } else {
      debugPrint('⚠️ Could not find taggroup ${_currentTagGroup!.code} in profile');
    }
  }

  void _navigateToNextStep() {
    debugPrint('🔄 EditTagGroupView: Navigating from ${widget.currentStep} to next step');
    
    final nextStep = widget.currentStep!.nextStep;
    debugPrint('🎯 Next step: $nextStep');
    
    // Check if next step is still a tag group step
    final tagGroupSteps = [
      RegistrationStep.sectors,
      RegistrationStep.meetingPreferences,
      RegistrationStep.networkingGoals,
    ];
    
    if (nextStep == null || !tagGroupSteps.contains(nextStep)) {
      // No more tag group steps, navigate to next registration step
      debugPrint('✅ No more tag group steps, navigating to next registration step: $nextStep');
      
      if (nextStep == RegistrationStep.avatar) {
        // Navigate to avatar step
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const EditAvatarView(
              registrationWizard: true,
              currentStep: RegistrationStep.avatar,
            ),
          ),
        );
      } else {
        // For any other case, pop back
        Navigator.of(context).pop(true);
      }
      return;
    }

    // Get dynamic tag group data for next step
    final tagGroupCodes = {
      RegistrationStep.sectors: 'sectors',
      RegistrationStep.meetingPreferences: 'meeting_preferences',
      RegistrationStep.networkingGoals: 'network_goals',
    };
    
    final code = tagGroupCodes[nextStep]!;
    final tagGroup = TagGroupService.shared.getTagGroupByCode(code);
    
    // Use cached data or fallback to hardcoded
    final nextTagGroup = tagGroup ?? TagGroup(
      id: '',
      code: code,
      label: code.replaceAll('_', ' ').split(' ').map((word) => 
          word[0].toUpperCase() + word.substring(1)).join(' '),
      desc: 'Select your ${code.replaceAll('_', ' ')}',
    );

    debugPrint('➡️ Navigating to ${nextTagGroup.label} with code ${nextTagGroup.code}');
    
    // Use push instead of pushReplacement to keep navigation stack intact
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTagGroupView(
          tagGroup: nextTagGroup,
          registrationWizard: true,
          currentStep: nextStep,
        ),
      ),
    );
  }
}