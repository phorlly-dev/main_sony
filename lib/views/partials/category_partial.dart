import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/category_controller.dart';
import 'package:main_sony/controllers/post_controller.dart';
import 'package:main_sony/utils/params.dart';
import 'package:main_sony/utils/utility.dart';
import 'package:main_sony/views/screens/index.dart';
import 'package:main_sony/views/widgets/data_render.dart';
import 'package:main_sony/views/widgets/menu_item.dart';

class CategoryPartial extends StatelessWidget {
  final PostController postController;
  final CategoryController controller;

  const CategoryPartial({
    super.key,
    required this.controller,
    required this.postController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DataRender(
        isLoading: controller.isLoading.value,
        hasError: controller.hasError.value,
        notFound: controller.items,
        length: controller.items.length,
        child: (index) {
          final item = controller.items[index];

          return MenuItem(
            label: item.name ?? "Unknown",
            isActive: item.id == controller.selectedIndex.value,
            goTo: () {
              controller.setActiveMenu(item.id);
              Get.offAll(
                () => IndexScreen(),
                duration: Duration(milliseconds: 800),
                curve: Curves.fastLinearToSlowEaseIn,
                arguments: ScreenParams(id: item.id, name: item.name, type: 1),
              );
            },
            icon: setIcon(item.slug),
          );
        },
      );
    });
  }
}
