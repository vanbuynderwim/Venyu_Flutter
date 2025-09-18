import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/models.dart';
import '../../models/venue.dart';
import '../../widgets/prompts/prompt_display_widget.dart';

/// Prompt First Call configuration view
///
/// This view allows users to configure First Call settings for their prompt.
/// Features:
/// - Shows prompt preview
/// - First Call toggle/configuration
/// - Navigation to final publish step
class PromptFirstCallView extends StatefulWidget {
  final InteractionType interactionType;
  final String promptLabel;
  final Venue? selectedVenue;
  final Prompt? existingPrompt;
  final bool isFromPrompts;
  final VoidCallback? onCloseModal;

  const PromptFirstCallView({
    super.key,
    required this.interactionType,
    required this.promptLabel,
    this.selectedVenue,
    this.existingPrompt,
    this.isFromPrompts = false,
    this.onCloseModal,
  });

  @override
  State<PromptFirstCallView> createState() => _PromptFirstCallViewState();
}

class _PromptFirstCallViewState extends State<PromptFirstCallView> {
  bool _withPreview = false;

  void _handleNext() {
    // TODO: Navigate to final publish step with First Call configuration
    // This will be the final step that actually calls upsertPrompt
    Navigator.pushNamed(
      context,
      '/prompt_publish',
      arguments: {
        'interactionType': widget.interactionType,
        'promptLabel': widget.promptLabel,
        'selectedVenue': widget.selectedVenue,
        'withPreview': _withPreview,
        'existingPrompt': widget.existingPrompt,
        'isFromPrompts': widget.isFromPrompts,
        'onCloseModal': widget.onCloseModal,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('First Call'),
        trailingActions: [
          TextButton(
            onPressed: _handleNext,
            child: const Text('Next'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Prompt preview (half screen)
          Expanded(
            child: PromptDisplayWidget(
              promptLabel: widget.promptLabel,
              interactionType: widget.interactionType,
              showInteractionType: true,
            ),
          ),

          // First Call configuration section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'First Call Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Preview toggle
                SwitchListTile(
                  title: const Text('Enable First Call'),
                  subtitle: const Text('Your matches will see this only if you\'re interested'),
                  value: _withPreview,
                  onChanged: (value) {
                    setState(() => _withPreview = value);
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}