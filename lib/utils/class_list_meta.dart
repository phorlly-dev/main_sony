import 'export_util.dart';

// Represents metadata extracted from class lists, specifically categories and tags.
class ClassListMeta {
  final List<String> categories, tags;

  ClassListMeta({required this.categories, required this.tags});
}

/// Extracts categories and tags from a list of class names.
ClassListMeta extractCategoriesAndTags(List<String> classList) {
  final cats = <String>[];
  final tags = <String>[];
  for (final item in classList) {
    if (item.startsWith('category-')) {
      cats.add(item.replaceFirst('category-', ''));
    } else if (item.startsWith('tag-')) {
      tags.add(item.replaceFirst('tag-', ''));
    }
  }

  return ClassListMeta(categories: cats, tags: tags);
}

/// Converts a list of slugs into a list of MenuMeta objects.
List<MenuMeta> getMenuMetaList(List<String> slugs) {
  return slugs.map((slug) => getMenuMeta(slug)).toList();
}
