import 'package:flutter/material.dart';
import 'package:wordpress_client/wordpress_client.dart';

class MenuMeta {
  final IconData icon;
  final String name;
  final String slug;

  const MenuMeta({required this.slug, required this.name, required this.icon});
}

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
  MenuMeta(slug: "pubg", name: "Pubg", icon: Icons.gas_meter_rounded),
  MenuMeta(
    slug: "mlbb",
    name: "Mobile Legends",
    icon: Icons.security_update_warning_rounded,
  ),
];

Set<String> getUsedSlugs(List<Post> posts) {
  final slugs = <String>{};
  for (final post in posts) {
    final classList = post.classList ?? [];
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

List<MenuMeta> getVisibleMenuItems(List<MenuMeta> all, Set<String> usedSlugs) {
  return all.where((meta) => usedSlugs.contains(meta.slug)).toList();
}
