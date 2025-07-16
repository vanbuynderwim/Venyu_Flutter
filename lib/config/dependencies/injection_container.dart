import 'package:get_it/get_it.dart';

import '../../domain/repositories/supabase_repository.dart';
import '../../domain/usecases/get_my_profile_usecase.dart';
import '../../domain/usecases/get_tag_groups_usecase.dart';
import '../../data/repositories/supabase_repository_impl.dart';
import '../../services/supabase_service.dart';

final GetIt sl = GetIt.instance;

class InjectionContainer {
  static Future<void> init() async {
    // Services
    sl.registerLazySingleton<SupabaseService>(() => SupabaseService.instance);

    // Repositories
    sl.registerLazySingleton<SupabaseRepository>(() => SupabaseRepositoryImpl());

    // Use cases
    sl.registerLazySingleton(() => GetMyProfileUsecase(sl()));
    sl.registerLazySingleton(() => GetTagGroupsUsecase(sl()));
  }
}