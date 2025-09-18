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
    title: 'Meet entrepreneurs nearby',
    description: 'Discover people close to you',
    icon: 'coffee',
  ),
  distanceAwareness(
    title: 'See who is within reach',
    description: 'Know the distance to matches',
    icon: 'map',
  ),
  betterMatching(
    title: 'Grow your network locally',
    description: 'Get better results with local focus',
    icon: 'network',
  ),
  
  // Notification benefits
  matchNotifications(
    title: 'New match alerts',
    description: 'Get alerted as soon as a new match appears',
    icon: 'match',
  ),
  connectionNotifications(
    title: 'Never miss an intro',
    description: 'Know right away when you receive a new introduction',
    icon: 'handshake',
  ),
  dailyReminders(
    title: 'Stay in the game',
    description: 'Get reminded every day to make the net work',
    icon: 'card',
  ),
  focusedReach(
    title: 'Smart targeting',
    description: 'Publish your questions to the right audience',
    icon: 'target',
  ),
  discreetPreview(
    title: 'First call',
    description: 'On your cards, you get the first call. Matches are only shown to others if you’re interested.',
    icon: 'eye',
  ),
  unlimitedIntroductions(
    title: 'Infinite intros',
    description: 'Keep growing your network with unlimited introductions and never miss an opportunity',
    icon: 'handshake',
  ),
  unlockFullProfiles(
    title: 'Full profiles',
    description: 'Discover who’s behind the match by seeing their avatar and checking mutual interests',
    icon: 'profile',
  ),
  viewsAndImpressions(
    title: 'Views and impressions',
    description: 'Understand your reach with simple stats',
    icon: 'grow',
  ),
  dailyCardsBoost(
    title: 'More daily cards',
    description: 'More cards to grow your network faster.',
    icon: 'card',
  ),
  aiPoweredMatches(
    title: 'AI-powered matches (later)',
    description: 'Receive smart suggestions based on your profile.',
    icon: 'ai',
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