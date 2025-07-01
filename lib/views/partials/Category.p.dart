import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Category.c.dart';
import 'package:main_sony/utils/Utility.u.dart';
import 'package:main_sony/views/screens/Home.s.dart';
import 'package:main_sony/views/widgets/DataRender.w.dart';
import 'package:main_sony/views/widgets/MenuItem.w.dart';

class CategoryPartial extends StatelessWidget {
  const CategoryPartial({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CategoryController>();

    return Obx(() {
      return DataRender(
        isLoading: ctrl.isLoading.value,
        hasError: ctrl.hasError.value,
        notFound: ctrl.categories,
        length: ctrl.categories.length,
        child: (index) {
          final item = ctrl.categories[index];

          return MenuItem(
            label: item.name ?? "Unknown",
            isActive: index == ctrl.selectedIndex,
            desination: HomeScreen(),
            icon: setIcon(item.slug),
          );
        },
      );
    });
  }
}
