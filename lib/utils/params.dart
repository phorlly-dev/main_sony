import 'package:hashids2/hashids2.dart';
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
  try {
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
  } catch (e, st) {
    debugPrint('LogEvent failed: $e/$st');
  }
}

final _hashids = HashIds(
  salt: '2a55e369-50aa-47b6-a79b-b4e547722649',
  minHashLength: 12,
);

String encodeId(int id) => _hashids.encode([id]);

int? decodeId(String token) {
  final nums = _hashids.decode(token);
  return nums.isEmpty ? null : nums.first;
}
