import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/menu_item_controller.dart';
import 'package:main_sony/controllers/post_list_controller.dart';
import 'package:main_sony/utils/menu_meta.dart';
import 'package:main_sony/utils/params.dart';
import 'package:main_sony/views/widgets/menu_item.dart';

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

      // for (final val in posts) {
      //   log("The Items: ${val.classList}");
      // }

      final usedSlugs = getUsedSlugs(posts);

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
                postList.applyFilterAndPaginate(slug: meta.slug);
                Get.offAndToNamed(
                  "/view-posts",
                  arguments: ScreenParams(name: meta.name),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
