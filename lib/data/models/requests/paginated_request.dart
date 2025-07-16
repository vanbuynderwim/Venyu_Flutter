import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/enums/match_status.dart';
import '../../../core/enums/server_list_type.dart';

part 'paginated_request.freezed.dart';
part 'paginated_request.g.dart';

@freezed
class PaginatedRequest with _$PaginatedRequest {
  const factory PaginatedRequest({
    required int limit,
    String? cursorId,
    DateTime? cursorTime,
    MatchStatus? cursorStatus,
    required ServerListType list,
  }) = _PaginatedRequest;

  factory PaginatedRequest.fromJson(Map<String, dynamic> json) =>
      _$PaginatedRequestFromJson(json);
}