import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wordpress_client/wordpress_client.dart';

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

/// Sets the icon and name based on the provided item slug.
List<Object> setIcon(String item) {
  final listIcons = [
    //category
    {"slug": "android", "name": "Android", 'icon': Icons.android},
    {"slug": "arcade", "name": "Arcade", 'icon': Icons.games_outlined},
    {"slug": "berita", "name": "Berita", 'icon': Icons.info},
    {"slug": "pc", "name": "PC", 'icon': Icons.computer_rounded},

    //tag
    {"slug": "steam", "name": "Steam", 'icon': Icons.gite_rounded},
    {
      "slug": "genshin-impact",
      "name": "Genshin Impact",
      'icon': Icons.grid_goldenratio_rounded,
    },
    {
      "slug": "roblox",
      "name": "Roblox",
      'icon': Icons.confirmation_num_rounded,
    },
    {"slug": "pubg", "name": "Pubg", 'icon': Icons.gas_meter_rounded},
    {
      "slug": "mlbb",
      "name": "Mobile Legends",
      'icon': Icons.security_update_warning_rounded,
    },
  ];

  IconData icon = Icons.apps_rounded;
  String name = "";

  for (var i in listIcons) {
    if (i['slug'] == item.toLowerCase()) {
      icon = i['icon'] as IconData;
      name = i['name'] as String;
      break;
    }
  }

  return [icon, name];
}

/// Formats a date to a string based on the provided format or defaults to 'd MMMM yyyy'.
String dateStr({required DateTime date, String? format}) {
  return DateFormat(format ?? 'd MMMM yyyy').format(date);
}

/// Retrieves a value from a map or returns "Unknown" if the key is not present.
Object getValue({Map<String, dynamic>? object, required String key}) {
  return object?[key] ?? "Unknown";
}

/// Displays a loading overlay while executing a fetcher function.
Future<T> withLoadingOverlay<T>(Future<T> Function() fetcher) async {
  // Show blocking overlay
  Get.dialog(
    Center(
      child: LoadingAnimationWidget.threeArchedCircle(
        color: Colors.lightBlue,
        size: 50,
      ),
    ),
    barrierDismissible: false,
  );

  try {
    final result = await fetcher();
    Get.back(); // Remove overlay
    return result;
  } catch (e) {
    Get.back();
    rethrow;
  }
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
