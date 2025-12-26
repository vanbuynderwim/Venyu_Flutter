import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../models/enums/profile_sections.dart';
import '../../models/enums/category_type.dart';
import '../../models/profile.dart';
import '../../models/tag_group.dart';
import '../../models/badge_data.dart';
import '../../core/providers/app_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../services/profile_service.dart';
import '../../services/notification_service.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/buttons/fab_button.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/common/warning_box_widget.dart';
import '../../mixins/data_refresh_mixin.dart';
import '../venues/join_venue_view.dart';
import 'profile_header.dart';
import 'profile_view/profile_section_button_bar.dart';
import 'profile_view/personal_info_section.dart';
import 'profile_view/company_info_section.dart';
import 'profile_view/venues_section.dart';
import 'edit_tag_group_view.dart';
import 'edit_account_view.dart';

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
  late final NotificationService _notificationService;

  // State
  bool _isProfileLoading = true;
  ProfileSections _selectedSection = ProfileSections.personal;
  List<TagGroup>? _personalTagGroups;
  List<TagGroup>? _companyTagGroups;
  bool _personalTagGroupsLoading = false;
  bool _companyTagGroupsLoading = false;
  bool _hasVenues = false;
  BadgeData? _badgeData;

  @override
  void initState() {
    super.initState();
    _contentManager = ContentManager.shared;
    _profileManager = ProfileManager.shared;
    _notificationService = NotificationService.shared;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProfile();
      // Load personal tag groups since it's the default selected section
      _loadPersonalTagGroups();
      // Load badge data
      _fetchBadges();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileService = context.watchProfileService;
    final profile = profileService.currentProfile;

    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(l10n.profileViewTitle),
        trailingActions: [
          PlatformIconButton(
            padding: EdgeInsets.zero,
            icon: _badgeData != null && _badgeData!.invitesCount > 0
                ? Badge.count(
                    count: _badgeData!.invitesCount,
                    child: context.themedIcon('hamburger'),
                  )
                : context.themedIcon('hamburger'),
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
      floatingActionButton: _buildFloatingActionButton(),
      useSafeArea: true,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _refreshProfile(forceRefresh: true),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 16.0),
                children: [
                
                // Profile Header
                if (!_isProfileLoading && profile != null)
                  _buildProfileHeader(profile)
                else
                  const LoadingStateWidget(),
                
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
                      // Load data when section is selected
                      if (section == ProfileSections.personal && _personalTagGroups == null) {
                        _loadPersonalTagGroups();
                      } else if (section == ProfileSections.company && _companyTagGroups == null) {
                        _loadCompanyTagGroups();
                      }
                    },
                  ),

                const SizedBox(height: 8),

                // Completeness Warning
                if (!_isProfileLoading && profile != null)
                  _buildCompletenessWarning(profile),                

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
  Widget _buildProfileHeader(dynamic profile) {
    return ProfileHeader(
      profile: profile,
      isEditable: true,
      // No need for onBioEdited callback - ProfileView automatically updates
      // when SessionManager.currentProfile changes via listener
    );
  }

  /// Builds the completeness warning if profile is not 100% complete
  Widget _buildCompletenessWarning(Profile profile) {
    final l10n = AppLocalizations.of(context)!;

    // Determine which completeness to show based on selected section
    int? completeness;
    String message = '';

    switch (_selectedSection) {
      case ProfileSections.personal:
        completeness = profile.personalCompleteness;
        if (completeness != null && completeness < 100) {
          message = l10n.profilePersonalCompletenessMessage(completeness);
        }
        break;
      case ProfileSections.company:
        completeness = profile.companyCompleteness;
        if (completeness != null && completeness < 100) {
          message = l10n.profileCompanyCompletenessMessage(completeness);
        }
        break;
      case ProfileSections.venues:
        // No completeness warning for venues section
        return const SizedBox.shrink();
    }

    // Only show warning if completeness is not 100%
    if (message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 8),
          child: WarningBoxWidget(text: message),
        ),
      ],
    );
  }

  /// Builds the content for the selected section
  Widget _buildSectionContent() {
    switch (_selectedSection) {
      case ProfileSections.personal:
        return PersonalInfoSection(
          personalTagGroups: _personalTagGroups,
          personalTagGroupsLoading: _personalTagGroupsLoading,
          onTagGroupTap: _handleTagGroupTap,
        );
      case ProfileSections.company:
        return CompanyInfoSection(
          companyTagGroups: _companyTagGroups,
          companyTagGroupsLoading: _companyTagGroupsLoading,
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
    }
  }

  /// Builds the floating action button based on selected section
  Widget? _buildFloatingActionButton() {
    // Show FAB for Venues section
    if (AppConfig.showVenues && _selectedSection == ProfileSections.venues && _hasVenues) {
      return FABButton(
        icon: context.themedIcon('plus'),
        label: AppLocalizations.of(context)!.profileViewFabJoinVenue,
        onPressed: _openJoinVenueModal,
      );
    }

    return null;
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

    if (!mounted) return;

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

      // Force refresh section data if this is a forced refresh (pull-to-refresh)
      if (forceRefresh) {
        // Reset cached data to force reload
        _personalTagGroups = null;
        _companyTagGroups = null;

        // Reload current section data
        switch (_selectedSection) {
          case ProfileSections.personal:
            _loadPersonalTagGroups();
            break;
          case ProfileSections.company:
            _loadCompanyTagGroups();
            break;
          case ProfileSections.venues:
            // VenuesSection manages its own refresh
            break;
        }

        // Refresh badge data
        _fetchBadges();
      }

      if (mounted) {
        setState(() {
          _isProfileLoading = false;
        });
      }

    } catch (error) {
      AppLogger.error('Error refreshing profile data', error: error, context: 'ProfileView');
      if (mounted) {
        setState(() {
          _isProfileLoading = false;
        });
      }
    }
  }

  /// Loads personal tag groups
  void _loadPersonalTagGroups() async {
    if (!mounted) return;
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
    if (!mounted) return;
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

  /// Fetch badge counts for section buttons
  Future<void> _fetchBadges() async {
    try {
      final badges = await _notificationService.fetchBadges();
      if (badges != null && mounted) {
        setState(() {
          _badgeData = badges;
        });
      }
    } catch (error) {
      AppLogger.error('Failed to fetch badges in ProfileView', error: error, context: 'ProfileView');
    }
  }

  /// Handles personal info option tap
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
      // Refresh profile to update completeness percentage (calculated server-side)
      _refreshProfileCompleteness();
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
      // Refresh profile to update completeness percentage (calculated server-side)
      _refreshProfileCompleteness();
    }
  }

  /// Refreshes only the profile data to update completeness percentages
  /// This is a lightweight refresh that doesn't reset all cached data
  Future<void> _refreshProfileCompleteness() async {
    try {
      final refreshedProfile = await _profileManager.fetchUserProfile();
      ProfileService.shared.updateCurrentProfile(refreshedProfile);
    } catch (error) {
      AppLogger.error('Error refreshing profile completeness', error: error, context: 'ProfileView');
    }
  }
}