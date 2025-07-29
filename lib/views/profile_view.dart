import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../core/theme/app_text_styles.dart';
import '../core/theme/venyu_theme.dart';
import '../models/enums/profile_sections.dart';
import '../models/prompt.dart';
import '../services/session_manager.dart';
import '../services/supabase_manager.dart';
import '../widgets/buttons/section_button.dart';
import '../widgets/cards/card_item.dart';
import '../widgets/common/tag_view.dart';
import '../widgets/scaffolds/app_scaffold.dart';
import 'profile_edit_view.dart';
import 'profile/edit_bio_view.dart';

/// ProfileView - Current user's profile page with sections and content
/// 
/// This is the main profile view that shows the current user's profile
/// information, including avatar, bio, tags, and sectioned content like
/// cards and venues. Based on iOS ProfileView structure.
/// 
/// Features:
/// - Profile header with avatar and bio (edit button included)
/// - Section buttons (Cards, Venues, Reviews)
/// - Dynamic content based on selected section
/// - Pull-to-refresh functionality
/// - Settings navigation
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // Services
  late final SupabaseManager _supabaseManager;
  late final SessionManager _sessionManager;
  
  // State
  ProfileSections _selectedSection = ProfileSections.cards;
  List<Prompt>? _cards;
  bool _isProfileLoading = true;
  bool _isCardsLoading = false;
  bool _initialSectionLoaded = false;

  @override
  void initState() {
    super.initState();
    _supabaseManager = SupabaseManager.shared;
    _sessionManager = SessionManager.shared;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = _sessionManager.currentProfile;
    
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(profile?.fullName ?? 'Profile'),
        trailingActions: [
          PlatformIconButton(
            padding: EdgeInsets.zero,
            icon: context.themedIcon('settings'),
            onPressed: () {
              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (context) => const ProfileEditView(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(forceRefresh: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              
              // Profile Header
              if (!_isProfileLoading && profile != null)
                _buildProfileHeader(profile)
              else
                _buildLoadingProfileHeader(),
              
              const SizedBox(height: 16),
              
              // Section Buttons
              _buildSectionButtons(),
              
              const SizedBox(height: 16),
              
              // Section Content
              _buildSectionContent(),
              
              const SizedBox(height: 100), // Extra space for content
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the profile header with avatar, role, sectors, and bio
  Widget _buildProfileHeader(profile) {
    final venyuTheme = context.venyuTheme;
    
    return Container(      
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: venyuTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: venyuTheme.borderColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar and Role row
          Row(
            children: [
              // Avatar with edit button overlay
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: venyuTheme.selectionColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: venyuTheme.borderColor,
                        width: 1,
                      ),
                    ),
                    child: profile.avatarID != null 
                        ? ClipOval(
                            child: Image.network(
                              'https://example.com/avatar/${profile.avatarID}', // TODO: Implement actual avatar URL
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
                            ),
                          )
                        : _buildDefaultAvatar(),
                  ),
                  // Edit icon overlay
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: venyuTheme.cardBackground,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: venyuTheme.borderColor,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: context.themedIcon('edit', size: 14),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(width: 16),
              
              // Role and sectors
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Role (computed property from profile)
                    Text(
                      profile.role.isNotEmpty 
                          ? profile.role
                          : 'Add company info',
                      style: AppTextStyles.subheadline.copyWith(
                        color: venyuTheme.primaryText,
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Sectors/Tags
                    _buildSectorsView(profile),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Bio section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  profile.bio?.isNotEmpty == true 
                      ? profile.bio! 
                      : 'Write something about yourself...',
                  style: AppTextStyles.subheadline.copyWith(
                    color: profile.bio?.isNotEmpty == true 
                        ? venyuTheme.primaryText 
                        : venyuTheme.secondaryText,
                    fontStyle: profile.bio?.isNotEmpty == true 
                        ? FontStyle.normal 
                        : FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    platformPageRoute(
                      context: context,
                      builder: (context) => const EditBioView(),
                    ),
                  );
                  
                  // Refresh profile if bio was updated
                  if (result == true) {
                    setState(() {
                      // Trigger rebuild to show updated bio
                    });
                  }
                },
                child: context.themedIcon('edit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a loading placeholder for the profile header
  Widget _buildLoadingProfileHeader() {
    final venyuTheme = context.venyuTheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: venyuTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: venyuTheme.borderColor,
          width: 0.5,
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

  /// Builds default avatar icon
  Widget _buildDefaultAvatar() {
    final venyuTheme = context.venyuTheme;
    return Icon(
      Icons.person_outline,
      size: 40,
      color: venyuTheme.secondaryText,
    );
  }


  /// Builds the sectors view with tag layout (Swift equivalent)
  Widget _buildSectorsView(profile) {
    final venyuTheme = context.venyuTheme;
    
    // Check if profile has sectors
    if (profile.sectors != null && profile.sectors.length > 0) {
      // Sort sectors by title like in Swift
      final sortedSectors = List.from(profile.sectors);
      sortedSectors.sort((a, b) => a.title.compareTo(b.title));
      
      return Wrap(
        spacing: 4,
        runSpacing: 4,
        children: sortedSectors.map<Widget>((sector) {
          return TagView(
            id: sector.id,
            label: sector.title,
            icon: sector.icon,
          );
        }).toList(),
      );
    } else {
      // No sectors - show placeholder like iOS
      return GestureDetector(
        onTap: () {
          // TODO: Navigate to sectors edit
          debugPrint('Navigate to sectors edit');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: venyuTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Add sectors',
            style: AppTextStyles.caption1.copyWith(
              color: venyuTheme.primary,
            ),
          ),
        ),
      );
    }
  }

  /// Builds the section buttons (Cards, Venues, Reviews)
  Widget _buildSectionButtons() {
    final visibleSections = ProfileSections.values
        .where((section) => section != ProfileSections.reviews || _sessionManager.currentProfile?.isSuperAdmin == true)
        .toList();
    
    return SectionButtonBar<ProfileSections>(
      sections: visibleSections,
      selectedSection: _selectedSection,
      onSectionSelected: (section) {
        setState(() {
          _selectedSection = section;
        });
        _refreshData();
      },
    );
  }

  /// Builds content based on selected section
  Widget _buildSectionContent() {
    switch (_selectedSection) {
      case ProfileSections.cards:
        return _buildCardsContent();
      case ProfileSections.venues:
        return _buildVenuesContent();
      case ProfileSections.reviews:
        return _buildReviewsContent();
    }
  }

  /// Builds the cards section content
  Widget _buildCardsContent() {
    if (_isCardsLoading) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_cards == null || _cards!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.credit_card_outlined,
                size: 64,
                color: context.venyuTheme.secondaryText,
              ),
              const SizedBox(height: 16),
              Text(
                'No cards',
                style: AppTextStyles.headline.copyWith(
                  color: context.venyuTheme.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "You don't have any cards yet.",
                style: AppTextStyles.body.copyWith(
                  color: context.venyuTheme.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: _cards!.map((prompt) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CardItem(
              prompt: prompt,
              onCardSelected: (selectedPrompt) {
                // TODO: Handle card selection (navigate to detail view)
                debugPrint('Card selected: ${selectedPrompt.label}');
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Builds the venues section content
  Widget _buildVenuesContent() {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: Center(
        child: Text('Venues - Coming soon'),
      ),
    );
  }

  /// Builds the reviews section content
  Widget _buildReviewsContent() {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: Center(
        child: Text('Reviews - Coming soon'),
      ),
    );
  }

  /// Refreshes profile and section data
  Future<void> _refreshData({bool forceRefresh = false}) async {
    if (!_sessionManager.isAuthenticated) return;
    
    setState(() {
      if (!_initialSectionLoaded) {
        _isProfileLoading = true;
      }
    });
    
    try {
      // Refresh profile if needed - SessionManager handles this internally
      // Profile is automatically updated when _sessionManager.currentProfile is accessed
      
      // Refresh section-specific data
      if (_selectedSection == ProfileSections.cards) {
        setState(() {
          _isCardsLoading = true;
        });
        
        if (_cards == null || forceRefresh) {
          _cards = await _supabaseManager.fetchCards();
        }
        
        setState(() {
          _isCardsLoading = false;
        });
      }
      
      setState(() {
        _isProfileLoading = false;
        _initialSectionLoaded = true;
      });
      
    } catch (error) {
      debugPrint('Error refreshing profile data: $error');
      setState(() {
        _isProfileLoading = false;
        _isCardsLoading = false;
      });
    }
  }
}