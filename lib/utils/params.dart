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
