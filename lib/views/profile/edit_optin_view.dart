import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../l10n/app_localizations.dart';
import '../../models/enums/action_button_type.dart';
import '../../services/profile_service.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/common/visual_icon_widget.dart';
import '../base/base_form_view.dart';
import '../onboarding/tutorial_done_view.dart';
import '../onboarding/tutorial_finished_view.dart';

/// A form screen for email opt-in during registration.
///
/// This view asks users if they want to receive tips and updates.
/// - "Yes" subscribes them to the newsletter via emailOptin
/// - "No" skips the subscription
/// Both options navigate to the next step.
class EditOptinView extends BaseFormView {
  /// Whether this is a returning user seeing the opt-in after tutorial
  final bool isReturningUser;

  /// Callback to close the modal when opt-in is complete (for returning users)
  final VoidCallback? onCloseModal;

  const EditOptinView({
    super.key,
    super.registrationWizard = false,
    super.currentStep,
    this.isReturningUser = false,
    this.onCloseModal,
  });

  @override
  BaseFormViewState<BaseFormView> createState() => _EditOptinViewState();
}

class _EditOptinViewState extends BaseFormViewState<EditOptinView> {
  @override
  String getFormTitle() => AppLocalizations.of(context)!.registrationStepOptinTitle;

  bool _isProcessingOptin = false;

  @override
  bool get canSave => true;

  @override
  Future<void> performSave() async {
    // Not used - we have custom button handlers
  }

  @override
  Widget buildFormContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Registration wizard progress bar
        if (widget.registrationWizard) ...[
          ProgressBar(
            pageNumber: 10,
            numberOfPages: 10,
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 16),

        // Email visual icon
        VisualIconWidget(
          iconName: 'email',
        ),

        const SizedBox(height: 24),

        // Title
        Center(
          child: Text(
            l10n.registrationStepOptinTitle,
            style: AppTextStyles.title2,
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 16),

        // Body text
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.registrationStepOptinBody,
              style: AppTextStyles.body.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildSaveButton({String? label, VoidCallback? onPressed}) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Yes button (primary)
          ActionButton(
            label: l10n.registrationStepOptinButtonYes,
            type: ActionButtonType.primary,
            onPressed: _handleYes,
            isLoading: _isProcessingOptin,
          ),
          const SizedBox(height: 12),
          // No button (secondary)
          ActionButton(
            label: l10n.registrationStepOptinButtonNo,
            type: ActionButtonType.secondary,
            onPressed: _isProcessingOptin ? null : _handleNo,
          ),
        ],
      ),
    );
  }

  /// Handle "Yes" button - subscribe to newsletter and navigate
  Future<void> _handleYes() async {
    if (_isProcessingOptin) return;

    setState(() {
      _isProcessingOptin = true;
    });

    try {
      // Get the user's contact email
      final email = ProfileService.shared.currentProfile?.contactEmail;

      if (email != null && email.isNotEmpty) {
        await ProfileManager.shared.emailOptin(email);
        AppLogger.success('User opted in to newsletter', context: 'EditOptinView');
      } else {
        AppLogger.warning('No email found for opt-in', context: 'EditOptinView');
      }

      if (mounted) {
        _navigateToNext();
      }
    } catch (error) {
      AppLogger.error('Error opting in to newsletter', error: error, context: 'EditOptinView');
      // Still navigate even if opt-in fails
      if (mounted) {
        _navigateToNext();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingOptin = false;
        });
      }
    }
  }

  /// Handle "No" button - skip subscription and navigate
  void _handleNo() {
    AppLogger.info('User declined newsletter opt-in', context: 'EditOptinView');
    _navigateToNext();
  }

  /// Navigate to the next step
  void _navigateToNext() {
    if (widget.registrationWizard) {
      // During registration, go to completion (optin is now the last step before complete)
      Navigator.of(context).push(
        platformPageRoute(
          context: context,
          builder: (context) => const TutorialFinishedView(),
        ),
      );
    } else {
      // For returning users, go to done view (optin is the last step after referrer)
      Navigator.of(context).push(
        platformPageRoute(
          context: context,
          builder: (context) => TutorialDoneView(
            isReturningUser: widget.isReturningUser,
            onCloseModal: widget.onCloseModal,
          ),
        ),
      );
    }
  }
}
