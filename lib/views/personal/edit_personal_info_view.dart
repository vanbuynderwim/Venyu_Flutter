import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../models/enums/edit_personal_info_type.dart';
import '../../models/enums/category_type.dart';
import '../../models/tag_group.dart';
import '../../widgets/buttons/option_button.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/common/error_state_widget.dart';
import '../../services/supabase_manager.dart';
import '../../mixins/data_refresh_mixin.dart';
import '../profile/edit_tag_group_view.dart';
import '../profile/edit_name_view.dart';
import '../profile/edit_bio_view.dart';

/// EditPersonalInfoView - Flutter equivalent of iOS EditPersonalInfoView
class EditPersonalInfoView extends StatefulWidget {
  const EditPersonalInfoView({super.key});

  @override
  State<EditPersonalInfoView> createState() => _EditPersonalInfoViewState();
}

class _EditPersonalInfoViewState extends State<EditPersonalInfoView> with DataRefreshMixin {
  final SupabaseManager _supabaseManager = SupabaseManager.shared;
  List<TagGroup>? _tagGroups;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    refreshData(
      () => _supabaseManager.fetchTagGroups(CategoryType.personal),
      (tagGroups) => setState(() => _tagGroups = tagGroups),
      context: 'loading personal info tag groups',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppListScaffold(
      appBar: PlatformAppBar(
        title: const Text('Personal info'),
      ),
      children: _buildContent(),
    );
  }

  List<Widget> _buildContent() {
    if (isLoading) {
      return [
        const LoadingStateWidget(
          height: 200,
          message: 'Loading personal info...',
        ),
      ];
    }

    if (error != null) {
      return [
        ErrorStateWidget(
          error: error!,
          title: 'Failed to load personal info',
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

    // Fixed section - EditPersonalInfoType options
    for (final editPersonalInfoType in EditPersonalInfoType.values) {
      children.add(
        OptionButton(
          option: editPersonalInfoType,
          isSelected: false,
          isMultiSelect: false,
          isSelectable: false,
          isCheckmarkVisible: false,
          isChevronVisible: true,
          isButton: true,
          withDescription: true,
          onSelect: () {
            _handlePersonalInfoTap(editPersonalInfoType);
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

  void _handlePersonalInfoTap(EditPersonalInfoType type) async {
    debugPrint('Tapped on personal info type: ${type.title}');
    
    switch (type) {
      case EditPersonalInfoType.name:
        debugPrint('Navigate to Name edit page');
        final result = await Navigator.push<bool>(
          context,
          platformPageRoute(
            context: context,
            builder: (context) => const EditNameView(),
          ),
        );
        
        // Name changes don't affect the tag list display, so no refresh needed
        // But we could add it for consistency if other profile data is shown
        break;
      case EditPersonalInfoType.bio:
        debugPrint('Navigate to Bio edit page');
        final bioResult = await Navigator.push<bool>(
          context,
          platformPageRoute(
            context: context,
            builder: (context) => const EditBioView(),
          ),
        );
        
        // Bio changes don't affect the tag list display, so no refresh needed
        if (bioResult == true) {
          debugPrint('Bio updated successfully');
        }
        break;
      case EditPersonalInfoType.email:
        debugPrint('Navigate to Email edit page');
        // TODO: Navigate to email edit page
        break;
    }
  }

  void _handleTagGroupTap(TagGroup tagGroup) async {
    debugPrint('Tapped on tag group: ${tagGroup.title}');
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
      debugPrint('Tag changes detected, refreshing data...');
      _loadData();
    }
  }
}