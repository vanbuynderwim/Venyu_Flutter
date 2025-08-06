import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../models/enums/action_button_type.dart';
import '../../models/enums/registration_step.dart';
import '../../services/avatar_upload_service.dart';
import '../../services/session_manager.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/common/avatar_view.dart';
import '../base/base_form_view.dart';
import '../profile/edit_notifications_view.dart';

/// A form screen for adding/updating user avatar during registration.
/// 
/// This view allows users to upload a profile photo via camera or gallery
/// during the registration wizard or when editing their profile later.
/// Uses AvatarUploadService for consistent avatar handling across the app.
class EditAvatarView extends BaseFormView {
  const EditAvatarView({
    super.key,
    super.registrationWizard = false,
    super.currentStep,
  }) : super(title: 'Profile Photo');

  @override
  BaseFormViewState<BaseFormView> createState() => _EditAvatarViewState();
}

class _EditAvatarViewState extends BaseFormViewState<EditAvatarView> {
  bool _isUploading = false;
  String? _forceNoAvatar; // Force showing no avatar for specific ID
  
  @override
  bool get canSave => !_isUploading;

  @override
  String getSuccessMessage() => 'Profile photo saved';

  @override
  String getErrorMessage() => 'Failed to save profile photo';

  @override
  Future<void> performSave() async {
    // Skip to next step - avatar upload handled by buttons
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget buildFormContent(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Registration wizard progress bar
        if (widget.registrationWizard) ...[
          ProgressBar(
            pageNumber: 9,
            numberOfPages: 10,
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 16),

        // Avatar image in circle
        Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: _isUploading
                ? Container(
                    width: 120,
                    height: 120,
                    decoration: AppLayoutStyles.circleDecoration(context),
                    child: Center(
                      child: PlatformCircularProgressIndicator(),
                    ),
                  )
                : AvatarView(
                    avatarId: _forceNoAvatar == SessionManager.shared.currentProfile?.avatarID 
                        ? null 
                        : SessionManager.shared.currentProfile?.avatarID,
                    size: 120,
                    showBorder: true,
                  ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Delete button (only show if avatar exists and not forced to hide)
        if (SessionManager.shared.currentProfile?.avatarID != null && 
            SessionManager.shared.currentProfile!.avatarID!.isNotEmpty &&
            !_isUploading &&
            _forceNoAvatar != SessionManager.shared.currentProfile?.avatarID)
          Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleAvatarRemoval,
                splashFactory: NoSplash.splashFactory, // No ripple, only highlight
                highlightColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        
        const SizedBox(height: 12),
        
        // Title
        Center(
          child: Text(
            'Add a profile picture',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Subtitle with explanation
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Your avatar is often the first impression. Make it count by using a clear, welcoming headshot.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Camera and Gallery buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Camera button
              Expanded(
                child: ActionButton(
                  icon: Image.asset(
                    'assets/images/icons/camera_selected.png',
                    width: 24,
                    height: 24,
                  ),
                  label: 'Camera',
                  style: ActionButtonType.secondary,
                  onPressed: _isUploading ? null : _handleCameraUpload,
                  isLoading: false,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Gallery button
              Expanded(
                child: ActionButton(
                  icon: Image.asset(
                    'assets/images/icons/image_selected.png',
                    width: 24,
                    height: 24,
                  ),
                  label: 'Gallery',
                  style: ActionButtonType.secondary,
                  onPressed: _isUploading ? null : _handleGalleryUpload,
                  isLoading: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Navigate to the next step
  void _navigateToNext() {
    // Navigate to notifications view
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditNotificationsView(
          registrationWizard: true,
          currentStep: RegistrationStep.notifications,
        ),
      ),
    );
  }

  /// Handle camera upload
  Future<void> _handleCameraUpload() async {
    final success = await AvatarUploadService.pickFromCameraAndUpload(
      context: context,
      onUploadStart: () {
        setState(() {
          _isUploading = true;
        });
      },
      onUploadComplete: () {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
          // Refresh the UI to show the new avatar
          setState(() {});
        }
      },
    );
  }

  /// Handle gallery upload
  Future<void> _handleGalleryUpload() async {
    final success = await AvatarUploadService.pickFromGalleryAndUpload(
      context: context,
      onUploadStart: () {
        setState(() {
          _isUploading = true;
        });
      },
      onUploadComplete: () {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
          // Refresh the UI to show the new avatar
          setState(() {});
        }
      },
    );
  }
  
  /// Handle avatar removal
  Future<void> _handleAvatarRemoval() async {
    // Remember the current avatar ID before deletion
    final currentAvatarID = SessionManager.shared.currentProfile?.avatarID;
    
    final success = await AvatarUploadService.removeAvatar(
      context: context,
      onRemoveStart: () {
        setState(() {
          _isUploading = true;
          _forceNoAvatar = currentAvatarID; // Never show this avatar ID again
        });
      },
      onRemoveComplete: () {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
          // UI will automatically update due to _forceNoAvatar logic
        }
      },
    );
    
    // If removal failed, reset the force no avatar state
    if (!success && mounted) {
      setState(() {
        _forceNoAvatar = null; // Reset on failure so avatar can show again
      });
    }
  }

  @override
  Widget buildSaveButton({String? label, VoidCallback? onPressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ActionButton(
        label: 'Next',
        style: ActionButtonType.primary,
        onPressed: _isUploading ? null : _navigateToNext,
        isLoading: false,
      ),
    );
  }
}