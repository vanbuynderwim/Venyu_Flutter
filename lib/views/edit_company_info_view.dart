import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../core/theme/app_theme.dart';
import '../models/enums/edit_company_info_type.dart';
import '../models/enums/category_type.dart';
import '../models/tag_group.dart';
import '../widgets/buttons/option_button.dart';
import '../widgets/scaffolds/app_scaffold.dart';
import '../widgets/common/loading_state_widget.dart';
import '../widgets/common/error_state_widget.dart';
import '../services/supabase_manager.dart';
import '../mixins/data_refresh_mixin.dart';
import 'edit_tag_group_view.dart';
import 'company/edit_company_name_view.dart';

/// EditCompanyInfoView - Flutter equivalent of iOS EditCompanyInfoView
class EditCompanyInfoView extends StatefulWidget {
  const EditCompanyInfoView({super.key});

  @override
  State<EditCompanyInfoView> createState() => _EditCompanyInfoViewState();
}

class _EditCompanyInfoViewState extends State<EditCompanyInfoView> with DataRefreshMixin {
  final SupabaseManager _supabaseManager = SupabaseManager.shared;
  List<TagGroup>? _tagGroups;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    refreshData(
      () => _supabaseManager.fetchTagGroups(CategoryType.company),
      (tagGroups) => setState(() => _tagGroups = tagGroups),
      context: 'loading company info tag groups',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppListScaffold(
      appBar: PlatformAppBar(
        title: const Text('Company info'),
      ),
      children: _buildContent(),
    );
  }

  List<Widget> _buildContent() {
    if (isLoading) {
      return [
        const LoadingStateWidget(
          height: 200,
          message: 'Loading company info...',
        ),
      ];
    }

    if (error != null) {
      return [
        ErrorStateWidget(
          error: error!,
          title: 'Failed to load company info',
          height: 200,
          onRetry: _loadData,
        ),
      ];
    }

    if (_tagGroups == null || _tagGroups!.isEmpty) {
      return [
        const SizedBox(
          height: 200,
          child: Center(
            child: Text('No data available'),
          ),
        ),
      ];
    }

    final List<Widget> children = [];

    // Fixed section - EditCompanyInfoType options
    for (final editCompanyInfoType in EditCompanyInfoType.values) {
      children.add(
        OptionButton(
          option: editCompanyInfoType,
          isSelected: false,
          isMultiSelect: false,
          isSelectable: false,
          isCheckmarkVisible: false,
          isChevronVisible: true,
          isButton: true,
          withDescription: true,
          onSelect: () {
            _handleCompanyInfoTap(editCompanyInfoType);
          },
        ),
      );
    }

    // Dynamic section - TagGroup options from Supabase
    for (final tagGroup in _tagGroups!) {
      children.add(
        OptionButton(
          option: tagGroup,
          isSelected: false,
          isMultiSelect: false,
          isSelectable: false,
          isCheckmarkVisible: false,
          isChevronVisible: true,
          isButton: true,
          withDescription: true,
          iconColor: tagGroup.color, // Use dynamic color based on selection
          onSelect: () {
            _handleTagGroupTap(tagGroup);
          },
        ),
      );
    }

    return children;
  }

  void _handleCompanyInfoTap(EditCompanyInfoType type) async {
    debugPrint('Tapped on company info type: ${type.title}');
    
    switch (type) {
      case EditCompanyInfoType.name:
        debugPrint('Navigate to Company edit page');
        final result = await Navigator.push<bool>(
          context,
          platformPageRoute(
            context: context,
            builder: (context) => const EditCompanyNameView(),
          ),
        );
        
        // Company name changes don't affect the tag list display, so no refresh needed
        // But we could add it for consistency if other company data is shown
        if (result == true) {
          debugPrint('Company info updated successfully');
        }
        break;
    }
  }

  void _handleTagGroupTap(TagGroup tagGroup) async {
    debugPrint('Tapped on company tag group: ${tagGroup.title}');
    debugPrint('Tag group has ${tagGroup.tags?.length ?? 0} tags');
    
    final result = await Navigator.push<bool>(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => EditTagGroupView(tagGroup: tagGroup),
      ),
    );
    
    // If changes were saved, refresh the data to show updated tags
    if (result == true) {
      debugPrint('Company tag changes detected, refreshing data...');
      _loadData();
    }
  }
}