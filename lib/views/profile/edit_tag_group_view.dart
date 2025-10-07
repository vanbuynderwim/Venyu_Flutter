import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../models/enums/action_button_type.dart';
import '../../models/tag.dart';
import '../../models/tag_group.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../services/profile_service.dart';
import '../../models/enums/registration_step.dart';
import '../../services/tag_group_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/buttons/option_button.dart';
import '../../widgets/common/progress_bar.dart';
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
  final ContentManager _contentManager = ContentManager.shared;
  final ProfileService _profileService = ProfileService.shared;
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
      final updatedTagGroup = await _contentManager.fetchTagGroup(widget.tagGroup);
      
      // Initialize selected tags based on current state
      final selectedTags = updatedTagGroup.tags?.where((tag) => tag.isSelected == true).toList() ?? [];
      
      setState(() {
        _currentTagGroup = updatedTagGroup;
        _selectedTags = List.from(selectedTags);
        _isLoading = false;
      });
    } catch (error) {
      AppLogger.error('Error fetching tag group: $error', context: 'EditTagGroupView');
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
                numberOfPages: 11, // 11 steps with progress bar (complete step has no progress bar)
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
              padding: const EdgeInsets.only(bottom: 8),
              child: ActionButton(
                label: _isSaving 
                    ? 'Saving...' 
                    : (widget.registrationWizard ? 'Next' : 'Save'),
                onPressed: _isSaving || _selectedTags.isEmpty ? null : _saveChanges,
                type: ActionButtonType.primary,
                isDisabled: _isSaving || _selectedTags.isEmpty,
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
          useBorderSelection: true,
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
        // Multi-select mode
        if (isCurrentlySelected) {
          // Allow deselecting if there are other selected tags, or during onboarding
          if (_selectedTags.length > 1 || widget.registrationWizard) {
            _selectedTags.removeWhere((selectedTag) => selectedTag.id == tag.id);
          }
          // If editing existing profile and only 1 tag selected, ignore tap
        } else {
          _selectedTags.add(tag);
        }
      } else {
        // Single-select mode
        if (!isCurrentlySelected) {
          _selectedTags.clear();
          _selectedTags.add(tag);
        } else if (widget.registrationWizard) {
          // During onboarding, allow deselecting in single-select mode
          _selectedTags.clear();
        }
        // If editing existing profile and already selected, ignore tap
      }
    });
  }

  Future<void> _saveChanges() async {
    if (_isSaving || _currentTagGroup == null) return;

    // Validation: always require at least 1 tag selected
    if (_selectedTags.isEmpty) {
      AppLogger.warning('Cannot save: no tags selected', context: 'EditTagGroupView');
      return; // Don't save if no tags selected
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Use the appropriate upsert method based on selection type
      if (_currentTagGroup!.isMultiSelect ?? false) {
        // Multi-select: upsert all selected tags
        await _contentManager.upsertProfileTags(_currentTagGroup!.code, _selectedTags);
      } else {
        // Single-select: upsert single tag
        await _contentManager.upsertProfileTag(_currentTagGroup!.code, _selectedTags.first);
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
      AppLogger.error('Error saving tag changes: $error', context: 'EditTagGroupView');
      
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

  /// Updates the local ProfileService profile with the new tag selections
  /// This ensures that ProfileView updates immediately without requiring a refresh
  void _updateLocalProfile() {
    final currentProfile = _profileService.currentProfile;
    if (currentProfile?.taggroups == null || _currentTagGroup == null) {
      AppLogger.warning('Cannot update local profile - missing data', context: 'EditTagGroupView');
      return;
    }

    AppLogger.debug('Updating local profile taggroups for category: ${_currentTagGroup!.code}', context: 'EditTagGroupView');

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

      // Update the ProfileService with the new taggroups
      _profileService.updateCurrentProfileFields(
        taggroups: updatedTagGroups,
      );

      AppLogger.success('Local profile updated for ${_currentTagGroup!.code}', context: 'EditTagGroupView');
    } else {
      AppLogger.warning('Could not find taggroup ${_currentTagGroup!.code} in profile', context: 'EditTagGroupView');
    }
  }

  void _navigateToNextStep() {
    AppLogger.debug('EditTagGroupView: Navigating from ${widget.currentStep} to next step', context: 'EditTagGroupView');
    
    final nextStep = widget.currentStep!.nextStep;
    AppLogger.debug('Next step: $nextStep', context: 'EditTagGroupView');
    
    // Check if next step is still a tag group step
    final tagGroupSteps = [
      RegistrationStep.sectors,
      RegistrationStep.meetingPreferences,
      RegistrationStep.networkingGoals,
    ];
    
    if (nextStep == null || !tagGroupSteps.contains(nextStep)) {
      // No more tag group steps, navigate to next registration step
      AppLogger.success('No more tag group steps, navigating to next registration step: $nextStep', context: 'EditTagGroupView');
      
      if (nextStep == RegistrationStep.avatar) {
        // Navigate to avatar step
        Navigator.of(context).push(
          platformPageRoute(
            context: context,
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

    AppLogger.debug('Navigating to ${nextTagGroup.label} with code ${nextTagGroup.code}', context: 'EditTagGroupView');
    
    // Use push instead of pushReplacement to keep navigation stack intact
    Navigator.of(context).push(
      platformPageRoute(
        context: context,
        builder: (context) => EditTagGroupView(
          tagGroup: nextTagGroup,
          registrationWizard: true,
          currentStep: nextStep,
        ),
      ),
    );
  }
}