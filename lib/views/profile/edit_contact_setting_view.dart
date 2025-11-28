import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/contact.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/form_info_box.dart';
import '../base/base_form_view.dart';

/// A form screen for editing a contact setting value.
///
/// Takes a [Contact] model as parameter and allows the user to update its value.
class EditContactSettingView extends BaseFormView {
  final Contact contact;

  const EditContactSettingView({
    super.key,
    required this.contact,
  });

  @override
  BaseFormViewState<BaseFormView> createState() => _EditContactSettingViewState();
}

class _EditContactSettingViewState extends BaseFormViewState<EditContactSettingView> {
  @override
  String getFormTitle() => widget.contact.label;

  // Form controllers
  final _valueController = TextEditingController();

  // Form validation state
  bool _valueTouched = false;

  @override
  void initializeForm() {
    super.initializeForm();
    _preloadValues();

    // Add listeners for validation
    _valueController.addListener(_onValueChanged);
  }

  void _preloadValues() {
    _valueController.text = widget.contact.value ?? '';
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  bool get canSave => true; // Allow saving empty values (will delete the contact info)

  @override
  String getSuccessMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editContactSettingSavedMessage;
  }

  @override
  String getErrorMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editContactSettingErrorMessage;
  }

  @override
  Future<void> performSave() async {
    await profileManager.upsertProfileContactInformation(
      contactSettingId: widget.contact.id,
      value: _valueController.text.trim().isEmpty ? null : _valueController.text.trim(),
    );
  }

  void _onValueChanged() {
    setState(() {
      if (!_valueTouched) {
        _valueTouched = true;
      }
    });
  }

  @override
  bool get useScrollView => true;

  @override
  Widget buildFormContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Value field
        buildFieldSection(
          title: widget.contact.label,
          content: AppTextField(
            controller: _valueController,
            hintText: l10n.editContactSettingValueHint,
            textInputAction: TextInputAction.done,
            style: AppTextFieldStyle.large,
            state: AppTextFieldState.normal,
            enabled: !isUpdating,
          ),
        ),

        FormInfoBox(
          content: widget.contact.description(context),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
