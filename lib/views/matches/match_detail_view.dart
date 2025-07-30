import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/match.dart';
import '../../services/supabase_manager.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/common/card_item.dart';
import '../../widgets/common/role_view.dart';
import '../../widgets/common/tag_view.dart';

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
      padding: const EdgeInsets.only(bottom: 32.0),
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
            
            // Shared Connections Section (only for connected matches)
            if (_match!.isConnected && _match!.nrOfConnections > 0) ...[
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
            
            // Action Buttons (if not connected)
            if (!_match!.isConnected && _match!.response == null) ...[
              _buildActionButtons(),
              const SizedBox(height: 32),
            ],
      ],
    );
  }

  Widget _buildSectionHeader({required String iconName, required String title}) {
    final venyuTheme = context.venyuTheme;
    
    return Row(
      children: [
        context.themedIcon(iconName, size: 20, selected: true),
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
        decoration: BoxDecoration(
          color: context.venyuTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
          border: Border.all(color: context.venyuTheme.borderColor, width: 0.5),
        ),
        child: Text(
          'No matching cards',
          style: AppTextStyles.body.copyWith(
            color: context.venyuTheme.secondaryText,
          ),
        ),
      );
    }

    return Column(
      children: _match!.prompts!.map((prompt) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CardItem(
            prompt: prompt,
            onCardSelected: (selectedPrompt) {
              // TODO: Handle card detail view
              debugPrint('Card selected: ${selectedPrompt.label}');
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConnectionsSection() {
    if (_match!.connections == null || _match!.connections!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.venyuTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
          border: Border.all(color: context.venyuTheme.borderColor, width: 0.5),
        ),
        child: Text(
          'No shared connections',
          style: AppTextStyles.body.copyWith(
            color: context.venyuTheme.secondaryText,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.venyuTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
        border: Border.all(color: context.venyuTheme.borderColor, width: 0.5),
      ),
      child: Column(
        children: _match!.connections!.map((connection) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RoleView(
              profile: connection.profile,
              avatarSize: 50,
              showChevron: false,
              buttonDisabled: true,
            ),
          );
        }).toList(),
      ),
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
        decoration: BoxDecoration(
          color: context.venyuTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
          border: Border.all(color: context.venyuTheme.borderColor, width: 0.5),
        ),
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
      decoration: BoxDecoration(
        color: context.venyuTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
        border: Border.all(color: context.venyuTheme.borderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tagGroups.map((tagGroup) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
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
                borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
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
                borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
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