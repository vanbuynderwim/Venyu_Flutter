import 'package:flutter/material.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../models/enums/action_button_type.dart';
import '../../models/enums/registration_step.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/progress_bar.dart';
import '../base/base_form_view.dart';
import '../company/edit_company_name_view.dart';

/// A placeholder form screen for editing user location information.
/// 
/// This is a temporary implementation for the registration wizard.
/// Will be expanded later with actual location selection functionality.
class EditLocationView extends BaseFormView {
  const EditLocationView({
    super.key,
    super.registrationWizard = false,
    super.currentStep,
  }) : super(title: 'Location');

  @override
  BaseFormViewState<BaseFormView> createState() => _EditLocationViewState();
}

class _EditLocationViewState extends BaseFormViewState<EditLocationView> {
  @override
  bool get canSave => true;

  @override
  String getSuccessMessage() => 'Location saved';

  @override
  String getErrorMessage() => 'Failed to save location';

  @override
  Future<void> performSave() async {
    // Placeholder - no actual save logic yet
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
            pageNumber: 3,
            numberOfPages: 10,
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 16),

        // Location image in circle
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: AppLayoutStyles.circleDecoration(context),
            child: Center(
              child: Image.asset(
                'assets/images/visuals/location.png',
                width: 100,
                height: 100,
                color: venyuTheme.primary,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if image not found
                  return Icon(
                    Icons.location_on_outlined,
                    size: 60,
                    color: venyuTheme.secondaryText,
                  );
                },
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Title
        Center(
          child: Text(
            'Enable Location',
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
              'Enable location services to discover and match with entrepreneurs in your area. Build meaningful connections with professionals nearby.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildSaveButton({String? label, VoidCallback? onPressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Not now button (secondary)
          Expanded(
            child: ActionButton(
              label: 'Not now',
              style: ActionButtonType.secondary,
              onPressed: _navigateToNext,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Enable button (primary)
          Expanded(
            child: ActionButton(
              label: 'Enable',
              style: ActionButtonType.primary,
              onPressed: _enableLocationService,
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to the next step without enabling location
  void _navigateToNext() {
    // Navigate directly to company name view
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditCompanyNameView(
          registrationWizard: true,
          currentStep: RegistrationStep.company,
        ),
      ),
    );
  }

  /// Enable location service (to be implemented)
  void _enableLocationService() {
    // TODO: Implement location service enabling
    debugPrint('Enable location service - to be implemented');
    
    // For now, just navigate to next step after enabling
    _navigateToNext();
  }
}