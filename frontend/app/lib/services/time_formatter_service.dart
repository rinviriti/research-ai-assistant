class TimeFormatterService {
  static String format(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    }

    if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    }

    if (difference.inDays == 1) {
      return "Yesterday";
    }

    if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    }

    return "${time.day}/${time.month}/${time.year}";
  }

  static DateTime parse(dynamic value) {
    if (value is DateTime) return value;

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }
}
