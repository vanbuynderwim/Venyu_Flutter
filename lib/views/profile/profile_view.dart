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
import '../../models/invite.dart';
import '../../models/badge_data.dart';
import '../../models/prompt.dart';
import '../../core/providers/app_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../services/profile_service.dart';
import '../../services/notification_service.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/buttons/fab_button.dart';
import '../../widgets/buttons/action_button.dart';
import '../../models/enums/action_button_type.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/common/warning_box_widget.dart';
import '../../mixins/data_refresh_mixin.dart';
import '../venues/join_venue_view.dart';
import 'profile_header.dart';
import 'profile_view/profile_section_button_bar.dart';
import 'profile_view/personal_info_section.dart';
import 'profile_view/company_info_section.dart';
import 'profile_view/venues_section.dart';
import 'profile_view/invites_section.dart';
import 'profile_view/reviews_section.dart';
import 'edit_tag_group_view.dart';
import 'edit_account_view.dart';
import '../prompts/prompt_entry_view.dart';

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
  List<Invite>? _inviteCodes;
  bool _inviteCodesLoading = false;
  BadgeData? _badgeData;
  List<Prompt>? _availablePrompts; // Available daily prompts to answer
  bool _isCheckingPrompts = false;

  @override
  void initState() {
    super.initState();
    _contentManager = ContentManager.shared;
    _profileManager = ProfileManager.shared;
    _notificationService = NotificationService.shared;

    // Set up available prompts update callback
    _contentManager.addAvailablePromptsCallback(_onAvailablePromptsUpdate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProfile();
      // Load personal tag groups since it's the default selected section
      _loadPersonalTagGroups();
      // Load badge data
      _fetchBadges();
      // Check for available daily prompts
      _checkForPrompts();
    });
  }

  @override
  void dispose() {
    _contentManager.removeAvailablePromptsCallback(_onAvailablePromptsUpdate);
    super.dispose();
  }

  /// Callback for available prompts updates
  void _onAvailablePromptsUpdate(List<Prompt> prompts) {
    if (mounted) {
      setState(() {
        _availablePrompts = prompts;
      });
    }
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
            icon: context.themedIcon('hamburger'),
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
              label: l10n.profileViewFabJoinVenue,
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
                padding: const EdgeInsets.only(bottom: 16.0),
                children: [
                
                // Profile Header
                if (!_isProfileLoading && profile != null)
                  _buildProfileHeader(profile)
                else
                  const LoadingStateWidget(),
                
                const SizedBox(height: 16),

                // Daily Prompts Action Button (if prompts available)
                if (_availablePrompts != null && _availablePrompts!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: ActionButton(
                      label: l10n.promptsViewAnswerPromptsButton,
                      onPressed: _showPromptsModal,
                      type: ActionButtonType.secondary,
                      icon: context.themedIcon('prompts'),
                      badgeCount: _availablePrompts!.length,
                    ),
                  ),
                
                // Section Button Bar
                if (!_isProfileLoading && profile != null)
                  ProfileSectionButtonBar(
                    profile: profile,
                    selectedSection: _selectedSection,
                    badgeData: _badgeData,
                    onSectionSelected: (section) {
                      setState(() {
                        _selectedSection = section;
                      });
                      // Load data when section is selected
                      if (section == ProfileSections.personal && _personalTagGroups == null) {
                        _loadPersonalTagGroups();
                      } else if (section == ProfileSections.company && _companyTagGroups == null) {
                        _loadCompanyTagGroups();
                      } else if (section == ProfileSections.invites) {
                        // Always reload invite codes when switching to invites section
                        _loadInviteCodes(forceRefresh: true);
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
      default:
        // No completeness warning for other sections
        return const SizedBox.shrink();
    }

    // Only show warning if completeness is not 100%
    if (message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
      case ProfileSections.invites:
        return InvitesSection(
          inviteCodes: _inviteCodes,
          inviteCodesLoading: _inviteCodesLoading,
          onInviteMarkedAsSent: _markInviteAsSentLocally,
          onRefreshRequested: () {
            _loadInviteCodes(forceRefresh: true);
            _fetchBadges(); // Refresh badges when invite codes are refreshed
          },
        );
      case ProfileSections.reviews:
        return ReviewsSection(badgeData: _badgeData);
    }
  }

  /// Determines if the FAB should be shown
  bool _shouldShowFAB() {
    return AppConfig.showVenues && _selectedSection == ProfileSections.venues && _hasVenues;
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
        _inviteCodes = null;

        // Reload current section data
        switch (_selectedSection) {
          case ProfileSections.personal:
            _loadPersonalTagGroups();
            break;
          case ProfileSections.company:
            _loadCompanyTagGroups();
            break;
          case ProfileSections.invites:
            _loadInviteCodes(forceRefresh: true);
            break;
          case ProfileSections.venues:
            // VenuesSection manages its own refresh
            break;
          case ProfileSections.reviews:
            // ReviewsSection doesn't need refresh yet
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

  /// Mark invite code as sent locally (instant UI update)
  void _markInviteAsSentLocally(String codeId) {
    if (_inviteCodes == null) return;

    safeSetState(() {
      _inviteCodes = _inviteCodes!.map((invite) {
        if (invite.id == codeId) {
          // Create a new invite marked as sent
          return invite.copyWith(isSent: true);
        }
        return invite;
      }).toList();
    });

    AppLogger.info('Invite code marked as sent locally: $codeId', context: 'ProfileView');

    // Refresh badge data after marking invite as sent
    _fetchBadges();
  }

  /// Loads invite codes
  void _loadInviteCodes({bool forceRefresh = false}) async {
    // Always reload if forceRefresh is true, or if we don't have data yet
    if (!forceRefresh && _inviteCodes != null) return;

    if (!mounted) return;
    setState(() => _inviteCodesLoading = true);

    await executeSilently(
      operation: () async {
        final inviteCodes = await _profileManager.getMyInviteCodes();
        AppLogger.success('Loaded ${inviteCodes.length} invite codes', context: 'ProfileView');
        safeSetState(() {
          _inviteCodes = inviteCodes;
          _inviteCodesLoading = false;
        });
      },
      onError: (error) {
        AppLogger.error('Error loading invite codes', error: error, context: 'ProfileView');
        safeSetState(() {
          _inviteCodes = [];
          _inviteCodesLoading = false;
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

  /// Check for available daily prompts
  /// The callback will automatically update _availablePrompts state
  Future<void> _checkForPrompts() async {
    if (_isCheckingPrompts) return;

    _isCheckingPrompts = true;

    try {
      final authService = context.authService;
      if (!authService.isAuthenticated) return;

      AppLogger.debug('Checking for available daily prompts', context: 'ProfileView');
      await _contentManager.fetchPrompts(); // Callback will update state
    } catch (error) {
      AppLogger.error('Error fetching available prompts', error: error, context: 'ProfileView');
    } finally {
      _isCheckingPrompts = false;
    }
  }

  /// Show the PromptEntryView as a fullscreen modal
  Future<void> _showPromptsModal() async {
    if (_availablePrompts == null || _availablePrompts!.isEmpty) return;

    void closeModalCallback() {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    await showPlatformModalSheet<bool>(
      context: context,
      material: MaterialModalSheetData(
        useRootNavigator: false,
        isScrollControlled: true,
        useSafeArea: true,
        isDismissible: true,
      ),
      cupertino: CupertinoModalSheetData(
        useRootNavigator: false,
        barrierDismissible: true,
      ),
      builder: (sheetCtx) => PromptEntryView(
        prompts: _availablePrompts!,
        isModal: true,
        onCloseModal: closeModalCallback,
      ),
    );

    // The available prompts will be updated via callback when PromptEntryView notifies
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