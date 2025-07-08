import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/category_controller.dart';
import 'package:main_sony/utils/utility.dart';
import 'package:main_sony/views/screens/home.dart';
import 'package:main_sony/views/widgets/data_render.dart';
import 'package:main_sony/views/widgets/menu_item.dart';

class CategoryPartial extends StatelessWidget {
  final CategoryController controller;

  const CategoryPartial({super.key, required this.controller});

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
          if (Get.currentRoute == "/home") controller.selectedIndex.value = 0;

          return MenuItem(
            label: item.name ?? "Unknown",
            isActive: item.id == controller.selectedIndex.value,
            goTo: () {
              controller.selectedIndex.value = item.id;
              Get.offAll(
                () => HomeScreen(
                  id: item.id,
                  name: item.name ?? "Unknown",
                  type: 1,
                ),
              );
            },
            icon: setIcon(item.slug),
          );
        },
      );
    });
  }
}
