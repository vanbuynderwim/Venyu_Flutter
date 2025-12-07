import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/contact.dart';
import '../../models/match.dart';
import '../../models/stage.dart';
import '../../services/profile_service.dart';
import '../../services/supabase_managers/matching_manager.dart';
import '../base/base_form_view.dart';
import 'match_reach_out_finish_view.dart';

/// Preview page for reach out message before sending.
///
/// Shows the message and selected contact information
/// in a card format so the user can see how it will look.
class MatchReachOutPreviewView extends BaseFormView {
  final Match match;
  final String message;
  final List<Contact> selectedContacts;

  const MatchReachOutPreviewView({
    super.key,
    required this.match,
    required this.message,
    required this.selectedContacts,
  });

  @override
  BaseFormViewState<BaseFormView> createState() =>
      _MatchReachOutPreviewViewState();
}

class _MatchReachOutPreviewViewState
    extends BaseFormViewState<MatchReachOutPreviewView> {
  Stage? _newStage;

  @override
  String getFormTitle() =>
      AppLocalizations.of(context)!.matchReachOutPreviewTitle;

  @override
  String getSuccessMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.matchReachOutSuccessMessage;
  }

  @override
  String getErrorMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.matchReachOutErrorMessage;
  }

  @override
  Future<void> performSave() async {
    // Build full email content including contacts and PS
    final fullContent = _buildFullEmailContent();

    // Send contact request
    await MatchingManager.shared.sendContactRequest(
      matchId: widget.match.id,
      contactSettingIds: widget.selectedContacts.map((c) => c.id).toList(),
      content: fullContent,
    );

    // Fetch the updated stages to get the new stage
    final stages = await MatchingManager.shared.getMatchConnectionStages(widget.match.id);
    _newStage = stages.where((s) => s.selected).firstOrNull;
  }

  /// Build the full email content including message, contact info, and PS
  String _buildFullEmailContent() {
    final l10n = AppLocalizations.of(context)!;
    final buffer = StringBuffer();

    // Add the message
    buffer.write(widget.message);

    // Add contact information if any
    if (widget.selectedContacts.isNotEmpty) {
      buffer.write('\n\n---\n\n');
      for (final contact in widget.selectedContacts) {
        buffer.writeln('${contact.label}: ${contact.value}');
      }
    }

    // Add PS
    buffer.write('\n${l10n.matchReachOutPreviewPS}');

    return buffer.toString();
  }

  @override
  Future<void> navigateAfterSave() async {
    // Navigate to finish view
    final result = await Navigator.of(context).push<bool>(
      platformPageRoute(
        context: context,
        builder: (context) => MatchReachOutFinishView(
          message: widget.message,
          selectedContacts: widget.selectedContacts,
        ),
      ),
    );

    // If done was pressed, pop back to match detail (through reach out view)
    // Return the new stage so match_detail can update locally
    if (result == true && mounted) {
      Navigator.of(context).pop(_newStage);
    }
  }

  @override
  bool get useScrollView => true;

  @override
  Widget buildSaveButton({String? label, VoidCallback? onPressed}) {
    final l10n = AppLocalizations.of(context)!;
    return super.buildSaveButton(label: l10n.actionSend);
  }

  @override
  Widget buildFormContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final venyuTheme = context.venyuTheme;
    final currentProfile = ProfileService.shared.currentProfile;
    final senderName =
        currentProfile?.fullName ?? currentProfile?.firstName ?? '';
    final replyToEmail = currentProfile?.contactEmail ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // From, Reply-to, and Subject lines
        _buildEmailHeader(
          context,
          label: l10n.matchReachOutPreviewFromLabel,
          value: l10n.matchReachOutPreviewFromValue(senderName),
        ),
        const SizedBox(height: 16),
        _buildEmailHeader(
          context,
          label: l10n.matchReachOutPreviewReplyToLabel,
          value: replyToEmail,
        ),
        const SizedBox(height: 16),
        _buildEmailHeader(
          context,
          label: l10n.matchReachOutPreviewSubjectLabel,
          value: l10n.matchReachOutPreviewSubject(senderName.split(' ').first),
        ),

        const SizedBox(height: 16),

        // Message preview card
        Container(
          decoration: AppLayoutStyles.cardDecoration(context),
          padding: AppModifiers.cardContentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Message text (includes greeting, message body, and signature)
              Text(
                widget.message,
                style: AppTextStyles.body.copyWith(
                  color: venyuTheme.primaryText,
                ),
              ),

              // Contact information section
              if (widget.selectedContacts.isNotEmpty) ...[
                const SizedBox(height: 16),

                // Divider (3 dashes)
                Text(
                  '---',
                  style: AppTextStyles.body.copyWith(
                    color: venyuTheme.secondaryText,
                  ),
                ),

                const SizedBox(height: 16),

                // Contact information list
                ...widget.selectedContacts.map(
                  (contact) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '${contact.label}: ${contact.value}',
                      style: AppTextStyles.body.copyWith(
                        color: venyuTheme.primaryText,
                      ),
                    ),
                  ),
                ),
              ],

              // PS message
              const SizedBox(height: 16),
              Text(
                l10n.matchReachOutPreviewPS,
                style: AppTextStyles.caption1.copyWith(
                  color: venyuTheme.secondaryText,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailHeader(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final venyuTheme = context.venyuTheme;
    const labelWidth = 80.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            '$label:',
            style: AppTextStyles.subheadline.copyWith(
              color: venyuTheme.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.subheadline.copyWith(
              color: venyuTheme.primaryText,
            ),
          ),
        ),
      ],
    );
  }
}
