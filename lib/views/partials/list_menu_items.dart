import 'package:go_router/go_router.dart';
import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/views/export_views.dart';

class ListMenuItems extends StatelessWidget {
  final MenuItemController controller;
  final PostController postList;

  const ListMenuItems({
    super.key,
    required this.controller,
    required this.postList,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final seen = <String>{};
      final visibleMenuItems = controller.items.expand((post) {
        return controller
            .menuItemsForPost(post)
            .where((meta) => seen.add(meta.slug));
      }).toList();

      return Column(
        children: [
          ...visibleMenuItems.map((meta) {
            return MenuItem(
              label: meta.name.toUpperCase(),
              icon: meta.icon,
              isActive: meta.slug == controller.selectedItem.value,
              goTo: () async {
                controller.setActiveMenu(meta.slug);
                postList.setActiveMenu(meta.slug);
                postList.applyFilter(
                  slug: meta.slug,
                  userId: 0,
                  clearSearch: true,
                );

                final name = getName(meta.name);
                final uri = Uri(
                  path: '/posts/$name',
                  queryParameters: {'src': prefix(name), 'camp': subfix(name)},
                );
                context.go(uri.toString());

                // Fire and forget logging
                unawaited(
                  setLogEvent(
                    Params(
                      name: name,
                      src: prefix(name),
                      camp: subfix(name),
                      path: uri.path,
                    ),
                  ),
                );
              },
            );
          }),
        ],
      );
    });
  }
}
