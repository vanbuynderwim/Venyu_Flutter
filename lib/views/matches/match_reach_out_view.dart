import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/match.dart';
import '../../models/stage.dart';
import '../../services/profile_service.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/form_info_box.dart';
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

  static const int _minMessageLength = 20;

  @override
  String getFormTitle() => AppLocalizations.of(context)!.matchReachOutTitle;

  @override
  void initializeForm() {
    super.initializeForm();
    _messageController.addListener(_onMessageChanged);
  }

  /// Build the greeting text
  String _buildGreeting(AppLocalizations l10n) {
    final matchFirstName = widget.match.profile.firstName;
    return '${l10n.matchReachOutGreeting} $matchFirstName,';
  }

  /// Build the signature text
  String _buildSignature() {
    final currentProfile = ProfileService.shared.currentProfile;
    final senderName = currentProfile?.fullName ?? currentProfile?.firstName ?? '';
    final senderRole = currentProfile?.role;

    if (senderRole != null && senderRole.isNotEmpty) {
      return '$senderName\n$senderRole';
    }
    return senderName;
  }

  /// Build the prompt context section for the email message
  String _buildPromptContext(AppLocalizations l10n) {
    final prompts = widget.match.prompts;
    if (prompts == null || prompts.isEmpty) {
      return '';
    }

    final buffer = StringBuffer();

        // Add each prompt with its interaction type selection title
    for (final prompt in prompts) {
      final selectionTitle = prompt.interactionType?.selectionTitle(context) ?? l10n.interactionTypeLookingForThisSelection;
      buffer.writeln('$selectionTitle ${prompt.label}');
    }

    return buffer.toString();
  }

  /// Build the prompt context display for the UI
  String _buildPromptContextDisplay(AppLocalizations l10n) {
    final prompts = widget.match.prompts;
    if (prompts == null || prompts.isEmpty) {
      return '';
    }

    final buffer = StringBuffer();

    // Add each prompt with its interaction type selection title
    for (int i = 0; i < prompts.length; i++) {
      final prompt = prompts[i];
      final selectionTitle = prompt.interactionType?.selectionTitle(context) ?? l10n.interactionTypeLookingForThisSelection;
      buffer.write('$selectionTitle ${prompt.label}');
      if (i < prompts.length - 1) {
        buffer.writeln();
      }
    }

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

  /// Build the minimum character counter widget
  Widget _buildCharacterCounter(VenyuTheme venyuTheme) {
    final currentLength = _messageController.text.trim().length;
    final remaining = _minMessageLength - currentLength;
    final hasReachedMinimum = remaining <= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: venyuTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        hasReachedMinimum ? '$currentLength' : '$currentLength/$_minMessageLength',
        style: AppTextStyles.caption1.copyWith(
          color: hasReachedMinimum ? venyuTheme.success : venyuTheme.secondaryText,
        ),
      ),
    );
  }

  @override
  bool get canSave {
    final currentText = _messageController.text.trim();
    // Require minimum message length
    return currentText.length >= _minMessageLength;
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
    final l10n = AppLocalizations.of(context)!;

    // Build full message with greeting, prompt context, message body and signature
    final greeting = _buildGreeting(l10n);
    final promptContext = _buildPromptContext(l10n);
    final messageBody = _messageController.text.trim();
    final signature = _buildSignature();

    final buffer = StringBuffer();
    buffer.writeln(greeting);
    buffer.writeln();
    if (promptContext.isNotEmpty) {
      buffer.write(promptContext);
      buffer.writeln();
    }
    buffer.writeln(messageBody);
    buffer.writeln();
    buffer.write(signature);

    final fullMessage = buffer.toString();

    final result = await Navigator.push<Stage?>(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => MatchReachOutContactsView(
          match: widget.match,
          message: fullMessage,
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
    final venyuTheme = context.venyuTheme;
    final greeting = _buildGreeting(l10n);
    final signature = _buildSignature();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        
        // Greeting text
        Text(
          greeting,
          style: AppTextStyles.body.copyWith(
            color: venyuTheme.primaryText,
          ),
        ),

        const SizedBox(height: 16),

        // Prompt context text
        if (widget.match.prompts != null && widget.match.prompts!.isNotEmpty) ...[
          Text(
            _buildPromptContextDisplay(l10n),
            style: AppTextStyles.body.copyWith(
              color: venyuTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Message text area with minimum character counter
        Stack(
          children: [
            AppTextField(
              controller: _messageController,
              hintText: l10n.matchReachOutMessagePlaceholder,
              style: AppTextFieldStyle.textarea,
              maxLines: null,
              minLines: 6,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              enabled: !isUpdating,
              autofocus: true,
            ),
            // Minimum character counter overlay
            Positioned(
              bottom: 8,
              right: 8,
              child: _buildCharacterCounter(venyuTheme),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Signature text
        Text(
          signature,
          style: AppTextStyles.body.copyWith(
            color: venyuTheme.primaryText,
          ),
        ),

        const SizedBox(height: 16),

        // Info box about email delivery
        FormInfoBox(
          content: l10n.matchReachOutInfoMessage,
        ),
      ],
    );
  }
}
