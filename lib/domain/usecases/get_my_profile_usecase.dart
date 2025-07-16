import '../repositories/supabase_repository.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/requests/update_country_language_request.dart';
import '../../core/exceptions/supabase_exception.dart';

class GetMyProfileUsecase {
  final SupabaseRepository _repository;

  GetMyProfileUsecase(this._repository);

  Future<ProfileModel> call({
    required String countryCode,
    required String languageCode,
    required String appVersion,
  }) async {
    try {
      final request = UpdateCountryLanguageRequest(
        countryCode: countryCode,
        languageCode: languageCode,
        appVersion: appVersion,
      );

      return await _repository.getMyProfile(request);
    } on SupabaseException {
      rethrow;
    } catch (e) {
      throw SupabaseException('Failed to get profile: $e');
    }
  }
}