import '../enums/prompt_status.dart';
import '../enums/review_type.dart';

/// Request model for updating a single prompt status
class UpdatePromptStatusRequest {
  final String promptID;
  final PromptStatus status;

  const UpdatePromptStatusRequest({
    required this.promptID,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'prompt_id': promptID,
      'status': status.value,
    };
  }
}

/// Request model for updating prompt status by review type
class UpdatePromptStatusByReviewType {
  final ReviewType reviewType;
  final PromptStatus status;

  const UpdatePromptStatusByReviewType({
    required this.reviewType,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'review_type': reviewType.value,
      'status': status.value,
    };
  }
}

/// Request model for batch updating prompt statuses
class UpdatePromptStatusBatch {
  final List<String> promptIds;
  final PromptStatus status;

  const UpdatePromptStatusBatch({
    required this.promptIds,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'prompt_ids': promptIds,
      'status': status.value,
    };
  }
}