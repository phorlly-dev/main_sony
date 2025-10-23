import 'package:wordpress_client/wordpress_client.dart';
import 'export_controller.dart';

class MediaController extends ApiProvider<Media> {
  Future<void> getMedia() async {
    await fetchList(callback: () => cnx.media.list(ListMediaRequest()));
  }

  Future<void> ensureMediaForPosts(List<Post> posts) async {
    final ids = posts.map((p) => p.featuredMedia).whereType<int>().toSet();
    final missing = ids.where((id) => !items.any((u) => u.id == id)).toList();
    if (missing.isNotEmpty) {
      final res = await getByIds(
        slug: 'media',
        ids: missing,
        fromJson: Media.fromJson,
      );

      items.assignAll(res);
    }
  }
}
