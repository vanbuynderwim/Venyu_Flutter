import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../core/theme/app_theme.dart';
import '../models/enums/edit_company_info_type.dart';
import '../models/enums/category_type.dart';
import '../models/tag_group.dart';
import '../widgets/buttons/option_button.dart';
import '../widgets/scaffolds/app_scaffold.dart';
import '../services/supabase_manager.dart';
import 'edit_tag_group_view.dart';

/// EditCompanyInfoView - Flutter equivalent of iOS EditCompanyInfoView
class EditCompanyInfoView extends StatefulWidget {
  const EditCompanyInfoView({super.key});

  @override
  State<EditCompanyInfoView> createState() => _EditCompanyInfoViewState();
}

class _EditCompanyInfoViewState extends State<EditCompanyInfoView> {
  final SupabaseManager _supabaseManager = SupabaseManager.shared;
  List<TagGroup>? _tagGroups;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final tagGroups = await _supabaseManager.fetchTagGroups(CategoryType.company);
      setState(() {
        _tagGroups = tagGroups;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Error fetching company tag groups: $error');
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
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
    if (_isLoading) {
      return [
        SizedBox(
          height: 200,
          child: Center(
            child: PlatformCircularProgressIndicator(),
          ),
        ),
      ];
    }

    if (_error != null) {
      return [
        SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load data',
                  style: AppTextStyles.headline,
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                PlatformElevatedButton(
                  onPressed: _refreshData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
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

  void _handleCompanyInfoTap(EditCompanyInfoType type) {
    debugPrint('Tapped on company info type: ${type.title}');
    
    // TODO: Navigate to specific edit pages based on type
    switch (type) {
      case EditCompanyInfoType.name:
        debugPrint('Navigate to Company edit page');
        // TODO: Navigate to company edit page
        break;
    }
  }

  void _handleTagGroupTap(TagGroup tagGroup) {
    debugPrint('Tapped on company tag group: ${tagGroup.title}');
    debugPrint('Tag group has ${tagGroup.tags?.length ?? 0} tags');
    
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => EditTagGroupView(tagGroup: tagGroup),
      ),
    );
  }
}