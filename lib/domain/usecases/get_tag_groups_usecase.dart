import '../repositories/supabase_repository.dart';
import '../../data/models/tag_group_model.dart';
import '../../core/enums/category_type.dart';
import '../../core/exceptions/supabase_exception.dart';

class GetTagGroupsUsecase {
  final SupabaseRepository _repository;

  GetTagGroupsUsecase(this._repository);

  Future<List<TagGroupModel>> call({CategoryType? categoryType}) async {
    try {
      if (categoryType != null) {
        return await _repository.getTagGroups(categoryType);
      } else {
        return await _repository.getAllTagGroups();
      }
    } on SupabaseException {
      rethrow;
    } catch (e) {
      throw SupabaseException('Failed to get tag groups: $e');
    }
  }
}