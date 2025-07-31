import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../models/match.dart';
import '../../services/supabase_manager.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/common/card_item.dart';
import '../../widgets/common/match_item_view.dart';
import '../../widgets/common/tag_view.dart';
import '../../widgets/matches/match_overview_header.dart';
import '../../widgets/matches/match_reasons_view.dart';
import '../../widgets/buttons/action_button.dart';
import '../../services/session_manager.dart';
import '../../models/enums/action_button_type.dart';
import '../../models/enums/match_response.dart';
import '../../models/enums/match_status.dart';
import '../../models/requests/match_response_request.dart';

/// MatchDetailView - Detailed view of a match showing profile, prompts, connections, and tags
/// 
/// This view displays comprehensive information about a match including:
/// - Profile header with avatar, bio, and sectors
/// - Matching prompts/cards
/// - Shared connections (for connected matches)
/// - Shared tag groups
/// 
/// Based on iOS MatchDetailView structure with theme-aware styling.
class MatchDetailView extends StatefulWidget {
  final String matchId;

  const MatchDetailView({
    super.key,
    required this.matchId,
  });

  @override
  State<MatchDetailView> createState() => _MatchDetailViewState();
}

class _MatchDetailViewState extends State<MatchDetailView> {
  // Services
  late final SupabaseManager _supabaseManager;
  late final SessionManager _sessionManager;
  
