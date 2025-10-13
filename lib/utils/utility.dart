import 'package:wordpress_client/wordpress_client.dart';

import 'export_util.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:main_sony/controllers/export_controller.dart';

enum Type { category, tag, author }

/// Picks the best image URL from WordPress media based on device width.
String getResponsiveImageUrl(Media media) {
  final deviceWidth = Get.width;
  final sizes = media.mediaDetails?.sizes;

  // Try to match size based on device width (change breakpoints as needed)
  if (deviceWidth <= 400 && sizes?['thumbnail']?.sourceUrl != null) {
    return sizes!['thumbnail']!.sourceUrl!;
  } else if (deviceWidth <= 800 && sizes?['medium']?.sourceUrl != null) {
    return sizes!['medium']!.sourceUrl!;
  } else if (deviceWidth <= 1200 && sizes?['large']?.sourceUrl != null) {
    return sizes!['large']!.sourceUrl!;
  } else if (sizes?['full']?.sourceUrl != null) {
    return sizes!['full']!.sourceUrl!;
  } else {
    // Fallback: original source URL or empty
    return media.sourceUrl ?? '';
  }
}

/// Extracts a substring from a string, limiting the number of words.
String substr({required String key, int length = 5}) {
  final words = key.split(' ');
  final summary = words.length > length
      ? '${words.take(length).join(' ')}...'
      : key;

  return summary;
}

/// Strips HTML tags from a string and truncates it to a specified length.
String stripHtml({required String htmlText, int length = 5}) {
  final text = htmlText.replaceAll(RegExp(r'<[^>]*>'), '');

  return truncateWithEllipsis(text, length);
}

// Unescapes HTML entities and removes HTML tags from a string.
String stripHtmls(String raw) {
  // Remove HTML tags
  final withoutTags = raw.replaceAll(RegExp(r'<[^>]*>'), '');

  // Decode HTML entities
  return unescape(withoutTags).trim();
}

/// Truncates a string to a specified length and adds ellipsis if needed.
String truncateWithEllipsis(String text, int maxChars) {
  if (text.length <= maxChars) return text;

  return '${text.substring(0, maxChars)}... ';
}

/// Formats a date to a string based on the provided format or defaults to 'd MMMM yyyy'.
String dateStr({required DateTime date, String? format}) {
  final now = DateTime.now();
  if (date.year == now.year) {
    return timeago.format(date);
  }

  return DateFormat(format ?? 'd MMMM yyyy').format(date);
}

/// Retrieves a value from a map or returns "Unknown" if the key is not present.
Object getValue({Map<String, dynamic>? object, required String key}) {
  return object?[key] ?? "Unknown";
}

/// Unescapes HTML entities in a string.
String unescape(String input) {
  return HtmlUnescape().convert(input);
}

/// Extracts menu labels from a list of class names, converting them to uppercase.
List<String> extractMenuLabels(List<String> classList) {
  final labels = <String>[];

  for (final item in classList) {
    if (item.startsWith("category-")) {
      final label = item.substring("category-".length).replaceAll('-', ' ');
      labels.add(label.toUpperCase());
    } else if (item.startsWith("tag-")) {
      final label = item.substring("tag-".length).replaceAll('-', ' ');
      labels.add(label.toUpperCase());
    }
  }
  return labels;
}
