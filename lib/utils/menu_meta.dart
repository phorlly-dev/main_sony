import 'package:main_sony/controllers/export_controller.dart';
import 'package:wordpress_client/wordpress_client.dart';

import 'export_util.dart';

/// Represents metadata for menu items, including icon, name, and slug.
class MenuMeta {
  final IconData icon;
  final String name;
  final String slug;

  const MenuMeta({required this.slug, required this.name, required this.icon});
}

/// A predefined list of menu items with their respective slugs, names, and icons.
final List<MenuMeta> menuItems = [
  // category
  MenuMeta(slug: "android", name: "Android", icon: Icons.android),
  MenuMeta(slug: "arcade", name: "Arcade", icon: Icons.games_outlined),
  MenuMeta(slug: "berita", name: "Berita", icon: Icons.info),
  MenuMeta(slug: "pc", name: "PC", icon: Icons.computer_rounded),

  // tag
  MenuMeta(slug: "steam", name: "Steam", icon: Icons.gite_rounded),
  MenuMeta(
    slug: "genshin-impact",
    name: "Genshin Impact",
    icon: Icons.grid_goldenratio_rounded,
  ),
  MenuMeta(
    slug: "roblox",
    name: "Roblox",
    icon: Icons.confirmation_num_rounded,
  ),
  MenuMeta(slug: "pubg", name: "PUBG", icon: Icons.gas_meter_rounded),
  MenuMeta(
    slug: "mlbb",
    name: "Mobile Legends",
    icon: Icons.security_update_warning_rounded,
  ),
];

/// Retrieves a MenuMeta object based on the provided slug.
MenuMeta getMenuMeta(String slug) {
  return menuItems.firstWhere(
    (meta) => meta.slug == slug.toLowerCase(),
    orElse: () => MenuMeta(
      slug: slug,
      name:
          slug[0].toUpperCase() +
          slug.substring(1), // Default to capitalized slug
      icon: Icons.apps_rounded,
    ),
  );
}

/// Retrieves a list of MenuMeta objects based on the provided slugs.
Set<String> getUsedSlugs(MenuItemController controller, List<Post> posts) {
  final slugs = <String>{};
  for (final post in posts) {
    // final classList = post.classList ?? [];
    final classList = controller.classListFor(post.id);
    for (final c in classList) {
      // Match both 'category-' and 'tag-' (adjust as needed)
      if (c.startsWith('category-')) {
        slugs.add(c.replaceFirst('category-', ''));
      }
      if (c.startsWith('tag-')) {
        slugs.add(c.replaceFirst('tag-', ''));
      }
    }
  }
  return slugs;
}

/// Filters the menu items based on the provided slugs.
List<MenuMeta> getVisibleMenuItems(List<MenuMeta> all, Set<String> usedSlugs) {
  return all.where((meta) => usedSlugs.contains(meta.slug)).toList();
}
