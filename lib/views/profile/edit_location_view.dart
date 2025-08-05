import 'package:flutter/material.dart';

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

        // Registration wizard title
        if (widget.registrationWizard) ...[
          Text(
            'Where are you located?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Placeholder content
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Location selection',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'This feature will be implemented soon.\nFor now, click Next to continue.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
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
      child: ActionButton(
        label: 'Next',
        onPressed: () {
          // Navigate directly to company name view for now
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EditCompanyNameView(
                registrationWizard: true,
                currentStep: RegistrationStep.company,
              ),
            ),
          );
        },
      ),
    );
  }
}