enum NotificationTarget {
  email('email'),
  push('push');

  const NotificationTarget(this.value);

  final String value;

  static NotificationTarget fromJson(String value) {
    return NotificationTarget.values.firstWhere(
      (target) => target.value == value,
      orElse: () => NotificationTarget.push,
    );
  }

  String toJson() => value;
}
