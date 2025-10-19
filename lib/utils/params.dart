import 'package:main_sony/views/export_views.dart';

enum TypeParams { all, category, tag, author, classList }

class Params {
  final int? id;
  final String name, src, camp, path;

  const Params({
    this.id,
    required this.name,
    required this.src,
    required this.camp,
    required this.path,
  });
}

class SlideItem {
  final String imageUrl;
  final String title;
  final String date;

  SlideItem({required this.imageUrl, required this.title, required this.date});
}

Future<void> linkUrl(String url) async {
  final uri = Uri.parse(url);

  // Try to launch the URL, show snackbar on error
  if (!await launchUrl(uri)) {
    Get.snackbar("Error happen!", 'Could not launch $url');
  }
}

Future<void> setLogEvent(Params prams) async {
  final path = prams.path;
  final name = prams.name;
  final src = prams.src;
  final camp = prams.camp;

  await analytics.setAnalyticsCollectionEnabled(true);
  await analytics.logEvent(
    name: 'pages_tracked',
    parameters: {
      'path': path,
      'name': name,
      'utm_source': src,
      'utm_campaign': camp,
    },
  );
}
