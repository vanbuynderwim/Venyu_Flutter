import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import '../models.dart';

/// Enumeration of benefits shown during onboarding for various features.
/// 
/// This enum implements OptionType to be used with OptionButton widgets
/// and displays the advantages of enabling certain features like location
/// services, notifications, etc. during the onboarding process.
enum OnboardingBenefit implements OptionType {
  // Location benefits
  nearbyMatches(
    title: '... meet entrepreneurs nearby',
    description: '',
    icon: 'coffee',
  ),
  distanceAwareness(
    title: '... see who is within reach',
    description: '',
    icon: 'map',
  ),
  betterMatching(
    title: '... grow your network locally',
    description: '',
    icon: 'network',
  ),
  
  // Notification benefits
  matchNotifications(
    title: '... get match alerts',
    description: '',
    icon: 'couple',
  ),
  connectionNotifications(
    title: '... see new connections',
    description: '',
    icon: 'handshake',
  ),
  dailyReminders(
    title: '... make the net work',
    description: '',
    icon: 'card',
  );

  @override
  final String title;
  
  @override
  final String description;
  
  @override
  final String? icon;

  const OnboardingBenefit({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  String get id => name;
  
  @override
  Color get color => Colors.blue; // Default color, not used for onboarding
  
  @override
  String? get emoji => null;
  
  @override
  int get badge => 0;
  
  @override
  List<Tag>? get list => null;
}