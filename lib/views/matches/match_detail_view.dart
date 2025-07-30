import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/match.dart';
import '../../services/supabase_manager.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/profile/profile_header.dart';

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
  
  // State
  Match? _match;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _supabaseManager = SupabaseManager.shared;
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
      usePadding: false,
      useSafeArea: true,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadMatchDetail,
              child: _buildContent(),
            ),
          ),
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
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
      children: [
            // Profile Header
            ProfileHeader(
              profile: _match!.profile,
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
            if (_match!.prompts != null && _match!.prompts!.isNotEmpty) ...[
              _buildSectionHeader(
                icon: Icons.home,
                title: '${_match!.prompts!.length} matching ${_match!.prompts!.length == 1 ? "card" : "cards"}',
              ),
              const SizedBox(height: 16),
              _buildPromptsSection(),
              const SizedBox(height: 24),
            ],
            
            // Shared Connections Section (only for connected matches)
            if (_match!.isConnected && 
                _match!.connections != null && 
                _match!.connections!.isNotEmpty) ...[
              _buildSectionHeader(
                icon: Icons.handshake,
                title: '${_match!.connections!.length} shared ${_match!.connections!.length == 1 ? "connection" : "connections"}',
              ),
              const SizedBox(height: 16),
              _buildConnectionsSection(),
              const SizedBox(height: 24),
            ],
            
            // Shared Tags Section
            if (_match!.tagGroups != null && _match!.tagGroups!.isNotEmpty) ...[
              _buildSectionHeader(
                icon: Icons.tag,
                title: '${_match!.sharedTagsCount} shared ${_match!.sharedTagsCount == 1 ? "tag" : "tags"}',
              ),
              const SizedBox(height: 16),
              _buildTagGroupsSection(),
              const SizedBox(height: 24),
            ],
            
            // Action Buttons (if not connected)
            if (!_match!.isConnected && _match!.response == null) ...[
              _buildActionButtons(),
              const SizedBox(height: 32),
            ],
      ],
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    final venyuTheme = context.venyuTheme;
    
    return Row(
      children: [
        Icon(icon, size: 20, color: venyuTheme.primaryText),
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
    // TODO: Implement prompts/cards display
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.venyuTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.venyuTheme.borderColor, width: 0.5),
      ),
      child: Text(
        'Prompts section - Coming soon',
        style: AppTextStyles.body.copyWith(
          color: context.venyuTheme.secondaryText,
        ),
      ),
    );
  }

  Widget _buildConnectionsSection() {
    // TODO: Implement shared connections display
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.venyuTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.venyuTheme.borderColor, width: 0.5),
      ),
      child: Text(
        'Shared connections - Coming soon',
        style: AppTextStyles.body.copyWith(
          color: context.venyuTheme.secondaryText,
        ),
      ),
    );
  }

  Widget _buildTagGroupsSection() {
    // TODO: Implement shared tag groups display
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.venyuTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.venyuTheme.borderColor, width: 0.5),
      ),
      child: Text(
        'Shared tags - Coming soon',
        style: AppTextStyles.body.copyWith(
          color: context.venyuTheme.secondaryText,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final venyuTheme = context.venyuTheme;
    
    return Row(
      children: [
        // Skip/Pass button
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // TODO: Handle skip action
              debugPrint('Skip match');
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: venyuTheme.borderColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Skip',
              style: AppTextStyles.body.copyWith(
                color: venyuTheme.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Connect button
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Handle connect action
              debugPrint('Connect with match');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: venyuTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Connect',
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
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