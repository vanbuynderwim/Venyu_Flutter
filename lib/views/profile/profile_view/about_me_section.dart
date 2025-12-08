import 'package:flutter/material.dart';

import '../../../core/utils/app_logger.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/prompt.dart';
import '../../../widgets/common/loading_state_widget.dart';
import '../../../widgets/common/empty_state_widget.dart';
import '../../prompts/prompt_item.dart';

/// AboutMeSection - Displays user's offers (this_is_me prompts)
///
/// This widget displays the user's offers in a list.
/// These are prompts where the user indicated "This is me".
///
/// Features:
/// - List of offers with PromptItem widgets
/// - Loading and empty states with action button
/// - Navigate to prompt detail on tap
class AboutMeSection extends StatelessWidget {
  final List<Prompt>? offers;
  final bool offersLoading;
  final Function(Prompt) onOfferTap;
  final VoidCallback? onCreateOffer;

  const AboutMeSection({
    super.key,
    required this.offers,
    required this.offersLoading,
    required this.onOfferTap,
    this.onCreateOffer,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    AppLogger.debug('Building about me section. Offers: ${offers?.length ?? 'null'}, Loading: $offersLoading', context: 'AboutMeSection');

    if (offersLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: LoadingStateWidget(),
      );
    }

    final List<Widget> children = [];

    if (offers == null || offers!.isEmpty) {
      children.add(
        EmptyStateWidget(
          message: l10n.profileSectionAboutMeTitle,
          description: l10n.aboutMeSectionEmptyDescription,
          onAction: onCreateOffer,
          actionText: l10n.aboutMeSectionEmptyAction,
          actionButtonIcon: context.themedIcon('edit'),
        ),
      );
    } else {
      for (final offer in offers!) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: PromptItem(
              prompt: offer,
              showChevron: true,
              showCounters: true,
              limitPromptLines: true,
              onPromptSelected: onOfferTap,
            ),
          ),
        );
      }
    }

    return Column(children: children);
  }
}
