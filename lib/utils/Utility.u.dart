import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordpress_client/wordpress_client.dart';

/// Picks the best image URL from WordPress media based on device width.
String getResponsiveImageUrl(Media media) {
  final deviceWidth = Get.width;

  // Try to match size based on device width (change breakpoints as needed)
  if (deviceWidth <= 400 &&
      media.mediaDetails?.sizes?['thumbnail']?.sourceUrl != null) {
    return media.mediaDetails!.sizes!['thumbnail']!.sourceUrl!;
  } else if (deviceWidth <= 800 &&
      media.mediaDetails?.sizes?['medium']?.sourceUrl != null) {
    return media.mediaDetails!.sizes!['medium']!.sourceUrl!;
  } else if (deviceWidth <= 1200 &&
      media.mediaDetails?.sizes?['large']?.sourceUrl != null) {
    return media.mediaDetails!.sizes!['large']!.sourceUrl!;
  } else if (media.mediaDetails?.sizes?['full']?.sourceUrl != null) {
    return media.mediaDetails!.sizes!['full']!.sourceUrl!;
  } else {
    // Fallback: original source URL or empty
    return media.sourceUrl ?? '';
  }
}

String substr({required String key, int length = 5}) {
  final words = key.split(' ');
  final summary = words.length > length
      ? '${words.take(length).join(' ')}...'
      : key;

  return summary;
}

String stripHtml(String htmlText) {
  return htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
}

IconData setIcon(String item) {
  final listIcons = [
    {"name": "android", 'icon': Icons.android},
    {"name": "arcade", 'icon': Icons.games_outlined},
    {"name": "berita", 'icon': Icons.info},
    {"name": "opini", 'icon': Icons.comment_rounded},
    {"name": "pc", 'icon': Icons.computer_rounded},
  ];

  IconData icon = Icons.apps_rounded;

  for (var i in listIcons) {
    if (i['name'] == item.toLowerCase()) {
      icon = i['icon'] as IconData;
      break;
    }
  }

  return icon;
}
