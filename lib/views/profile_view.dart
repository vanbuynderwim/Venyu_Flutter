import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../core/theme/app_modifiers.dart';
import '../core/theme/venyu_theme.dart';
import '../models/enums/profile_sections.dart';
import '../models/enums/edit_personal_info_type.dart';
import '../models/enums/edit_company_info_type.dart';
import '../models/enums/review_type.dart';
import '../models/enums/category_type.dart';
import '../models/tag_group.dart';
import '../services/session_manager.dart';
import '../services/supabase_manager.dart';
import '../widgets/scaffolds/app_scaffold.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/buttons/section_button.dart';
import '../widgets/buttons/option_button.dart';
import '../widgets/common/loading_state_widget.dart';
import '../mixins/data_refresh_mixin.dart';
import 'profile_edit_view.dart';
import 'profile/edit_tag_group_view.dart';
import 'profile/edit_name_view.dart';
import 'profile/edit_bio_view.dart';
import 'profile/edit_account_view.dart';
import 'profile/edit_email_info_view.dart';
import 'company/edit_company_name_view.dart';
import 'profile/review_pending_cards_view.dart';

/// ProfileView - Current user's profile page
/// 
/// This is the main profile view that shows the current user's profile
/// information, including avatar, bio, and tags.
/// Cards, Venues, and Reviews sections have been moved to dedicated views.
/// 
/// Features:
/// - Profile header with avatar and bio (edit button included)
/// - Pull-to-refresh functionality
/// - Settings navigation
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with DataRefreshMixin {
  // Services
  late final SupabaseManager _supabaseManager;
  late final SessionManager _sessionManager;
  
  // State
  bool _isProfileLoading = true;
  ProfileSections _selectedSection = ProfileSections.personal;
  List<TagGroup>? _personalTagGroups;
  List<TagGroup>? _companyTagGroups;
  bool _personalTagGroupsLoading = false;
  bool _companyTagGroupsLoading = false;

  @override
  void initState() {
    super.initState();
    _supabaseManager = SupabaseManager.shared;
    _sessionManager = SessionManager.shared;
    
    // Listen to SessionManager updates for automatic profile refresh
    _sessionManager.addListener(_onSessionManagerUpdated);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProfile();
      // Load personal tag groups since it's the default selected section
      _loadPersonalTagGroups();
    });
  }

  @override
  void dispose() {
    _sessionManager.removeListener(_onSessionManagerUpdated);
    super.dispose();
  }
  
  /// Called when SessionManager notifies about profile updates
  void _onSessionManagerUpdated() {
    if (mounted) {
      setState(() {
        // Profile header and other UI will automatically rebuild
        // when SessionManager.currentProfile is updated
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _sessionManager.currentProfile;
    
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text('Profile'),
        trailingActions: [
          PlatformIconButton(
            padding: EdgeInsets.zero,
            icon: context.themedIcon('settings'),
            onPressed: () async {
              await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (context) => const EditAccountView(),
                ),
              );
              
              // No need to manually refresh - ProfileView automatically updates
              // when SessionManager.currentProfile changes via listener
            },
          ),
        ],
      ),
      useSafeArea: true,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _refreshProfile(forceRefresh: true),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 32.0),
                children: [
                
                // Profile Header
                if (!_isProfileLoading && profile != null)
                  _buildProfileHeader(profile)
                else
                  _buildLoadingProfileHeader(),
                
                const SizedBox(height: 16),
                
                // Section Button Bar
                if (!_isProfileLoading && profile != null)
                  _buildSectionButtonBar(),
                
                const SizedBox(height: 16),
                
                // Section Content
                if (!_isProfileLoading && profile != null)
                  _buildSectionContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the profile header with avatar, role, sectors, and bio
  Widget _buildProfileHeader(profile) {
    return ProfileHeader(
      profile: profile,
      isEditable: true,
      // No need for onBioEdited callback - ProfileView automatically updates
      // when SessionManager.currentProfile changes via listener
    );
  }

  /// Builds the section button bar
  Widget _buildSectionButtonBar() {
    final profile = _sessionManager.currentProfile;
    final availableSections = <ProfileSections>[
      ProfileSections.personal,
      ProfileSections.company,
      // Only show reviews for super admins
      if (profile?.isSuperAdmin == true) ProfileSections.reviews,
    ];
    
    return SectionButtonBar<ProfileSections>(
        sections: availableSections,
        selectedSection: _selectedSection,
        onSectionSelected: (section) {
          setState(() {
            _selectedSection = section;
          });
          // Load tag groups when section is selected
          if (section == ProfileSections.personal && _personalTagGroups == null) {
            _loadPersonalTagGroups();
          } else if (section == ProfileSections.company && _companyTagGroups == null) {
            _loadCompanyTagGroups();
          }
        },
      );
  }
  
  /// Builds the content for the selected section
  Widget _buildSectionContent() {
    switch (_selectedSection) {
      case ProfileSections.personal:
        return _buildPersonalSection();
      case ProfileSections.company:
        return _buildCompanySection();
      case ProfileSections.reviews:
        return _buildReviewsSection();
    }
  }
  
  /// Builds the personal info section content
  Widget _buildPersonalSection() {
    debugPrint('🔧 Building personal section. TagGroups: ${_personalTagGroups?.length ?? 'null'}, Loading: $_personalTagGroupsLoading');
    if (_personalTagGroupsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: LoadingStateWidget(
          height: 200,
          message: 'Loading personal info...',
        ),
      );
    }

    final List<Widget> children = [];
    
    // Fixed section - EditPersonalInfoType options
    for (final editPersonalInfoType in EditPersonalInfoType.values) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: OptionButton(
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
        ),
      );
    }
    
    // Dynamic section - TagGroup options from Supabase
    if (_personalTagGroups != null && _personalTagGroups!.isNotEmpty) {
      for (final tagGroup in _personalTagGroups!) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: OptionButton(
              option: tagGroup,
              isSelected: false,
              isMultiSelect: false,
              isSelectable: false,
              isCheckmarkVisible: false,
              isChevronVisible: true,
              isButton: true,
              withDescription: true,
              iconColor: tagGroup.color,
              onSelect: () {
                _handleTagGroupTap(tagGroup);
              },
            ),
          ),
        );
      }
    } else if (!_personalTagGroupsLoading && (_personalTagGroups?.isEmpty ?? false)) {
      // Show message if no tag groups are available
      children.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'No personal tag groups available',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ),
      );
    }
    
    return Column(children: children);
  }
  
  /// Builds the company info section content
  Widget _buildCompanySection() {
    debugPrint('🔧 Building company section. TagGroups: ${_companyTagGroups?.length ?? 'null'}, Loading: $_companyTagGroupsLoading');
    if (_companyTagGroupsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: LoadingStateWidget(
          height: 200,
          message: 'Loading company info...',
        ),
      );
    }

    final List<Widget> children = [];
    
    // Fixed section - EditCompanyInfoType options
    for (final editCompanyInfoType in EditCompanyInfoType.values) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: OptionButton(
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
        ),
      );
    }
    
    // Dynamic section - TagGroup options from Supabase  
    if (_companyTagGroups != null && _companyTagGroups!.isNotEmpty) {
      for (final tagGroup in _companyTagGroups!) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: OptionButton(
              option: tagGroup,
              isSelected: false,
              isMultiSelect: false,
              isSelectable: false,
              isCheckmarkVisible: false,
              isChevronVisible: true,
              isButton: true,
              withDescription: true,
              iconColor: tagGroup.color,
              onSelect: () {
                _handleCompanyTagGroupTap(tagGroup);
              },
            ),
          ),
        );
      }
    } else if (!_companyTagGroupsLoading && (_companyTagGroups?.isEmpty ?? false)) {
      // Show message if no tag groups are available
      children.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'No company tag groups available',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ),
      );
    }
    
    return Column(children: children);
  }
  
  /// Builds the reviews section content (admin only)
  Widget _buildReviewsSection() {
    final List<Widget> children = [];
    
    // User generated reviews
    children.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: OptionButton(
          option: ReviewType.user,
          isSelected: false,
          isMultiSelect: false,
          isSelectable: false,
          isCheckmarkVisible: false,
          isChevronVisible: true,
          isButton: true,
          withDescription: true,
          onSelect: () {
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (context) => ReviewPendingCardsView(
                  reviewType: ReviewType.user,
                ),
              ),
            );
          },
        ),
      ),
    );
    
    // AI generated reviews  
    children.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: OptionButton(
          option: ReviewType.system,
          isSelected: false,
          isMultiSelect: false,
          isSelectable: false,
          isCheckmarkVisible: false,
          isChevronVisible: true,
          isButton: true,
          withDescription: true,
          onSelect: () {
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (context) => ReviewPendingCardsView(
                  reviewType: ReviewType.system,
                ),
              ),
            );
          },
        ),
      ),
    );
    
    return Column(children: children);
  }

  /// Builds a loading placeholder for the profile header
  Widget _buildLoadingProfileHeader() {
    final venyuTheme = context.venyuTheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: AppModifiers.cardContentPadding,
      decoration: BoxDecoration(
        color: venyuTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: venyuTheme.borderColor,
          width: AppModifiers.extraThinBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: venyuTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 150,
                  color: venyuTheme.primary.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: 100,
                  color: venyuTheme.primary.withValues(alpha: 0.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  /// Refreshes profile data
  Future<void> _refreshProfile({bool forceRefresh = false}) async {
    if (!_sessionManager.isAuthenticated) return;
    
    setState(() {
      _isProfileLoading = true;
    });
    
    try {
      // Refresh profile data from server when forced or when needed
      if (forceRefresh) {
        final refreshedProfile = await _supabaseManager.fetchUserProfile();
        _sessionManager.updateCurrentProfile(refreshedProfile);
      }
      
      setState(() {
        _isProfileLoading = false;
      });
      
    } catch (error) {
      debugPrint('Error refreshing profile data: $error');
      setState(() {
        _isProfileLoading = false;
      });
    }
  }
  
  /// Loads personal tag groups
  void _loadPersonalTagGroups() async {
    setState(() {
      _personalTagGroupsLoading = true;
    });
    
    try {
      final tagGroups = await _supabaseManager.fetchTagGroups(CategoryType.personal);
      debugPrint('✅ Loaded ${tagGroups.length} personal tag groups');
      if (mounted) {
        setState(() {
          _personalTagGroups = tagGroups;
          _personalTagGroupsLoading = false;
        });
      }
    } catch (error) {
      debugPrint('❌ Error loading personal tag groups: $error');
      if (mounted) {
        setState(() {
          _personalTagGroups = [];
          _personalTagGroupsLoading = false;
        });
      }
    }
  }
  
  /// Loads company tag groups
  void _loadCompanyTagGroups() async {
    setState(() {
      _companyTagGroupsLoading = true;
    });
    
    try {
      final tagGroups = await _supabaseManager.fetchTagGroups(CategoryType.company);
      debugPrint('✅ Loaded ${tagGroups.length} company tag groups');
      if (mounted) {
        setState(() {
          _companyTagGroups = tagGroups;
          _companyTagGroupsLoading = false;
        });
      }
    } catch (error) {
      debugPrint('❌ Error loading company tag groups: $error');
      if (mounted) {
        setState(() {
          _companyTagGroups = [];
          _companyTagGroupsLoading = false;
        });
      }
    }
  }
  
  /// Handles personal info option tap
  void _handlePersonalInfoTap(EditPersonalInfoType type) async {
    debugPrint('Tapped on personal info type: ${type.title}');
    
    switch (type) {
      case EditPersonalInfoType.name:
        await Navigator.push<bool>(
          context,
          platformPageRoute(
            context: context,
            builder: (context) => const EditNameView(),
          ),
        );
        break;
      case EditPersonalInfoType.bio:
        await Navigator.push<bool>(
          context,
          platformPageRoute(
            context: context,
            builder: (context) => const EditBioView(),
          ),
        );
        break;
      case EditPersonalInfoType.email:
        await Navigator.push<bool>(
          context,
          platformPageRoute(
            context: context,
            builder: (context) => const EditEmailInfoView(),
          ),
        );
        break;
    }
  }
  
  /// Handles company info option tap
  void _handleCompanyInfoTap(EditCompanyInfoType type) async {
    debugPrint('Tapped on company info type: ${type.title}');
    
    switch (type) {
      case EditCompanyInfoType.name:
        await Navigator.push<bool>(
          context,
          platformPageRoute(
            context: context,
            builder: (context) => const EditCompanyNameView(),
          ),
        );
        break;
    }
  }
  
  /// Handles personal tag group tap
  void _handleTagGroupTap(TagGroup tagGroup) async {
    debugPrint('Tapped on personal tag group: ${tagGroup.title}');
    
    final result = await Navigator.push<bool>(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => EditTagGroupView(tagGroup: tagGroup),
      ),
    );
    
    if (result == true) {
      _loadPersonalTagGroups();
    }
  }
  
  /// Handles company tag group tap
  void _handleCompanyTagGroupTap(TagGroup tagGroup) async {
    debugPrint('Tapped on company tag group: ${tagGroup.title}');
    
    final result = await Navigator.push<bool>(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => EditTagGroupView(tagGroup: tagGroup),
      ),
    );
    
    if (result == true) {
      _loadCompanyTagGroups();
    }
  }
}