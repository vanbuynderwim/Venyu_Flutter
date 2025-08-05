import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_modifiers.dart';
import '../../services/session_manager.dart';
import '../../services/supabase_manager.dart';
import '../../widgets/buttons/action_button.dart';

/// Base class for all form-based views in the application.
/// 
/// This abstract class provides common functionality for forms including:
/// - Service initialization (SupabaseManager, SessionManager)
/// - Loading state management
/// - Save operation with error handling
/// - Success/error feedback via SnackBars
/// - Navigation after successful save
/// - Common UI patterns (field sections, save buttons)
/// 
/// Subclasses must implement:
/// - [buildFormContent] to provide the form fields
/// - [performSave] to handle the specific save operation
/// - [getSuccessMessage] to provide a custom success message
/// - [getErrorMessage] to provide a custom error message
/// 
/// Example usage:
/// ```dart
/// class EditNameView extends BaseFormView {
///   @override
///   Future<void> performSave() async {
///     await supabaseManager.updateProfileName(...);
///     sessionManager.updateCurrentProfileFields(...);
///   }
/// }
/// ```
abstract class BaseFormView extends StatefulWidget {
  /// Whether this form is part of the registration wizard
  final bool registrationWizard;
  
  /// Optional custom title for the form
  final String? title;

  const BaseFormView({
    super.key,
    this.registrationWizard = false,
    this.title,
  });

  @override
  BaseFormViewState<BaseFormView> createState();
}

abstract class BaseFormViewState<T extends BaseFormView> extends State<T> {
  /// Service instances
  late final SupabaseManager _supabaseManager;
  late final SessionManager _sessionManager;
  
  /// Loading state for save operations
  bool _isUpdating = false;
  
  /// Getters for services (available to subclasses)
  SupabaseManager get supabaseManager => _supabaseManager;
  SessionManager get sessionManager => _sessionManager;
  
  /// Whether the form is currently saving
  bool get isUpdating => _isUpdating;

  @override
  void initState() {
    super.initState();
    _supabaseManager = SupabaseManager.shared;
    _sessionManager = SessionManager.shared;
    initializeForm();
  }

  /// Initialize form-specific data (controllers, validation, etc.)
  /// 
  /// Override this method to set up form controllers, load initial data,
  /// or perform other initialization tasks.
  @protected
  void initializeForm() {
    // Default implementation - override in subclasses if needed
  }

  /// Build the form content (fields, sections, etc.)
  /// 
  /// This method should return the main content of the form,
  /// typically a Column with form fields.
  @protected
  Widget buildFormContent(BuildContext context);

  /// Perform the save operation
  /// 
  /// This method should contain the specific logic for saving the form data.
  /// It should throw an exception if the save fails.
  @protected
  Future<void> performSave();

  /// Get the success message to display after successful save
  @protected
  String getSuccessMessage() => 'Changes successfully saved';

  /// Get the error message to display after failed save
  @protected
  String getErrorMessage() => 'Failed to update, please try again';

  /// Get the form title
  @protected
  String getFormTitle() => widget.title ?? 'Edit';

  /// Whether the save button should be enabled
  /// 
  /// Override to add custom validation logic
  @protected
  bool get canSave => true;

  /// Navigate after successful save
  /// 
  /// Override to customize navigation behavior
  @protected
  void navigateAfterSave() {
    if (widget.registrationWizard) {
      // TODO: Implement navigation to next registration step
      debugPrint('Navigate to next registration step');
    } else {
      // Return true to indicate changes were saved
      Navigator.of(context).pop(true);
    }
  }

  /// Common save handler with error handling and feedback
  @protected
  Future<void> handleSave() async {
    if (!canSave || _isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      // Perform the specific save operation
      await performSave();
      
      // Update loading state
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
      
      // Show success message
      if (mounted) {
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(getSuccessMessage()),
              backgroundColor: context.venyuTheme.snackbarSuccess,
              duration: const Duration(seconds: 2),
            ),
          );
          
          // Navigate after a small delay to ensure snackbar is shown
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              navigateAfterSave();
            }
          });
        } catch (e) {
          // If showing snackbar fails, still try to navigate
          debugPrint('Failed to show success snackbar: $e');
          if (mounted) {
            navigateAfterSave();
          }
        }
      }
    } catch (error) {
      // Always update loading state first
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
      
      // Then show error if still mounted
      if (mounted) {
        // Use a post frame callback to ensure context is valid
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(getErrorMessage()),
                backgroundColor: context.venyuTheme.snackbarError,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        });
      }
      
      // Log error for debugging
      debugPrint('Error in ${widget.runtimeType}: $error');
    }
  }

  /// Build a standard field section with title and content
  @protected
  Widget buildFieldSection({
    required String title,
    required Widget content,
    EdgeInsets? padding,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: context.venyuTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  /// Build a standard save button
  @protected
  Widget buildSaveButton({
    String? label,
    VoidCallback? onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ActionButton(
        label: label ?? 'Save',
        onPressed: !canSave ? null : (onPressed ?? handleSave),
        isLoading: _isUpdating,
      ),
    );
  }

  /// Whether to use scroll view for the form content
  /// 
  /// Override to false if your form needs to manage its own scrolling
  /// or has Expanded widgets
  @protected
  bool get useScrollView => true;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(getFormTitle()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: useScrollView
                  ? SingleChildScrollView(
                      padding: AppModifiers.cardContentPadding,
                      child: buildFormContent(context),
                    )
                  : Padding(
                      padding: AppModifiers.cardContentPadding,
                      child: buildFormContent(context),
                    ),
            ),
            buildSaveButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}