import 'export_controller.dart';
import 'package:wordpress_client/wordpress_client.dart';

class UserController extends ApiProvider<User> {
  Future<void> getUsers() async {
    await fetchList(callback: () => cnx.users.list(ListUserRequest()));
  }

  Future<void> ensureUsersForPosts(List<Post> posts) async {
    final ids = posts.map((p) => p.author).whereType<int>().toSet();
    final missing = ids.where((id) => !items.any((u) => u.id == id)).toList();
    if (missing.isNotEmpty) {
      final res = await getByIds(
        slug: 'users',
        ids: missing,
        fromJson: User.fromJson,
      );

      items.addAll(res);
    }
  }
}
