/// Extension on DateTime to provide time-ago functionality
/// 
/// This extension provides a Flutter equivalent of the iOS Date.timeAgo() function,
/// returning short, human-readable time differences like "2h", "1d", "3mo", etc.
extension DateTimeExtensions on DateTime {
  /// Returns a short string representation of how long ago this date was compared to now.
  /// 
  /// Examples:
  /// - "2y" for 2 years ago
  /// - "3mo" for 3 months ago  
  /// - "1w" for 1 week ago
  /// - "5d" for 5 days ago
  /// - "2h" for 2 hours ago
  /// - "30m" for 30 minutes ago
  /// - "45s" for 45 seconds ago
  /// - "Now" for less than 3 seconds ago
  String timeAgo({String locale = 'en'}) {
    final now = DateTime.now();
    final difference = now.difference(this);

    // Calculate components similar to iOS Calendar.dateComponents
    final days = difference.inDays;
    final hours = difference.inHours;
    final minutes = difference.inMinutes;
    final seconds = difference.inSeconds;

    // Years (approximate: 365 days)
    if (days >= 365) {
      final years = (days / 365).floor();
      return locale == 'nl' ? "${years}j" : "${years}y";
    }
    
    // Months (approximate: 30 days)
    else if (days >= 30) {
      final months = (days / 30).floor();
      return locale == 'nl' ? "${months}mnd" : "${months}mo";
    }
    
    // Weeks
    else if (days >= 7) {
      final weeks = (days / 7).floor();
      return "${weeks}w";
    }
    
    // Days
    else if (days >= 1) {
      return "${days}d";
    }
    
    // Hours
    else if (hours >= 1) {
      return locale == 'nl' ? "${hours}u" : "${hours}h";
    }
    
    // Minutes
    else if (minutes >= 1) {
      return "${minutes}m";
    }
    
    // Seconds (only show if >= 3 seconds)
    else if (seconds >= 3) {
      return "${seconds}s";
    }
    
    // Less than 3 seconds
    else {
      return locale == 'nl' ? "Nu" : "Now";
    }
  }
  
  /// Returns a full time ago string (e.g., "2 hours ago", "3 days ago")
  /// Useful when you want the full format instead of the short format
  String timeAgoFull({String locale = 'en'}) {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'just now';
    }
  }
}