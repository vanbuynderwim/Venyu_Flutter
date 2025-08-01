import 'profile.dart';
import 'prompt.dart';
import 'match.dart';
import 'enums/notification_type.dart';
import '../core/utils/date_extensions.dart';

class Notification {
  final String id;
  final Profile? sender;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime? openedAt;
  final Prompt? prompt;
  final Match? match;

  const Notification({
    required this.id,
    this.sender,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.openedAt,
    this.prompt,
    this.match,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      sender: json['sender'] != null ? Profile.fromJson(json['sender']) : null,
      type: NotificationType.fromJson(json['type']),
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['created_at']),
      openedAt: json['opened_at'] != null ? DateTime.parse(json['opened_at']) : null,
      prompt: json['prompt'] != null ? Prompt.fromJson(json['prompt']) : null,
      match: json['match'] != null ? Match.fromJson(json['match']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender?.toJson(),
      'type': type.toJson(),
      'title': title,
      'body': body,
      'created_at': createdAt.toIso8601String(),
      'opened_at': openedAt?.toIso8601String(),
      'prompt': prompt?.toJson(),
      'match': match?.toJson(),
    };
  }

  // Helper methods
  bool get isRead => openedAt != null;
  bool get isUnread => !isRead;
  
  String get timeAgo => createdAt.timeAgo();
}