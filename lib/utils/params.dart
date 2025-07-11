enum TypeParams { all, category, tag, author, classList }

class ScreenParams {
  final int id;
  final TypeParams type;
  final String? name;

  const ScreenParams({required this.id, this.name, this.type = TypeParams.all});
}
