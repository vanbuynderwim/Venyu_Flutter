import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/services.dart';

import '../../../widgets/common/loading_state_widget.dart';
import '../../../widgets/common/empty_state_widget.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../core/utils/app_logger.dart';
import '../../venues/join_venue_view.dart';
import '../../../services/supabase_managers/venue_manager.dart';
import '../../../models/venue.dart';
import '../../venues/venue_item_view.dart';
import '../../venues/venue_detail_view.dart';

/// VenuesSection - Venues and organizations section
/// 
/// This widget displays the venues section including:
/// - User's events and organizations
/// - Loading states and empty states
/// - Join venue functionality
/// 
/// Features:
/// - Fetches user venues on load
/// - Loading state with custom message
/// - Empty state handling for no venues
/// - Shows venue list when venues exist
class VenuesSection extends StatefulWidget {
  final Function(bool)? onVenuesChanged;

  const VenuesSection({
    super.key,
    this.onVenuesChanged,
  });

  @override
  State<VenuesSection> createState() => _VenuesSectionState();
}

class _VenuesSectionState extends State<VenuesSection> {
  bool _isLoading = true;
  List<Venue> _venues = [];
  String? _error;

  /// Whether there are venues to display
  bool get hasVenues => _venues.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  Future<void> _loadVenues() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final venues = await VenueManager.shared.fetchVenues();
      
      if (mounted) {
        setState(() {
          _venues = venues;
          _isLoading = false;
        });
        // Notify parent about venue changes
        widget.onVenuesChanged?.call(venues.isNotEmpty);
      }
    } catch (error) {
      AppLogger.error('Failed to load venues', error: error, context: 'VenuesSection');
      if (mounted) {
        setState(() {
          _error = error.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: LoadingStateWidget(),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error loading venues',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              PlatformTextButton(
                onPressed: _loadVenues,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_venues.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: EmptyStateWidget(
            message: 'Your venues will appear here',
            description: 'Got an invite code? Redeem it to join that venue and start getting introductions in the community.',
            iconName: 'novenues',
            onAction: () => _openJoinVenueModal(context),
            actionText: 'Join a venue',
            actionButtonIcon: context.themedIcon('plus')
          ),
        ),
      );
    }

    // Venues found - show list of venue items
    return Column(
      children: List.generate(_venues.length, (index) {
        final venue = _venues[index];
        return VenueItemView(
          venue: venue,
          onTap: () {
            AppLogger.info('Navigating to venue detail: ${venue.name}', context: 'VenuesSection');
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (context) => VenueDetailView(venueId: venue.id),
              ),
            );
          },
        );
      }),
    );
  }

  /// Opens the join venue modal
  Future<void> _openJoinVenueModal(BuildContext context) async {
    HapticFeedback.selectionClick();
    AppLogger.debug('Opening join venue view...', context: 'VenuesSection');
    try {
      final result = await showPlatformModalSheet<bool>(
        context: context,
        material: MaterialModalSheetData(
          isScrollControlled: true,
          useSafeArea: true,
        ),
        builder: (context) {
          AppLogger.debug('Building JoinVenueView...', context: 'VenuesSection');
          return const JoinVenueView();
        },
      );
      
      AppLogger.debug('Join venue view closed with result: $result', context: 'VenuesSection');
      
      // If join was successful, refresh the venues list
      if (result == true && mounted) {
        AppLogger.info('Refreshing venues after successful join', context: 'VenuesSection');
        await _loadVenues();
      }
      
    } catch (error) {
      AppLogger.error('Error opening join venue view: $error', context: 'VenuesSection');
    }
  }
}