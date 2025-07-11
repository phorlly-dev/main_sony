import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/menu_item_controller.dart';
import 'package:main_sony/utils/menu_meta.dart';
import 'package:main_sony/utils/params.dart';
import 'package:main_sony/views/screens/index.dart';
import 'package:main_sony/views/widgets/menu_item.dart';

class ListMenuItems extends StatelessWidget {
  final MenuItemController controller;
  const ListMenuItems({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final posts = controller.items;
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
                Get.offAll(
                  () => IndexScreen(),
                  duration: Duration(milliseconds: 800),
                  curve: Curves.fastLinearToSlowEaseIn,
                  arguments: ScreenParams(
                    id: meta.slug.hashCode,
                    name: meta.name,
                    type: TypeParams.category, // Or TypeParams.tag, if you wish
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
