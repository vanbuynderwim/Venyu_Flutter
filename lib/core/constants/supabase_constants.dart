import '../config/app_config.dart';

/// Supabase configuration constants
/// 
/// ⚠️ DEPRECATED: Use AppConfig directly instead of this class
/// This class is maintained for backward compatibility but will be removed in future versions.
/// 
/// For new code, use:
/// - AppConfig.supabaseUrl
/// - AppConfig.supabaseAnonKey
@Deprecated('Use AppConfig.supabaseUrl and AppConfig.supabaseAnonKey instead')
class SupabaseConstants {
  /// Supabase project URL - now loaded from environment configuration
  static String get supabaseUrl => AppConfig.supabaseUrl;
  
  /// Supabase anonymous key - now loaded from environment configuration
  static String get supabaseAnonKey => AppConfig.supabaseAnonKey;
}