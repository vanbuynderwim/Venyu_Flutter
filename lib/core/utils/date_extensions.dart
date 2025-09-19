import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Extension on DateTime to provide time-ago functionality
/// 
/// This extension provides a Flutter equivalent of the iOS Date.timeAgo() function,
/// returning short, human-readable time differences like "2h", "1d", "3mo", etc.
/// Helper function to get effective locale string with country code
String effectiveLocaleString(BuildContext context) {
  // Use Flutter's localization system - this ensures consistency
  // with what the app actually uses for localization
  final locale = Localizations.localeOf(context);
  
  // Intl expects underscore + uppercase country code
  final country = (locale.countryCode ?? '').toUpperCase();
  final result = country.isNotEmpty ? '${locale.languageCode}_$country' : locale.languageCode;

  
  return result;
}

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
  String timeAgo() {
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
      return "${years}y";
    }

    // Months (approximate: 30 days)
    else if (days >= 30) {
      final months = (days / 30).floor();
      return "${months}mo";
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
      return "${hours}h";
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
      return "Just now";
    }
  }
  
  /// Returns a full time ago string (e.g., "2 hours ago", "3 days ago")
  /// Useful when you want the full format instead of the short format
  String timeAgoFull({String locale = 'en'}) {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    // Calculate time units
    final years = difference.inDays ~/ 365;
    final months = difference.inDays ~/ 30;
    final weeks = difference.inDays ~/ 7;
    final days = difference.inDays;
    final hours = difference.inHours;
    final minutes = difference.inMinutes;
    
    // Years
    if (years > 0) {
      return '$years year${years == 1 ? '' : 's'} ago';
    }
    // Months  
    else if (months > 0) {
      return '$months month${months == 1 ? '' : 's'} ago';
    }
    // Weeks
    else if (weeks > 0) {
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    }
    // Days
    else if (days > 0) {
      return '$days day${days == 1 ? '' : 's'} ago';
    }
    // Hours
    else if (hours > 0) {
      return '$hours hour${hours == 1 ? '' : 's'} ago';
    }
    // Minutes
    else if (minutes > 0) {
      return '$minutes minute${minutes == 1 ? '' : 's'} ago';
    }
    // Just now
    else {
      return 'just now';
    }
  }

  /// Formats date as "15 Mar 2024"
  String formatDate() {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '$day ${months[month - 1]} $year';
  }

  /// Formats date using system locale format but shorter
  String formatDateShort(BuildContext context) {
    final loc = effectiveLocaleString(context);
    final full = DateFormat.yMd(loc).format(this);     // bv. 13/11/2025 of 11/13/2025
    // vervang alleen de jaartalcomponent door 2 cijfers
    final currentYear = year.toString();
    final shortYear = currentYear.substring(2);
    return full.replaceAll(currentYear, shortYear);
  }

  /// Formats date with day of week using system locale format
  String formatDateWithWeekday(BuildContext context) {
    final loc = effectiveLocaleString(context);
    return DateFormat.yMEd(loc).format(this);
  }

  /// Formats date using system locale format with full year (for event dates)
  String formatDateFull(BuildContext context) {
    final loc = effectiveLocaleString(context);
    return DateFormat.yMd(loc).format(this); // gebruikt 13/11/2025 in nl_BE
  }

  /// Formats time using system locale format (respects 24h/12h setting)
  String formatTime(BuildContext context) {
    final loc = effectiveLocaleString(context);
    return DateFormat.Hm(loc).format(this); // 19:30 in 24u-landen
  }
}