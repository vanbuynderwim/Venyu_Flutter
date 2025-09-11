import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../models/enums/profile_sections.dart';
import '../../models/enums/edit_personal_info_type.dart';
import '../../models/enums/edit_company_info_type.dart';
import '../../models/enums/category_type.dart';
import '../../models/tag_group.dart';
import '../../core/providers/app_providers.dart';
import '../../services/profile_service.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/buttons/fab_button.dart';
import '../../mixins/data_refresh_mixin.dart';
import '../venues/join_venue_view.dart';
import 'profile_header.dart';
import 'profile_view/profile_section_button_bar.dart';
import 'profile_view/personal_info_section.dart';
import 'profile_view/company_info_section.dart';
import 'profile_view/venues_section.dart';
import 'profile_view/reviews_section.dart';
import 'profile_view/profile_loading_header.dart';
import 'edit_tag_group_view.dart';
import 'edit_name_view.dart';
import 'edit_bio_view.dart';
import 'edit_account_view.dart';
import 'edit_email_info_view.dart';
import 'edit_company_name_view.dart';

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

class _ProfileViewState extends State<ProfileView> with DataRefreshMixin, ErrorHandlingMixin {
  // Services
  late final ContentManager _contentManager;
  late final ProfileManager _profileManager;
  
  // State
  bool _isProfileLoading = true;
  ProfileSections _selectedSection = ProfileSections.personal;
  List<TagGroup>? _personalTagGroups;
  List<TagGroup>? _companyTagGroups;
  bool _personalTagGroupsLoading = false;
  bool _companyTagGroupsLoading = false;
  bool _hasVenues = false;

  @override
  void initState() {
    super.initState();
    _contentManager = ContentManager.shared;
    _profileManager = ProfileManager.shared;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProfile();
      // Load personal tag groups since it's the default selected section
      _loadPersonalTagGroups();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileService = context.profileService;
    final profile = profileService.currentProfile;
    
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
      floatingActionButton: _shouldShowFAB()
          ? FABButton(
              icon: context.themedIcon('plus'),
              label: 'Join',
              onPressed: _openJoinVenueModal,
            )
          : null,
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
                  const ProfileLoadingHeader(),
                
                const SizedBox(height: 16),
                
                // Section Button Bar
                if (!_isProfileLoading && profile != null)
                  ProfileSectionButtonBar(
                    profile: profile,
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
                  ),
                
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

  
  /// Builds the content for the selected section
  Widget _buildSectionContent() {
    switch (_selectedSection) {
      case ProfileSections.personal:
        return PersonalInfoSection(
          personalTagGroups: _personalTagGroups,
          personalTagGroupsLoading: _personalTagGroupsLoading,
          onPersonalInfoTap: _handlePersonalInfoTap,
          onTagGroupTap: _handleTagGroupTap,
        );
      case ProfileSections.company:
        return CompanyInfoSection(
          companyTagGroups: _companyTagGroups,
          companyTagGroupsLoading: _companyTagGroupsLoading,
          onCompanyInfoTap: _handleCompanyInfoTap,
          onCompanyTagGroupTap: _handleCompanyTagGroupTap,
        );
      case ProfileSections.venues:
        return VenuesSection(
          onVenuesChanged: (hasVenues) {
            setState(() {
              _hasVenues = hasVenues;
            });
          },
        );
      case ProfileSections.reviews:
        return const ReviewsSection();
    }
  }

  /// Determines if the FAB should be shown
  bool _shouldShowFAB() {
    return _selectedSection == ProfileSections.venues && _hasVenues;
  }

  /// Opens the join venue modal
  Future<void> _openJoinVenueModal() async {
    try {
      await showPlatformModalSheet<bool>(
        context: context,
        material: MaterialModalSheetData(
          isScrollControlled: true,
          useSafeArea: true,
        ),
        builder: (context) => const JoinVenueView(),
      );
      
      // If successful, the VenuesSection will handle its own refresh
      // and notify us through onVenuesChanged callback
    } catch (error) {
      AppLogger.error('Error opening join venue view: $error', context: 'ProfileView');
    }
  }
  
  
  




  /// Refreshes profile data
  Future<void> _refreshProfile({bool forceRefresh = false}) async {
    final authService = context.authService;
    if (!authService.isAuthenticated) return;
    
    setState(() {
      _isProfileLoading = true;
    });
    
    try {
      // Refresh profile data from server when forced or when needed  
      final profileService = context.profileService;
      if (forceRefresh || profileService.currentProfile == null) {
        final refreshedProfile = await _profileManager.fetchUserProfile();
        ProfileService.shared.updateCurrentProfile(refreshedProfile);
      }
      
      setState(() {
        _isProfileLoading = false;
      });
      
    } catch (error) {
      AppLogger.error('Error refreshing profile data', error: error, context: 'ProfileView');
      setState(() {
        _isProfileLoading = false;
      });
    }
  }
  
  /// Loads personal tag groups
  void _loadPersonalTagGroups() async {
    setState(() => _personalTagGroupsLoading = true);
    
    await executeSilently(
      operation: () async {
        final tagGroups = await _contentManager.fetchTagGroups(CategoryType.personal);
        AppLogger.success('Loaded ${tagGroups.length} personal tag groups', context: 'ProfileView');
        safeSetState(() {
          _personalTagGroups = tagGroups;
          _personalTagGroupsLoading = false;
        });
      },
      onError: (error) {
        AppLogger.error('Error loading personal tag groups', error: error, context: 'ProfileView');
        safeSetState(() {
          _personalTagGroups = [];
          _personalTagGroupsLoading = false;
        });
      },
    );
  }
  
  /// Loads company tag groups
  void _loadCompanyTagGroups() async {
    setState(() => _companyTagGroupsLoading = true);
    
    await executeSilently(
      operation: () async {
        final tagGroups = await _contentManager.fetchTagGroups(CategoryType.company);
        AppLogger.success('Loaded ${tagGroups.length} company tag groups', context: 'ProfileView');
        safeSetState(() {
          _companyTagGroups = tagGroups;
          _companyTagGroupsLoading = false;
        });
      },
      onError: (error) {
        AppLogger.error('Error loading company tag groups', error: error, context: 'ProfileView');
        safeSetState(() {
          _companyTagGroups = [];
          _companyTagGroupsLoading = false;
        });
      },
    );
  }
  
  /// Handles personal info option tap
  void _handlePersonalInfoTap(EditPersonalInfoType type) async {
    AppLogger.ui('Tapped on personal info type: ${type.title}', context: 'ProfileView');
    
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
    AppLogger.ui('Tapped on company info type: ${type.title}', context: 'ProfileView');
    
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
    AppLogger.ui('Tapped on personal tag group: ${tagGroup.title}', context: 'ProfileView');
    
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
    AppLogger.ui('Tapped on company tag group: ${tagGroup.title}', context: 'ProfileView');
    
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