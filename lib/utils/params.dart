import 'package:main_sony/views/export_views.dart';

enum TypeParams { all, category, tag, author, classList }

class ScreenParams {
  final String name;

  const ScreenParams({required this.name});
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
