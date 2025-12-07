import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../models/match.dart';
import '../../models/stage.dart';
import '../../services/profile_service.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/form_info_box.dart';
import '../../widgets/common/sub_title.dart';
import '../base/base_form_view.dart';
import 'match_reach_out_contacts_view.dart';

/// A form screen for reaching out to a match.
///
/// This widget provides:
/// - Info box explaining the purpose
/// - Text area for the message (no character limit)
/// - List of contact settings that can be shared
///
/// Contact settings with values can be multi-selected.
/// Contact settings without values navigate to edit screen.
class MatchReachOutView extends BaseFormView {
  final Match match;

  const MatchReachOutView({
    super.key,
    required this.match,
  });

  @override
  BaseFormViewState<BaseFormView> createState() => _MatchReachOutViewState();
}

class _MatchReachOutViewState extends BaseFormViewState<MatchReachOutView> {
  final TextEditingController _messageController = TextEditingController();

  // Store initial text to detect changes
  String _initialText = '';

  @override
  String getFormTitle() => AppLocalizations.of(context)!.matchReachOutTitle;

  bool _isInitialized = false;

  @override
  void initializeForm() {
    super.initializeForm();
    _messageController.addListener(_onMessageChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      _initializeMessage();
    }
  }

  void _initializeMessage() {
    final l10n = AppLocalizations.of(context)!;
    final currentProfile = ProfileService.shared.currentProfile;
    final senderName = currentProfile?.fullName ?? currentProfile?.firstName ?? '';
    final senderRole = currentProfile?.role;
    final matchFirstName = widget.match.profile.firstName;

    final greeting = '${l10n.matchReachOutGreeting} $matchFirstName,\n\n\n\n\n';

    // Build prompt context section
    final promptContext = _buildPromptContext(l10n);

    final signature = senderRole != null && senderRole.isNotEmpty
        ? '\n\n$senderName\n$senderRole'
        : '\n\n$senderName';

    _initialText = greeting + promptContext + signature;
    _messageController.text = _initialText;
    // Position cursor after greeting and prompt context so user can type their message
    final cursorPosition = greeting.length + promptContext.length;
    _messageController.selection = TextSelection.collapsed(offset: cursorPosition);
  }

  /// Build the prompt context section showing the prompts that matched
  String _buildPromptContext(AppLocalizations l10n) {
    final prompts = widget.match.prompts;
    if (prompts == null || prompts.isEmpty) {
      return '';
    }

    final buffer = StringBuffer();

    // Add header based on singular/plural
    if (prompts.length == 1) {
      buffer.writeln(l10n.matchReachOutPromptContextSingular);
    } else {
      buffer.writeln(l10n.matchReachOutPromptContextPlural);
    }

    buffer.writeln();

    // Add each prompt with its interaction type selection title
    for (final prompt in prompts) {
      final selectionTitle = prompt.interactionType?.selectionTitle(context) ?? l10n.interactionTypeLookingForThisSelection;
      buffer.writeln('$selectionTitle ${prompt.label}');
    }

    //buffer.writeln(); // Add empty line after prompts

    return buffer.toString();
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageChanged);
    _messageController.dispose();
    super.dispose();
  }

  void _onMessageChanged() {
    setState(() {});
  }

  @override
  bool get canSave {
    final currentText = _messageController.text;
    // Disable save if text is empty or unchanged from initial template
    return currentText.trim().isNotEmpty && currentText != _initialText;
  }

  @override
  String getSuccessMessage() => '';

  @override
  String getErrorMessage() => '';

  @override
  Future<void> performSave() async {
    // Navigate to contacts page instead of saving
    await _navigateToContacts();
  }

  @override
  void navigateAfterSave() {
    // Don't navigate - we handle navigation in _navigateToContacts
  }

  Future<void> _navigateToContacts() async {
    final result = await Navigator.push<Stage?>(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => MatchReachOutContactsView(
          match: widget.match,
          message: _messageController.text,
        ),
      ),
    );

    // If message was sent successfully, pop back to match detail with the new stage
    if (result != null && mounted) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  bool get useScrollView => true;

  @override
  Widget buildSaveButton({String? label, VoidCallback? onPressed}) {
    final l10n = AppLocalizations.of(context)!;
    return super.buildSaveButton(label: l10n.actionNext);
  }

  @override
  Widget buildFormContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Subtitle explaining the purpose
        SubTitle(
          iconName: 'edit',
          title: l10n.matchReachOutSubtitle(widget.match.profile.firstName),
        ),

        const SizedBox(height: 16),

        // Message text area (no character limit)
        AppTextField(
          controller: _messageController,
          hintText: l10n.matchReachOutMessagePlaceholder,
          style: AppTextFieldStyle.textarea,
          maxLines: null,
          minLines: 9,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          enabled: !isUpdating,
        ),

        const SizedBox(height: 8),

        // Info box about email delivery
        FormInfoBox(
          content: l10n.matchReachOutInfoMessage,
        ),
      ],
    );
  }
}
