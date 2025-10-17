import 'package:go_router/go_router.dart';
import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/views/export_views.dart';

class ListMenuItems extends StatelessWidget {
  final MenuItemController controller;
  final PostListController postList;

  const ListMenuItems({
    super.key,
    required this.controller,
    required this.postList,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final posts = controller.items;
      final usedSlugs = getUsedSlugs(postList, posts);

      // Only menuItems whose slug appears in posts
      final visibleMenuItems = getVisibleMenuItems(menuItems, usedSlugs);

      return Column(
        children: [
          ...visibleMenuItems.map(
            (meta) => MenuItem(
              label: meta.name.toUpperCase(),
              icon: meta.icon,
              isActive: meta.slug == controller.selectedItem.value,
              goTo: () {
                controller.setActiveMenu(meta.slug);
                postList.setActiveMenu(meta.slug);
                postList.applyFilterAndPaginate(
                  slug: meta.slug,
                  userId: 0,
                  clearSearch: true,
                );
                context.go("/view-posts/${getName(meta.name)}");
              },
            ),
          ),
        ],
      );
    });
  }
}
