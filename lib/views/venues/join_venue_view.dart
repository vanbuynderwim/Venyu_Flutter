import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../mixins/error_handling_mixin.dart';
import '../../widgets/buttons/action_button.dart';
import 'join_venue_detail/venue_gradient_container.dart';
import 'join_venue_detail/venue_code_field.dart';
import '../../services/supabase_managers/venue_manager.dart';
import '../../core/utils/app_logger.dart';
import '../../services/toast_service.dart';
import '../../models/enums/toast_type.dart';

/// Join venue view for entering venue invite codes.
/// 
/// This view provides a clean form interface for users to enter venue invite codes.
/// Features:
/// - 8-character code input field
/// - Primary color gradient background
/// - Join button enabled only when 8 characters are entered
class JoinVenueView extends StatefulWidget {
  const JoinVenueView({super.key});

  @override
  State<JoinVenueView> createState() => _JoinVenueViewState();
}

class _JoinVenueViewState extends State<JoinVenueView> with ErrorHandlingMixin {
  // Controllers
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  
  // State
  bool _codeIsValid = false;
  
  // Constants
  static const int _maxLength = 8;

  @override
  void initState() {
    super.initState();
    
    // Add listener for validation and character limiting
    _codeController.addListener(() {
      _limitText();
      setState(() {
        _codeIsValid = _codeController.text.trim().length == _maxLength;
      });
    });
    
    // Auto-focus the content field to open keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _codeFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }
  
  /// Enforces character limit on venue code.
  void _limitText() {
    try {
      final text = _codeController.text;
      if (text.length > _maxLength) {
        final truncated = text.substring(0, _maxLength);
        
        // Check if the controller is still mounted and valid
        if (!mounted || _codeController.value.text != text) {
          return;
        }
        
        // Safely update the controller value
        final newOffset = truncated.length.clamp(0, truncated.length);
        
        _codeController.value = TextEditingValue(
          text: truncated,
          selection: TextSelection.collapsed(offset: newOffset),
        );
      }
    } catch (e) {
      // Log the error but don't crash the app
      AppLogger.warning('Error in _limitText: $e', context: 'JoinVenueView');
    }
  }

  Future<void> _handleJoin() async {
    if (!_codeIsValid || isProcessing) return;
    
    final code = _codeController.text.trim();
    
    try {
      setProcessingState(true);
      
      AppLogger.info('Attempting to join venue with code', context: 'JoinVenueView');
      
      // Call VenueManager to join the venue
      final venueId = await VenueManager.shared.joinVenue(code);
      
      AppLogger.success('Successfully joined venue: $venueId', context: 'JoinVenueView');
      
      if (mounted) {
        // Close modal with success result
        // The true value signals that venues should be refreshed
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      AppLogger.error('Failed to join venue', error: error, context: 'JoinVenueView');
      
      if (mounted) {
        // Show error message to user using ToastService
        final errorMessage = error.toString().replaceAll('Exception: ', '');
        ToastService.show(
          context: context,
          message: errorMessage,
          type: ToastType.error,
        );
        
        // Keep keyboard open and focus on the code field
        _codeFocusNode.requestFocus();
      }
    } finally {
      if (mounted) {
        setProcessingState(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VenueGradientContainer(
      child: PlatformScaffold(
        backgroundColor: Colors.transparent,
        appBar: PlatformAppBar(
          backgroundColor: Colors.transparent,
          cupertino: (_, __) => CupertinoNavigationBarData(
            backgroundColor: Colors.transparent,
            border: null, // Remove border
          ),
          material: (_, __) => MaterialAppBarData(
            backgroundColor: Colors.transparent,
            elevation: 0, // Remove shadow
            surfaceTintColor: Colors.transparent,
          ),
        ),
        body: SafeArea(
          bottom: false, // Allow keyboard to overlay the bottom safe area
          child: Column(
            children: [
              // Main code input field
              VenueCodeField(
                controller: _codeController,
                focusNode: _codeFocusNode,
                isEnabled: !isProcessing,
                maxLength: _maxLength,
                onSubmit: _codeIsValid ? _handleJoin : null,
              ),

              const SizedBox(height: 24),

              // Join button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ActionButton(
                  label: 'Join',
                  isDisabled: !_codeIsValid,
                  isLoading: isProcessing,
                  onPressed: _handleJoin,
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}