import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../services/revenuecat_service.dart';
import '../../services/toast_service.dart';
import '../../services/profile_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../models/enums/action_button_type.dart';
import '../../widgets/common/radar_background.dart';
import '../../widgets/common/onboarding_benefits_card.dart';
import '../profile/registration_complete_view.dart';
import '../../models/enums/onboarding_benefit.dart';
import '../../models/package_option.dart';
import '../../widgets/buttons/option_button.dart';
import '../../core/theme/app_fonts.dart';

/// Paywall view that shows subscription options to users during onboarding
class PaywallView extends StatefulWidget {
  /// Whether this paywall is part of the registration wizard
  final bool registrationWizard;
  
  const PaywallView({
    super.key, 
    this.registrationWizard = false,
  });

  @override
  State<PaywallView> createState() => _PaywallViewState();
}

class _PaywallViewState extends State<PaywallView> {
  final RevenueCatService _revenueCatService = RevenueCatService();
  Offerings? _offerings;
  bool _isLoading = true;
  bool _isPurchasing = false;
  Package? _selectedPackage;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      setState(() => _isLoading = true);
      
      // Initialize RevenueCat if not already done
      if (!_revenueCatService.isInitialized) {
        await _revenueCatService.initialize();
      }
      
      // Get offerings
      final offerings = await _revenueCatService.getOfferings();
      
      setState(() {
        _offerings = offerings;
        _isLoading = false;
        // Auto-select first package when loaded
        if (offerings.current?.availablePackages.isNotEmpty == true) {
          _selectedPackage = offerings.current!.availablePackages.first;
        }
      });
      
