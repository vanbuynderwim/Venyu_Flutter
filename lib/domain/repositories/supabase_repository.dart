import '../../data/models/profile_model.dart';
import '../../data/models/tag_group_model.dart';
import '../../data/models/requests/update_country_language_request.dart';
import '../../data/models/requests/update_name_request.dart';
import '../../data/models/requests/paginated_request.dart';
import '../../core/enums/category_type.dart';

abstract class SupabaseRepository {
  // Authentication
  Future<void> signInWithApple();
  Future<void> signInWithLinkedIn();
  Future<void> signOut();
  
  // Profile Management
  Future<ProfileModel> getMyProfile(UpdateCountryLanguageRequest request);
  Future<void> updateProfileName(UpdateNameRequest request);
  Future<void> updateProfileBio(String bio);
  Future<void> updateProfileLocation(double latitude, double longitude);
  Future<void> deleteProfile();
  
  // Tags & Categories
  Future<List<TagGroupModel>> getAllTagGroups();
  Future<List<TagGroupModel>> getTagGroups(CategoryType categoryType);
  Future<TagGroupModel> getTagGroup(String code);
  
  // Device Management
  Future<void> handleDeviceToken(String fcmToken);
  
  // Email OTP
  Future<void> sendMailOTP(String email);
  Future<void> verifyMailOTP(String email, String code, bool subscribed);
  
  // Notifications & Badges
  Future<Map<String, dynamic>> getBadges();
  Future<List<dynamic>> getNotifications(PaginatedRequest request);
  Future<void> updateNotification(String notificationId);
  
  // Matches
  Future<List<dynamic>> getMatches(PaginatedRequest request);
  Future<Map<String, dynamic>> getMatch(String matchId);
  
  // User Management
  Future<void> blockProfile(String profileId);
  Future<void> unblockProfile(String profileId);
  Future<List<dynamic>> getBlockedProfiles();
  
  // System
  Future<Map<String, dynamic>> getVersion();
}