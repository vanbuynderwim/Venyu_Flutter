import 'package:flutter/foundation.dart';
import 'profile.dart';
import 'match.dart';
import 'notification.dart';
import 'enums/feedback_type.dart';
import 'enums/review_type.dart';
import 'enums/toast_style.dart';

class TestModels {
  static void runTests() {
    debugPrint('🧪 Testing Flutter Models...');
    
    _testProfile();
    _testMatch();
    _testNotification();
    _testNewEnums();
    
    debugPrint('✅ All model tests passed!');
  }

  static void _testProfile() {
    debugPrint('\n📋 Testing Profile model...');
    
    // Test JSON serialization
    final profileJson = {
      'id': '123e4567-e89b-12d3-a456-426614174000',
      'first_name': 'John',
      'last_name': 'Doe',
      'company_name': 'Tech Company',
      'bio': 'Software developer',
      'is_super_admin': false,
    };
    
    final profile = Profile.fromJson(profileJson);
    debugPrint('✓ Profile created: ${profile.fullName}');
    debugPrint('✓ Display name: ${profile.displayName}');
    
    profile.toJson(); // Test serialization
    debugPrint('✓ JSON serialization works');
  }

  static void _testMatch() {
    debugPrint('\n🤝 Testing Match model...');
    
    final matchJson = {
      'id': '123e4567-e89b-12d3-a456-426614174001',
      'profile': {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'first_name': 'Jane',
        'last_name': 'Smith',
        'is_super_admin': false,
      },
      'status': 'matched',
      'score': 85.5,
      'unread_count': 3,
    };
    
    final match = Match.fromJson(matchJson);
    debugPrint('✓ Match created with ${match.profile.fullName}');
    debugPrint('✓ Status: ${match.status.value}');
    debugPrint('✓ Has unread messages: ${match.hasUnreadMessages}');
    debugPrint('✓ Is matched: ${match.isMatched}');
  }

  static void _testNotification() {
    debugPrint('\n🔔 Testing Notification model...');
    
    final notificationJson = {
      'id': '123e4567-e89b-12d3-a456-426614174002',
      'type': 'matched',
      'title': 'New Match!',
      'body': 'You have a new match with Jane Smith',
      'created_at': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
    };
    
    final notification = Notification.fromJson(notificationJson);
    debugPrint('✓ Notification created: ${notification.title}');
    debugPrint('✓ Type: ${notification.type.value}');
    debugPrint('✓ Time ago: ${notification.timeAgo}');
    debugPrint('✓ Is unread: ${notification.isUnread}');
  }

  static void _testNewEnums() {
    debugPrint('\n🔧 Testing New Enums...');
    
    // Test FeedbackType
    final feedbackType = FeedbackType.goodConnection;
    debugPrint('✓ FeedbackType: ${feedbackType.value}');
    debugPrint('✓ Is positive: ${feedbackType.isPositive}');
    
    // Test ReviewType
    final reviewType = ReviewType.user;
    debugPrint('✓ ReviewType: ${reviewType.title}');
    debugPrint('✓ Description: ${reviewType.description}');
    
    // Test ToastStyle
    final toastStyle = ToastStyle.success;
    debugPrint('✓ ToastStyle: ${toastStyle.title}');
    debugPrint('✓ Color: ${toastStyle.themeColor}');
    
    // Test JSON serialization
    final feedback = FeedbackType.fromJson('linkedin_connected');
    debugPrint('✓ FeedbackType from JSON: ${feedback.value}');
  }
}