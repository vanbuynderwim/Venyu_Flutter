/// Environment configuration for different build targets
/// 
/// This enum defines the available environments for the app.
/// Use build-time configuration to set the appropriate environment.
enum Environment { 
  development, 
  staging, 
  production 
}

/// Environment-based configuration management
/// 
/// This class provides secure access to environment-specific configuration
/// values without exposing sensitive data in the source code.
class EnvironmentConfig {
  // Environment is set via build-time flags
  static Environment get _environment {
    const envName = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    switch (envName) {
      case 'production':
        return Environment.production;
      case 'staging':
        return Environment.staging;
      case 'development':
      default:
        return Environment.development;
    }
  }
  
  /// Current environment
  static Environment get environment => _environment;
  
  /// Supabase configuration
  static String get supabaseUrl {
    switch (_environment) {
      case Environment.development:
        return const String.fromEnvironment(
          'SUPABASE_URL_DEV',
          defaultValue: 'https://dev.getvenyu.supabase.co'
        );
      case Environment.staging:
        return const String.fromEnvironment(
          'SUPABASE_URL_STAGING',
          defaultValue: 'https://staging.getvenyu.supabase.co'
        );
      case Environment.production:
        return const String.fromEnvironment(
          'SUPABASE_URL_PROD',
          defaultValue: 'https://app.getvenyu.com'
        );
    }
  }
  
  static String get supabaseAnonKey {
    switch (_environment) {
      case Environment.development:
        return const String.fromEnvironment('SUPABASE_KEY_DEV', defaultValue: '');
      case Environment.staging:
        return const String.fromEnvironment('SUPABASE_KEY_STAGING', defaultValue: '');
      case Environment.production:
        return const String.fromEnvironment('SUPABASE_KEY_PROD', defaultValue: '');
    }
  }
  
  /// Debug and environment helpers
  static bool get isDebug => _environment == Environment.development;
  static bool get isProduction => _environment == Environment.production;
  static bool get isStaging => _environment == Environment.staging;
  
  /// Validate configuration on app startup
  static bool validateConfig() {
    final url = supabaseUrl;
    final key = supabaseAnonKey;
    
    if (url.isEmpty) {
      throw Exception('Supabase URL is not configured for environment: $_environment');
    }
    
    if (key.isEmpty) {
      throw Exception('Supabase anonymous key is not configured for environment: $_environment');
    }
    
    return true;
  }
}