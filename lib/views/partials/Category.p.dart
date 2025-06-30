import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Category.c.dart';

class CategoryPartial extends StatelessWidget {
  final int? id;
  const CategoryPartial({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CategoryController>();

    return Obx(() {
      if (ctrl.categories.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      // return Column(
      //   children: ctrl.categories.map((items) {
      //     return ListTileNavigate(
      //       label: items.name ?? 'Unknown',
      //       icon: setIcon(items.slug ?? ''),
      //       active: id == items.id,
      //       destination: CategoryScreen(
      //         title: items.name ?? "Category",
      //         id: items.id,
      //       ),
      //     );
      //   }).toList(),
      // );
      return const SizedBox.shrink();
    });
  }
}
