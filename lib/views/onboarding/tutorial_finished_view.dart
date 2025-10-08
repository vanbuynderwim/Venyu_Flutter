import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../services/toast_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background.dart';
import '../prompts/daily_prompts_view.dart';

/// View shown after completing the tutorial dummy prompts
///
/// This view congratulates the user on completing the quick tour and explains
/// that they're now ready to answer real cards.
class TutorialFinishedView extends StatefulWidget {
  const TutorialFinishedView({super.key});

  @override
  State<TutorialFinishedView> createState() => _TutorialFinishedViewState();
}

class _TutorialFinishedViewState extends State<TutorialFinishedView> {
  bool _isLoading = false;

  Future<void> _handleLetsGo() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch real prompts (created by complete_registration RPC)
      // Note: We don't refresh profile here to avoid MainView showing prompts modal
      // Profile will be refreshed after user answers these prompts
      AppLogger.debug('Fetching real prompts', context: 'TutorialFinishedView');
      final contentManager = ContentManager.shared;
      final prompts = await contentManager.fetchPrompts();

      AppLogger.success('Fetched ${prompts.length} prompts', context: 'TutorialFinishedView');

      if (!mounted) return;

      if (prompts.isEmpty) {
        // No prompts available - show message and return
        ToastService.info(
          context: context,
          message: 'No cards available at the moment. Check back later!',
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Navigate to daily prompts with real prompts
      // Mark as post-tutorial so profile refresh happens after completion
      Navigator.of(context).push(
        platformPageRoute(
          context: context,
          builder: (_) => DailyPromptsView(
            prompts: prompts,
            isFirstTimeUser: false,
            isPostTutorialRealPrompts: true,
          ),
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      AppLogger.error('Failed to fetch prompts', error: error, context: 'TutorialFinishedView');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ToastService.error(
          context: context,
          message: 'Failed to load cards. Please try again.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen radar background image
          const RadarBackground(),

          // Content overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                children: [
                  const Spacer(),

                  // Main content
                  Column(
                    children: [
                      Text(
                        'You\'re all set! 🎉',
                        style: AppTextStyles.title2.copyWith(
                          color: venyuTheme.primaryText,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'You\'ve completed the quick tour. Now you\'re ready to start answering your first 3 real cards to get matched with other entrepreneurs.',
                        style: AppTextStyles.subheadline.copyWith(
                          color: venyuTheme.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Start button
                  ActionButton(
                    label: 'Let\'s go!',
                    width: 120,
                    onPressed: _isLoading ? null : _handleLetsGo,
                    isLoading: _isLoading,
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
