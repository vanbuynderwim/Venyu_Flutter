import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../widgets/buttons/option_button.dart';
import 'models.dart';

/// Wrapper for RevenueCat Package to implement OptionType for use with OptionButton
class PackageOption implements OptionType {
  final Package package;
  final String? discountText;

  PackageOption(this.package, {this.discountText});

  @override
  String get id => package.identifier;

  @override
  String title(BuildContext context) => package.storeProduct.title;

  @override
  String description(BuildContext context) => _formatDescription();

  @override
  String? get icon => null; // No icon for packages

  @override
  Color get color => Colors.blue; // Default color

  @override
  String? get emoji => null;

  @override
  int get badge => 0;


  @override
  List<Tag>? get list => null;

  /// Format description to show price and billing period
  String _formatDescription() {
    final price = package.storeProduct.priceString;
    
    if (package.packageType == PackageType.monthly) {
      return '$price per month';
    } else if (package.packageType == PackageType.annual) {
      return '$price per year';
    } else {
      return price;
    }
  }
}