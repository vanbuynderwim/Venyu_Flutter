/// Invite model representing user invite codes
///
/// This model represents invite codes that users can generate and share
/// to invite others to join venues or the platform. Each invite has a
/// unique 8-character code and tracks redemption and sending status.
class Invite {
  /// Unique identifier for the invite
  final String id;

  /// 8-character invite code
  final String code;

  /// Whether the invite code has been redeemed
  final bool isRedeemed;

  /// Whether the invite has been sent to someone
  final bool isSent;

  const Invite({
    required this.id,
    required this.code,
    required this.isRedeemed,
    required this.isSent,
  });

  /// Create an Invite from JSON data
  factory Invite.fromJson(Map<String, dynamic> json) {
    return Invite(
      id: json['id'] as String,
      code: json['code'] as String,
      isRedeemed: json['is_redeemed'] as bool? ?? false,
      isSent: json['is_sent'] as bool? ?? false,
    );
  }

  /// Convert Invite to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'is_redeemed': isRedeemed,
      'is_sent': isSent,
    };
  }

  /// Create a copy of this invite with updated properties
  Invite copyWith({
    String? id,
    String? code,
    bool? isRedeemed,
    bool? isSent,
  }) {
    return Invite(
      id: id ?? this.id,
      code: code ?? this.code,
      isRedeemed: isRedeemed ?? this.isRedeemed,
      isSent: isSent ?? this.isSent,
    );
  }

  /// Whether this invite is available for use
  bool get isAvailable => !isRedeemed;

  /// Whether this invite has been shared but not yet redeemed
  bool get isPendingRedemption => isSent && !isRedeemed;

  /// Status description for UI display
  String get statusDescription {
    if (isRedeemed) {
      return 'Redeemed';
    } else if (isSent) {
      return 'Sent (pending)';
    } else {
      return 'Available';
    }
  }

  @override
  String toString() {
    return 'Invite(id: $id, code: $code, isRedeemed: $isRedeemed, isSent: $isSent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Invite &&
      other.id == id &&
      other.code == code &&
      other.isRedeemed == isRedeemed &&
      other.isSent == isSent;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      code.hashCode ^
      isRedeemed.hashCode ^
      isSent.hashCode;
  }
}