import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/category_controller.dart';
import 'package:main_sony/controllers/page_controller.dart';
import 'package:main_sony/views/partials/category_partial.dart';
import 'package:main_sony/views/partials/profile_header.dart';
import 'package:main_sony/views/widgets/menu_item.dart';

class SideMenu extends StatelessWidget {
  final PageControllerX page;
  final CategoryController category;

  const SideMenu({super.key, required this.category, required this.page});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // remove default padding
        children: [
          // Only one header at the top
          ProfileHeader(controller: page),

          MenuItem(
            label: "Home",
            isActive: Get.currentRoute == "/home",
            goTo: () => Get.toNamed('/home'),
            icon: Icons.home,
          ),

          //Menu item list
          CategoryPartial(controller: category),
        ],
      ),
    );
  }
}
