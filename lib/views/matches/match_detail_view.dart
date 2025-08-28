import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../models/match.dart';
import '../../models/enums/match_status.dart';
import '../../services/supabase_managers/matching_manager.dart';
import '../../services/session_manager.dart';
import '../../services/toast_service.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/avatar_fullscreen_viewer.dart';
import '../profile/profile_header.dart';
import 'match_reasons_view.dart';
import 'match_detail/match_actions_section.dart';
import 'match_detail/match_connections_section.dart';
import 'match_detail/match_prompts_section.dart';
import 'match_detail/match_section_header.dart';
import 'match_detail/match_tags_section.dart';

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
  final VoidCallback? onMatchRemoved;

  const MatchDetailView({
    super.key,
    required this.matchId,
    this.onMatchRemoved,
  });

  @override
  State<MatchDetailView> createState() => _MatchDetailViewState();
}

class _MatchDetailViewState extends State<MatchDetailView> with ErrorHandlingMixin {
  // Services
  late final MatchingManager _matchingManager;
  late final SessionManager _sessionManager;
  
  // State
  Match? _match;
  String? _error;

  @override
  void initState() {
    super.initState();
    _matchingManager = MatchingManager.shared;
    _sessionManager = SessionManager.shared;
    _loadMatchDetail();
  }

  Future<void> _loadMatchDetail() async {
    setState(() => _error = null);
    
    final match = await executeWithLoadingAndReturn<Match>(
      operation: () => _matchingManager.fetchMatchDetail(widget.matchId),
      showErrorToast: false,  // We show custom error UI
      onError: (error) {
        setState(() => _error = 'Failed to load match details');
      },
    );
    
    if (match != null) {
      setState(() => _match = match);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(_match == null 
          ? 'Loading...' 
          : _match!.isConnected 
            ? 'Connection' 
            : 'Match'),
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
            MatchActionsSection(
              match: _match!,
              onMatchRemoved: widget.onMatchRemoved,
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
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
              onAvatarTap: _match!.profile.avatarID != null
                  ? () => _viewMatchAvatar(context)
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
              MatchSectionHeader(
                iconName: 'card',
                title: '${_match!.nrOfPrompts} matching ${_match!.nrOfPrompts == 1 ? "card" : "cards"}',
              ),
              const SizedBox(height: 16),
              MatchPromptsSection(
                match: _match!,
                currentProfile: _sessionManager.currentProfile!,
              ),
              const SizedBox(height: 24),
            ],
            
            // Shared Connections Section 
            if (_match!.nrOfConnections > 0) ...[
              MatchSectionHeader(
                iconName: 'handshake',
                title: '${_match!.nrOfConnections} shared ${_match!.nrOfConnections == 1 ? "connection" : "connections"}',
              ),
              const SizedBox(height: 16),
              MatchConnectionsSection(match: _match!),
              const SizedBox(height: 24),
            ],
            
            // Company matches section
            if (_match!.nrOfCompanyTags > 0) ...[
              MatchSectionHeader(
                iconName: 'company',
                title: '${_match!.nrOfCompanyTags} company ${_match!.nrOfCompanyTags == 1 ? "match" : "matches"}',
              ),
              const SizedBox(height: 16),
              MatchTagsSection(tagGroups: _match!.companyTagGroups),
              const SizedBox(height: 24),
            ],
            
            // Personal matches section  
            if (_match!.nrOfPersonalTags > 0) ...[
              MatchSectionHeader(
                iconName: 'match',
                title: '${_match!.nrOfPersonalTags} personal ${_match!.nrOfPersonalTags == 1 ? "match" : "matches"}',
              ),
              const SizedBox(height: 16),
              MatchTagsSection(tagGroups: _match!.personalTagGroups),
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


  Future<void> _openLinkedIn() async {
    if (_match?.profile.linkedInURL == null) return;
    
    final uri = Uri.parse(_match!.profile.linkedInURL!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ToastService.error(
          context: context,
          message: 'Could not open LinkedIn profile',
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
        ToastService.error(
          context: context,
          message: 'Could not open email app',
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
        ToastService.error(
          context: context,
          message: 'Could not open website',
        );
      }
    }
  }

  /// Shows the match avatar in fullscreen view
  Future<void> _viewMatchAvatar(BuildContext context) async {
    await AvatarFullscreenViewer.show(
      context: context,
      avatarId: _match?.profile.avatarID,
      showBorder: false,
      preserveAspectRatio: true,
    );
  }
}