      AppLogger.info('Paywall loaded with ${offerings.all.length} offerings', context: 'PaywallView');
    } catch (e) {
      AppLogger.error('Failed to load paywall offerings', error: e, context: 'PaywallView');
      setState(() => _isLoading = false);
      
      if (mounted) {
        ToastService.error(
          context: context,
          message: 'Failed to load subscription options',
        );
      }
    }
  }

  Future<void> _purchaseSelectedPackage() async {
    if (_isPurchasing || _selectedPackage == null) return;
    
    setState(() => _isPurchasing = true);
    
    try {
      await _revenueCatService.purchasePackage(_selectedPackage!);
      
      AppLogger.info('Purchase successful', context: 'PaywallView');
      
      // Refresh profile to update isPro status
      await ProfileService.shared.refreshProfile();
      
      if (mounted) {
        ToastService.success(
          context: context,
          message: 'Subscription activated successfully!',
        );
        _navigateToComplete(subscriptionCompleted: true);
      }
    } catch (e) {
      AppLogger.error('Purchase failed', error: e, context: 'PaywallView');
      
      if (mounted) {
        ToastService.error(
          context: context,
          message: 'Purchase failed. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPurchasing = false);
      }
    }
  }

  Future<void> _restorePurchases() async {
    try {
      final customerInfo = await _revenueCatService.restorePurchases();
      
      if (_revenueCatService.hasActiveSubscription(customerInfo)) {
        AppLogger.info('Purchases restored successfully', context: 'PaywallView');
        
        if (mounted) {
          ToastService.success(
            context: context,
            message: 'Purchases restored successfully!',
          );
          _navigateToComplete(subscriptionCompleted: true);
        }
      } else {
        if (mounted) {
          ToastService.info(
            context: context,
            message: 'No active subscriptions found',
          );
        }
      }
    } catch (e) {
      AppLogger.error('Failed to restore purchases', error: e, context: 'PaywallView');
      
      if (mounted) {
        ToastService.error(
          context: context,
          message: 'Failed to restore purchases',
        );
      }
    }
  }

  /// Navigate to registration complete after paywall or close modal
  void _navigateToComplete({bool subscriptionCompleted = false}) {
    if (widget.registrationWizard) {
      Navigator.of(context).pushReplacement(
        platformPageRoute(
          context: context,
          builder: (context) => const RegistrationCompleteView(),
        ),
      );
    } else {
      // Close the modal and return subscription status
      Navigator.of(context).pop(subscriptionCompleted);
    }
  }

  /// Calculate daily cost for the selected package
  String? _calculateDailyCost() {
    if (_selectedPackage == null) return null;
    
    final price = _selectedPackage!.storeProduct.price;
    double dailyCost;
    
    if (_selectedPackage!.packageType == PackageType.annual) {
      dailyCost = price / 365;
    } else if (_selectedPackage!.packageType == PackageType.monthly) {
      dailyCost = price / 30;
    } else {
      return null; // Unknown package type
    }
    
    // Format the daily cost with currency symbol
    final currencyCode = _selectedPackage!.storeProduct.currencyCode;
    final currencySymbol = _getCurrencySymbol(currencyCode);
    
    return '$currencySymbol${dailyCost.toStringAsFixed(2)} per day';
  }
  
  /// Get currency symbol from currency code
  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      default:
        return currencyCode; // Fallback to currency code
    }
  }

  /// Calculate discount percentage for annual vs monthly
  String? _calculateDiscountPercentage() {
    if (_offerings?.current?.availablePackages.isEmpty != false) return null;
    
    Package? monthlyPackage;
    Package? annualPackage;
    
    // Find monthly and annual packages
    for (final package in _offerings!.current!.availablePackages) {
      if (package.packageType == PackageType.monthly) {
        monthlyPackage = package;
      } else if (package.packageType == PackageType.annual) {
        annualPackage = package;
      }
    }
    
    // Need both packages to calculate discount
    if (monthlyPackage == null || annualPackage == null) return null;
    
    // Calculate yearly cost if paying monthly
    final yearlyMonthlyPrice = monthlyPackage.storeProduct.price * 12;
    final annualPrice = annualPackage.storeProduct.price;
    
    // Calculate discount percentage
    final savings = yearlyMonthlyPrice - annualPrice;
    final discountPercentage = (savings / yearlyMonthlyPrice) * 100;
    
    // Round to whole number
    final roundedDiscount = discountPercentage.round();
    
    return '$roundedDiscount% OFF';
  }


  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Scaffold(
      backgroundColor: venyuTheme.pageBackground,
      body: Stack(
        children: [
          // RadarBackground full screen, no SafeArea
          const RadarBackground(),
          
          // Content with SafeArea
          SafeArea(
            bottom: false,  // No bottom safe area - buttons go to edge
            child: Column(
              children: [
                // Fixed header with close button and subtitle
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Stack(
                        children: [
                          // Title centered
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Join Venyu Pro',
                                style: AppTextStyles.title2.copyWith(
                                  color: venyuTheme.primaryText,
                                  fontSize: 28,
                                  fontFamily: AppFonts.graphie
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          // Close button top right (only when not in registration wizard)
                          if (!widget.registrationWizard)
                            Positioned(
                              top: 0,
                              right: -8,
                              child: PlatformIconButton(
                                icon: Icon(
                                  PlatformIcons(context).clear,
                                  color: venyuTheme.primaryText,
                                ),
                                onPressed: _navigateToComplete,
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Get the right introductions, faster',
                        style: AppTextStyles.subheadline.copyWith(
                          color: venyuTheme.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                  ],
                ),
                
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //const SizedBox(height: 16),
                        
                        // Premium features using OnboardingBenefitsCard - no extra padding
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: OnboardingBenefitsCard(
                            benefits: [
                              OnboardingBenefit.focusedReach,
                              OnboardingBenefit.discreetPreview,
                              OnboardingBenefit.unlimitedIntroductions,
                              OnboardingBenefit.unlockFullProfiles,
                              //OnboardingBenefit.aiPoweredMatches,
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Subscription packages as OptionButtons
                        if (_isLoading) ...[
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ] else if (_offerings?.current?.availablePackages.isNotEmpty == true) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                for (final package in _offerings!.current!.availablePackages)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        OptionButton(
                                          option: PackageOption(package),
                                          isSelected: _selectedPackage?.identifier == package.identifier,
                                          isMultiSelect: false,
                                          withDescription: true,
                                          useBorderSelection: true,
                                          onSelect: () {
                                            HapticFeedback.selectionClick();
                                            setState(() {
                                              _selectedPackage = package;
                                            });
                                          },
                                        ),
                                        // Discount badge for annual packages
                                        if (package.packageType == PackageType.annual && _calculateDiscountPercentage() != null)
                                          Positioned(
                                            top: -10,
                                            right: 12,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: venyuTheme.primary,
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: venyuTheme.primary.withValues(alpha: 0.3),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                _calculateDiscountPercentage()!,
                                                style: AppTextStyles.caption1.copyWith(
                                                  color: venyuTheme.cardBackground,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                        
                        // Add bottom padding for scrollable content
                        const SizedBox(height: 120), // Space for fixed buttons
                      ],
                    ),
                  ),
                ),
                
                // Fixed bottom buttons - similar to base_form_view
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Daily cost calculation
                    if (_selectedPackage != null && _calculateDailyCost() != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          _calculateDailyCost()!,
                          style: AppTextStyles.footnote.copyWith(
                            color: venyuTheme.secondaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    

                    // Action button(s) with margin like base_form_view
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: widget.registrationWizard 
                        ? Row(
                            children: [
                              
                              // Not now button (secondary) for registration wizard
                              Expanded(
                                child: ActionButton(
                                  label: 'Not now',
                                  type: ActionButtonType.secondary,
                                  onPressed: _navigateToComplete,
                                ),
                              ),
                              
                              const SizedBox(width: 12),
                              
                              // Subscribe button (primary) for registration wizard
                              Expanded(
                                child: ActionButton(
                                  label: _selectedPackage != null ? 'Subscribe' : 'Continue',
                                  type: ActionButtonType.primary,
                                  onPressed: _selectedPackage != null ? _purchaseSelectedPackage : _navigateToComplete,
                                  isLoading: _isPurchasing,
                                ),
                              ),
                            ],
                          )
                        : ActionButton(
                            label: _selectedPackage != null ? 'Subscribe & Continue' : 'Continue to Venyu',
                            onPressed: _selectedPackage != null ? _purchaseSelectedPackage : _navigateToComplete,
                            isLoading: _isPurchasing,
                          ),
                    ),
                    
                    // Restore purchases button
                    TextButton(
                      onPressed: _restorePurchases,
                      child: Text(
                        'Restore Purchases',
                        style: AppTextStyles.caption1.copyWith(
                          color: venyuTheme.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}