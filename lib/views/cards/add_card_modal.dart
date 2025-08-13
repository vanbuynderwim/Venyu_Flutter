import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../models/enums/action_button_type.dart';

/// AddCardModal - Modal screen for creating a new card
/// 
/// This modal provides a form interface for users to create new cards/prompts.
/// Features:
/// - Full screen modal presentation
/// - Form validation
/// - Save and cancel actions
class AddCardModal extends StatefulWidget {
  const AddCardModal({super.key});

  @override
  State<AddCardModal> createState() => _AddCardModalState();
}

class _AddCardModalState extends State<AddCardModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    debugPrint('AddCardModal: initState');
  }

  @override
  void dispose() {
    debugPrint('AddCardModal: dispose');
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Card'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      
                      // Title field
                      Text(
                        'Card Title',
                        style: AppTextStyles.body.copyWith(
                          color: context.venyuTheme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Enter card title...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLength: 100,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Content field
                      Text(
                        'Card Content',
                        style: AppTextStyles.body.copyWith(
                          color: context.venyuTheme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          hintText: 'Write your card content...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 8,
                        maxLength: 500,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter card content';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Save button
              ActionButton(
                label: 'Save Card',
                type: ActionButtonType.primary,
                isLoading: _isLoading,
                onPressed: _saveCard,
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future<void> _saveCard() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement save logic here
      // await _supabaseManager.createCard(
      //   title: _titleController.text.trim(),
      //   content: _contentController.text.trim(),
      // );
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
      }
      
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save card: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}