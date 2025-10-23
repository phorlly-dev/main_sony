import 'package:main_sony/utils/menu_meta.dart';
import 'package:wordpress_client/wordpress_client.dart';

import 'export_controller.dart';

final class MenuItemController extends ApiProvider<Post> {
  Future<void> _getMenusItems() async {
    await preloadTaxonomies();
    await fetchList(
      callback: () => cnx.posts.list(ListPostRequest(perPage: 100)),
      append: true,
    );
    await fetchExtrasForPostIds(items.map((p) => p.id).toList());
  }

  List<MenuMeta> menuItemsForPost(Post post) {
    final ids = [...?post.categories, ...?post.tags];
    final slugs = ids
        .map((id) => categorySlugById[id] ?? tagSlugById[id])
        .whereType<String>()
        .toSet();

    return menuItems.where((m) => slugs.contains(m.slug)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _getMenusItems();
  }
}
