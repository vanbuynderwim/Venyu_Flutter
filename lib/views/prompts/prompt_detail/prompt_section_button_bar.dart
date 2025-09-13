import 'package:flutter/material.dart';

import '../../../models/enums/prompt_sections.dart';
import '../../../widgets/buttons/section_button.dart';

/// PromptSectionButtonBar - Section toggle buttons for prompt detail view
///
/// This widget displays the section toggle buttons that allow switching
/// between Card, Stats, and Intro sections in the prompt detail view.
///
/// Features:
/// - Section selection state management
/// - Callback handling for section changes
/// - All sections always available (no conditional logic)
class PromptSectionButtonBar extends StatelessWidget {
  final PromptSections selectedSection;
  final Function(PromptSections) onSectionSelected;

  const PromptSectionButtonBar({
    super.key,
    required this.selectedSection,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    const availableSections = [
      PromptSections.intro,
      PromptSections.card,
      PromptSections.stats,
      
    ];

    return SectionButtonBar<PromptSections>(
      sections: availableSections,
      selectedSection: selectedSection,
      onSectionSelected: onSectionSelected,
    );
  }
}