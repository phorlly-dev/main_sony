import 'package:main_sony/views/export_views.dart';
import 'package:wordpress_client/wordpress_client.dart';

class TaxonomyMeta {
  final List<int> categoryIds, tagIds;

  TaxonomyMeta({required this.categoryIds, required this.tagIds});
}

TaxonomyMeta extractCategoriesAndTagsFromPost(Post post) {
  final cats = post.categories ?? <int>[];
  final tags = post.tags ?? <int>[];

  return TaxonomyMeta(categoryIds: cats, tagIds: tags);
}

List<MenuMeta> getByIds(List<int> ids) {
  // Known items only
  final known = menuItems.where((m) => ids.contains(m.id)).toList();

  // ✅ No fallback creation; just return known matches
  return known;
}
