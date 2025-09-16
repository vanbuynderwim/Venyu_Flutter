import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../mixins/error_handling_mixin.dart';
// import '../../models/enums/prompt_sections.dart';
import '../../models/prompt.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/loading_state_widget.dart';
import 'prompt_item.dart';
// import 'prompt_detail/prompt_section_button_bar.dart';
// import 'prompt_detail/prompt_card_section.dart';
// import 'prompt_detail/prompt_stats_section.dart';
import 'prompt_detail/prompt_intro_section.dart';

/// PromptDetailView - Shows a prompt with its associated matches
/// 
/// This view displays:
/// - The prompt at the top (using PromptItem)
/// - List of matches associated with this prompt
/// - Navigation to match details when tapping a match
class PromptDetailView extends StatefulWidget {
  final String promptId;

  const PromptDetailView({
    super.key,
    required this.promptId,
  });

  @override
  State<PromptDetailView> createState() => _PromptDetailViewState();
}

class _PromptDetailViewState extends State<PromptDetailView> with ErrorHandlingMixin {
  late final ContentManager _contentManager;

  Prompt? _prompt;
  String? _error;
  // PromptSections _selectedSection = PromptSections.card;

  @override
  void initState() {
    super.initState();
    _contentManager = ContentManager.shared;
    _loadPromptData();
  }

  Future<void> _loadPromptData() async {
    if (!mounted) return;
    setState(() => _error = null);

    await executeWithLoading(
      operation: () async {
        // Fetch the prompt
        final prompt = await _contentManager.fetchPrompt(widget.promptId);

        if (prompt != null && mounted) {
          setState(() => _prompt = prompt);
        } else if (mounted) {
          setState(() => _error = 'Failed to load prompt');
        }
      },
      showErrorToast: false,
      onError: (error) {
        AppLogger.error('Error loading prompt data: $error', context: 'PromptDetailView');
        if (mounted) {
          setState(() => _error = 'Failed to load prompt data');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text('Your card'),
      ),
      usePadding: false,
      useSafeArea: true,
      body: RefreshIndicator(
        onRefresh: _loadPromptData,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32.0),
          children: [
            // Prompt item header (scrolls with content)
            if (_prompt != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PromptItem(
                  prompt: _prompt!,
                  reviewing: false,
                  isFirst: true,
                  isLast: true,
                  showMatchInteraction: false,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Section button bar
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: PromptSectionButtonBar(
            //     selectedSection: _selectedSection,
            //     onSectionSelected: (section) {
            //       setState(() {
            //         _selectedSection = section;
            //       });
            //     },
            //   ),
            // ),

            // const SizedBox(height: 16),

            // Matches content
            PromptIntroSection(
              prompt: _prompt,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}