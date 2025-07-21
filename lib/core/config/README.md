# Configuration Management

This directory contains the secure configuration management system for the Venyu Flutter app.

## Files Overview

- `environment.dart` - Environment-specific configuration management
- `app_config.dart` - Main application configuration with secure credential access

## Security Features

✅ **No hardcoded credentials** - All sensitive data loaded from environment variables
✅ **Environment validation** - Configuration is validated at app startup  
✅ **Multiple environment support** - Development, staging, and production configs
✅ **Fail-safe defaults** - Safe fallback values for development

## Setup Instructions

### 1. Environment Variables

Set environment variables for your target platform:

**Development:**
```bash
export SUPABASE_URL_DEV="https://your-dev-project.supabase.co"
export SUPABASE_KEY_DEV="your_development_anon_key"
export ENVIRONMENT="development"
```

**Production:**
```bash
export SUPABASE_URL_PROD="https://your-prod-project.supabase.co" 
export SUPABASE_KEY_PROD="your_production_anon_key"
export ENVIRONMENT="production"
```

### 2. Build-time Configuration

**Development build:**
```bash
flutter run \
  --dart-define=ENVIRONMENT=development \
  --dart-define=SUPABASE_URL_DEV=https://your-dev.supabase.co \
  --dart-define=SUPABASE_KEY_DEV=your_dev_key
```

**Production build:**
```bash
flutter build apk \
  --dart-define=ENVIRONMENT=production \
  --dart-define=SUPABASE_URL_PROD=https://your-prod.supabase.co \
  --dart-define=SUPABASE_KEY_PROD=your_prod_key
```

### 3. Usage in Code

```dart
import 'package:venyu/core/config/app_config.dart';

// Access configuration
final url = AppConfig.supabaseUrl;
final key = AppConfig.supabaseAnonKey;

// Build service URLs
final avatarUrl = AppConfig.avatarUrl('user-123');
final placeholderUrl = AppConfig.placeholderIconUrl(text: 'AB');
```

## Environment Detection

```dart
import 'package:venyu/core/config/environment.dart';

if (EnvironmentConfig.isDebug) {
  print('Debug mode enabled');
}

if (EnvironmentConfig.isProduction) {
  // Production-only code
}
```

## Security Best Practices

🔐 **Never commit sensitive values** to version control
🔐 **Use different keys** for each environment
🔐 **Validate configuration** at app startup  
🔐 **Monitor for configuration errors** in production
🔐 **Rotate keys regularly** following security best practices

## Troubleshooting

**App fails to start with configuration error:**
1. Check that all required environment variables are set
2. Verify the environment variable names match exactly
3. Ensure Supabase URLs and keys are valid
4. Check the ENVIRONMENT variable is set to a valid value

**Missing configuration in builds:**
1. Verify `--dart-define` flags are passed correctly
2. Check CI/CD pipeline environment variable configuration
3. Ensure build scripts include all necessary defines