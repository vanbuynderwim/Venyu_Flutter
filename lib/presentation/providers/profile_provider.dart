import 'package:flutter/foundation.dart';
import '../../data/models/profile_model.dart';
import '../../domain/usecases/get_my_profile_usecase.dart';
import '../../config/dependencies/injection_container.dart';
import '../../core/exceptions/supabase_exception.dart';
import 'dart:io';

class ProfileProvider extends ChangeNotifier {
  final GetMyProfileUsecase _getMyProfileUsecase = sl<GetMyProfileUsecase>();

  ProfileModel? _profile;
  bool _isLoading = false;
  String? _error;

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final profile = await _getMyProfileUsecase.call(
        countryCode: _detectCountryCode(),
        languageCode: _detectLanguageCode(),
        appVersion: '1.0.0', // You can get this from PackageInfo
      );

      _profile = profile;
      _error = null;
    } on SupabaseException catch (e) {
      _error = e.message;
      _profile = null;
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      _profile = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _detectCountryCode() {
    // This is a simplified implementation
    // In a real app, you'd use a proper locale detection library
    return Platform.localeName.split('_').last;
  }

  String _detectLanguageCode() {
    // This is a simplified implementation
    // In a real app, you'd use a proper locale detection library
    return Platform.localeName.split('_').first;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}