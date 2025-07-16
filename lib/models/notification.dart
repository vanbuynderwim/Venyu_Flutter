import 'profile.dart';
import 'prompt.dart';
import 'match.dart';
import 'enums/notification_type.dart';

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
  
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}