  // State
  Match? _match;
  bool _isLoading = true;
  bool _isProcessingResponse = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _supabaseManager = SupabaseManager.shared;
    _sessionManager = SessionManager.shared;
    _loadMatchDetail();
  }

  Future<void> _loadMatchDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final match = await _supabaseManager.fetchMatchDetail(widget.matchId);
      setState(() {
        _match = match;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Error loading match detail: $error');
      setState(() {
        _error = 'Failed to load match details';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(_match?.profile.fullName ?? 'Loading ...'),
        trailingActions: [
          if (_match != null && _match!.isConnected)
            PlatformIconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_horiz, color: venyuTheme.primaryText),
              onPressed: () {
                // TODO: Show action sheet with options
                debugPrint('Show match options');
              },
            ),
        ],
      ),
      usePadding: true,
      useSafeArea: true,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadMatchDetail,
              child: _buildContent(),
            ),
          ),
          // Fixed bottom action buttons for non-connected matches
          if (_match != null && !_match!.isConnected && _match!.response == null)
            _buildMatchInterestView(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: AppTextStyles.body.copyWith(
                color: context.venyuTheme.secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            PlatformTextButton(
              onPressed: _loadMatchDetail,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_match == null) {
      return const Center(
        child: Text('Match not found'),
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 8.0),
      children: [
            // Profile Header
            ProfileHeader(
              profile: _match!.profile,
              avatarSize: 80.0,
              isEditable: false,
              isConnection: _match!.isConnected,
              onAvatarTap: _match!.isConnected && _match!.profile.avatarID != null
                  ? () {
                      // TODO: Show full screen avatar
                      debugPrint('Show full screen avatar');
                    }
                  : null,
              onLinkedInTap: _match!.isConnected && _match!.profile.linkedInURL != null
                  ? () => _openLinkedIn()
                  : null,
              onEmailTap: _match!.isConnected && _match!.profile.contactEmail != null
                  ? () => _composeEmail()
                  : null,
              onWebsiteTap: _match!.isConnected && _match!.profile.websiteURL != null
                  ? () => _openWebsite()
                  : null,
            ),
            
            const SizedBox(height: 24),
            
            // Matching Cards Section
            if (_match!.nrOfPrompts > 0) ...[
              _buildSectionHeader(
                iconName: 'card',
                title: '${_match!.nrOfPrompts} matching ${_match!.nrOfPrompts == 1 ? "card" : "cards"}',
              ),
              const SizedBox(height: 16),
              _buildPromptsSection(),
              const SizedBox(height: 24),
            ],
            
            // Shared Connections Section 
            if (_match!.nrOfConnections > 0) ...[
              _buildSectionHeader(
                iconName: 'handshake',
                title: '${_match!.nrOfConnections} shared ${_match!.nrOfConnections == 1 ? "connection" : "connections"}',
              ),
              const SizedBox(height: 16),
              _buildConnectionsSection(),
              const SizedBox(height: 24),
            ],
            
            // Company matches section
            if (_match!.nrOfCompanyTags > 0) ...[
              _buildSectionHeader(
                iconName: 'company',
                title: '${_match!.nrOfCompanyTags} company ${_match!.nrOfCompanyTags == 1 ? "match" : "matches"}',
              ),
              const SizedBox(height: 16),
              _buildCompanyMatchesSection(),
              const SizedBox(height: 24),
            ],
            
            // Personal matches section  
            if (_match!.nrOfPersonalTags > 0) ...[
              _buildSectionHeader(
                iconName: 'match',
                title: '${_match!.nrOfPersonalTags} personal ${_match!.nrOfPersonalTags == 1 ? "match" : "matches"}',
              ),
              const SizedBox(height: 16),
              _buildPersonalMatchesSection(),
              const SizedBox(height: 24),
            ],
            
            // Match reasons section (only for matched status)
            if (_match!.status == MatchStatus.matched && 
                _match!.reason != null && 
                _match!.reason!.isNotEmpty) ...[
              MatchReasonsView(match: _match!)

            ],
            
      ],
    );
  }

  Widget _buildSectionHeader({required String iconName, required String title}) {
    final venyuTheme = context.venyuTheme;
    
    return Row(
      children: [
        context.themedIcon(iconName, selected: true),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.subheadline.copyWith(
            fontWeight: FontWeight.w600,
            color: venyuTheme.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildPromptsSection() {
    if (_match!.prompts == null || _match!.prompts!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: AppLayoutStyles.cardDecoration(context),
        child: Text(
          'No matching cards',
          style: AppTextStyles.body.copyWith(
            color: context.venyuTheme.secondaryText,
          ),
        ),
      );
    }

    final currentProfile = _sessionManager.currentProfile;
    if (currentProfile == null) {
      return const Center(
        child: Text('Profile not available'),
      );
    }

    return Column(
      children: [
        // Match Overview Header
        MatchOverviewHeader(
          match: _match!,
          currentProfile: currentProfile,
        ),
        
        // Prompt Cards - no spacing between cards in shared view
        ..._match!.prompts!.asMap().entries.map((entry) {
          final index = entry.key;
          final prompt = entry.value;
          final isFirst = index == 0;
          final isLast = index == _match!.prompts!.length - 1;
          
          return CardItem(
            prompt: prompt,
            isSharedPromptView: true,
            showMatchInteraction: true,
            isFirst: isFirst,
            isLast: isLast,
            onCardSelected: (selectedPrompt) {
              // TODO: Handle card detail view
              debugPrint('Card selected: ${selectedPrompt.label}');
            },
          );
        }),
      ],
    );
  }

  Widget _buildConnectionsSection() {
    debugPrint('DEBUG: connections = ${_match!.connections}');
    debugPrint('DEBUG: nrOfConnections = ${_match!.nrOfConnections}');
    
    if (_match!.connections == null || _match!.connections!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: AppLayoutStyles.cardDecoration(context),
        child: Text(
          'No shared connections',
          style: AppTextStyles.body.copyWith(
            color: context.venyuTheme.secondaryText,
          ),
        ),
      );
    }

    return Column(
      children: _match!.connections!.asMap().entries.map((entry) {
        final index = entry.key;
        final connection = entry.value;
        final isLast = index == _match!.connections!.length - 1;
        
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
          child: MatchItemView(
            match: connection,
            onMatchSelected: (selectedMatch) {
              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (context) => MatchDetailView(
                    matchId: selectedMatch.id,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCompanyMatchesSection() {
    return _buildTagsSection(_match!.companyTagGroups);
  }

  Widget _buildPersonalMatchesSection() {
    return _buildTagsSection(_match!.personalTagGroups);
  }

  Widget _buildTagsSection(List<dynamic> tagGroups) {
    if (tagGroups.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: AppLayoutStyles.cardDecoration(context),
        child: Text(
          'No shared tags',
          style: AppTextStyles.body.copyWith(
            color: context.venyuTheme.secondaryText,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppLayoutStyles.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tagGroups.asMap().entries.map((entry) {
          final index = entry.key;
          final tagGroup = entry.value;
          final isLast = index == tagGroups.length - 1;
          
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TagGroup label
                Text(
                  tagGroup.label ?? 'Unknown',
                  style: AppTextStyles.subheadline.copyWith(
                    color: context.venyuTheme.secondaryText,
                  ),
                ),
                const SizedBox(height: 8),
                // Tags
                if (tagGroup.tags != null && tagGroup.tags!.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (tagGroup.tags! as List).map((tag) {
                      return TagView(
                        id: tag.id,
                        label: tag.label,
                        icon: tag.icon,
                        emoji: tag.emoji,
                        fontSize: AppTextStyles.subheadline,
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Build the match interest view with action buttons (MatchInterestView equivalent)
  Widget _buildMatchInterestView() {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: SafeArea(
        child: Row(
          children: [
            // Skip button
            Expanded(
              child: ActionButton(
                label: _isProcessingResponse ? 'Processing...' : 'Skip',
                onPressed: _isProcessingResponse ? null : _showSkipAlert,
                style: ActionButtonType.secondary,
                isDisabled: _isProcessingResponse,
              ),
            ),
            const SizedBox(width: 16),
            // Connect button  
            Expanded(
              child: ActionButton(
                label: _isProcessingResponse ? 'Processing...' : 'Interested',
                onPressed: _isProcessingResponse ? null : _handleConnectMatch,
                style: ActionButtonType.primary,
                isDisabled: _isProcessingResponse,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show skip match confirmation alert
  void _showSkipAlert() {
    if (_match == null) return;
    
    showDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: const Text('Skip this match?'),
        content: Text(
          'This match will be removed permanently and you won\'t see it again. ${_match!.profile.firstName} won\'t get notified.',
        ),
        actions: [
          
          PlatformDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              _handleSkipMatch();
            },
            child: const Text('Skip'),
            cupertino: (_, __) => CupertinoDialogActionData(
              isDestructiveAction: true,
            ),
          ),
          PlatformDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
            cupertino: (_, __) => CupertinoDialogActionData(
              isDefaultAction: true,
            ),
          ),
        ],
      ),
    );
  }

  /// Handle skip match action
  Future<void> _handleSkipMatch() async {
    if (_match == null) return;
    
    setState(() {
      _isProcessingResponse = true;
    });

    try {
      final request = MatchResponseRequest(
        matchId: _match!.id,
        response: MatchResponse.notInterested,
      );
      
      await _supabaseManager.insertMatchResponse(request);
      
      if (mounted) {
        // Show success feedback first
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Match skipped'),
            duration: Duration(seconds: 2),
          ),
        );
        
        // Then navigate back to matches list
        Navigator.of(context).pop();
      }
    } catch (error) {
      debugPrint('Error skipping match: $error');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to skip match: $error'),
            backgroundColor: context.venyuTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingResponse = false;
        });
      }
    }
  }

  /// Handle connect match action
  Future<void> _handleConnectMatch() async {
    if (_match == null) return;
    
    setState(() {
      _isProcessingResponse = true;
    });

    try {
      final request = MatchResponseRequest(
        matchId: _match!.id,
        response: MatchResponse.interested,
      );
      
      await _supabaseManager.insertMatchResponse(request);
      
      if (mounted) {
        // Show success feedback first
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection request sent!'),
            duration: Duration(seconds: 2),
          ),
        );
        
        // Then navigate back to matches list
        Navigator.of(context).pop();
      }
    } catch (error) {
      debugPrint('Error connecting with match: $error');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect: $error'),
            backgroundColor: context.venyuTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingResponse = false;
        });
      }
    }
  }

  Future<void> _openLinkedIn() async {
    if (_match?.profile.linkedInURL == null) return;
    
    final uri = Uri.parse(_match!.profile.linkedInURL!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open LinkedIn profile')),
        );
      }
    }
  }

  Future<void> _composeEmail() async {
    if (_match?.profile.contactEmail == null) return;
    
    final emailUri = Uri(
      scheme: 'mailto',
      path: _match!.profile.contactEmail!,
      queryParameters: {
        'subject': 'We are connected on Venyu!',
      },
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app')),
        );
      }
    }
  }

  Future<void> _openWebsite() async {
    if (_match?.profile.websiteURL == null) return;
    
    final uri = Uri.parse(_match!.profile.websiteURL!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open website')),
        );
      }
    }
  }
}