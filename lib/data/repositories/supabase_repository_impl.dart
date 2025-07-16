import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../domain/repositories/supabase_repository.dart';
import '../../services/supabase_service.dart';
import '../models/profile_model.dart';
import '../models/tag_group_model.dart';
import '../models/requests/update_country_language_request.dart';
import '../models/requests/update_name_request.dart';
import '../models/requests/paginated_request.dart';
import '../../core/enums/category_type.dart';
import '../../core/exceptions/supabase_exception.dart';

class SupabaseRepositoryImpl implements SupabaseRepository {
  final SupabaseClient _client = SupabaseService.instance.client;

  // Helper method to execute authenticated requests with error handling
  Future<T> _executeAuthenticatedRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on PostgrestException catch (e) {
      // Log error (you can integrate with your preferred logging service)
      debugPrint('PostgrestException: ${e.message}');
      throw SupabaseException(e.message);
    } catch (e) {
      debugPrint('General error: $e');
      throw SupabaseException(e.toString());
    }
  }

  // Helper method to get device info
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    
    Map<String, dynamic> deviceData = {
      'deviceOS': Platform.operatingSystem,
      'deviceInterface': Platform.isIOS ? 'iOS' : 'Android',
      'deviceType': Platform.isIOS ? 'iPhone' : 'Android',
      'systemVersion': Platform.operatingSystemVersion,
      'appVersion': packageInfo.version,
    };

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceData['deviceType'] = iosInfo.model;
      deviceData['systemVersion'] = iosInfo.systemVersion;
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceData['deviceType'] = androidInfo.model;
      deviceData['systemVersion'] = androidInfo.version.release;
    }

    return deviceData;
  }

  @override
  Future<void> signInWithApple() async {
    return _executeAuthenticatedRequest(() async {
      await _client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'com.venyu.app://oauth-callback',
      );
    });
  }

  @override
  Future<void> signInWithLinkedIn() async {
    return _executeAuthenticatedRequest(() async {
      await _client.auth.signInWithOAuth(
        OAuthProvider.linkedin,
        redirectTo: 'com.venyu.app://oauth-callback',
      );
    });
  }

  @override
  Future<void> signOut() async {
    return _executeAuthenticatedRequest(() async {
      await _client.auth.signOut();
    });
  }

  @override
  Future<ProfileModel> getMyProfile(UpdateCountryLanguageRequest request) async {
    return _executeAuthenticatedRequest(() async {
      final response = await _client.rpc('get_my_profile', params: {
        'payload': request.toJson(),
      });
      
      return ProfileModel.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<void> updateProfileName(UpdateNameRequest request) async {
    return _executeAuthenticatedRequest(() async {
      await _client.rpc('update_profile_name', params: {
        'payload': request.toJson(),
      });
    });
  }

  @override
  Future<void> updateProfileBio(String bio) async {
    return _executeAuthenticatedRequest(() async {
      await _client.rpc('update_profile_bio', params: {
        'p_bio': bio,
      });
    });
  }

  @override
  Future<void> updateProfileLocation(double latitude, double longitude) async {
    return _executeAuthenticatedRequest(() async {
      await _client.rpc('update_profile_location', params: {
        'latitude': latitude,
        'longitude': longitude,
      });
    });
  }

  @override
  Future<void> deleteProfile() async {
    return _executeAuthenticatedRequest(() async {
      await _client.rpc('delete_profile');
    });
  }

  @override
  Future<List<TagGroupModel>> getAllTagGroups() async {
    return _executeAuthenticatedRequest(() async {
      final response = await _client.rpc('get_all_taggroups');
      
      return (response as List)
          .map((item) => TagGroupModel.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<List<TagGroupModel>> getTagGroups(CategoryType categoryType) async {
    return _executeAuthenticatedRequest(() async {
      final response = await _client.rpc('get_taggroups', params: {
        'p_category_type': categoryType.value,
      });
      
      return (response as List)
          .map((item) => TagGroupModel.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<TagGroupModel> getTagGroup(String code) async {
    return _executeAuthenticatedRequest(() async {
      final response = await _client.rpc('get_taggroup', params: {
        'p_code': code,
      });
      
      return TagGroupModel.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<void> handleDeviceToken(String fcmToken) async {
    return _executeAuthenticatedRequest(() async {
      final deviceInfo = await _getDeviceInfo();
      
      await _client.rpc('handle_device_token', params: {
        'payload': {
          'fcmToken': fcmToken,
          ...deviceInfo,
        },
      });
    });
  }

  @override
  Future<void> sendMailOTP(String email) async {
    return _executeAuthenticatedRequest(() async {
      await _client.rpc('send_mail_otp', params: {
        'p_email': email,
      });
    });
  }

  @override
  Future<void> verifyMailOTP(String email, String code, bool subscribed) async {
    return _executeAuthenticatedRequest(() async {
      await _client.rpc('verify_mail_otp', params: {
        'payload': {
          'email': email,
          'code': code,
          'subscribed': subscribed,
        },
      });
    });
  }

  @override
  Future<Map<String, dynamic>> getBadges() async {
    return _executeAuthenticatedRequest(() async {
      final response = await _client.rpc('get_badges');
      return response as Map<String, dynamic>;
    });
  }

  @override
  Future<List<dynamic>> getNotifications(PaginatedRequest request) async {
    return _executeAuthenticatedRequest(() async {
      final response = await _client.rpc('get_notifications', params: {
        'payload': request.toJson(),
      });
      
      return response as List<dynamic>;
    });
  }

  @override
  Future<void> updateNotification(String notificationId) async {
    return _executeAuthenticatedRequest(() async {
      await _client.rpc('update_notification', params: {
        'p_notification_id': notificationId,
      });
    });
  }

  @override
  Future<List<dynamic>> getMatches(PaginatedRequest request) async {
    return _executeAuthenticatedRequest(() async {
      final response = await _client.rpc('get_matches', params: {
        'payload': request.toJson(),
      });
      
      return response as List<dynamic>;
    });
  }

  @override
  Future<Map<String, dynamic>> getMatch(String matchId) async {
    return _executeAuthenticatedRequest(() async {
      final response = await _client.rpc('get_match', params: {
        'p_match_id': matchId,
      });
      
      return response as Map<String, dynamic>;
    });
  }

  @override
  Future<void> blockProfile(String profileId) async {
    return _executeAuthenticatedRequest(() async {
      await _client.rpc('block_profile', params: {
        'p_profile_id': profileId,
      });
    });
  }

  @override
  Future<void> unblockProfile(String profileId) async {
    return _executeAuthenticatedRequest(() async {
      await _client.rpc('unblock_profile', params: {
        'p_profile_id': profileId,
      });
    });
  }

  @override
  Future<List<dynamic>> getBlockedProfiles() async {
    return _executeAuthenticatedRequest(() async {
      final response = await _client.rpc('get_blocked_profiles');
      return response as List<dynamic>;
    });
  }

  @override
  Future<Map<String, dynamic>> getVersion() async {
    return _executeAuthenticatedRequest(() async {
      final response = await _client.rpc('get_version');
      return response as Map<String, dynamic>;
    });
  }
}