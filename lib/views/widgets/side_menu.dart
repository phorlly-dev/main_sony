import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/category_controller.dart';
import 'package:main_sony/controllers/page_controller.dart';
import 'package:main_sony/controllers/post_controller.dart';
import 'package:main_sony/controllers/tag_controller.dart';
import 'package:main_sony/utils/params.dart';
import 'package:main_sony/views/partials/category_partial.dart';
import 'package:main_sony/views/partials/profile_header.dart';
import 'package:main_sony/views/partials/tag_partial.dart';
import 'package:main_sony/views/screens/index.dart';
import 'package:main_sony/views/widgets/menu_item.dart';

class SideMenu extends StatelessWidget {
  final PageControllerX controller;
  final CategoryController categoryController;
  final PostController postController;
  final TagController tagController;

  const SideMenu({
    super.key,
    required this.controller,
    required this.categoryController,
    required this.postController,
    required this.tagController,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // remove default padding
        children: [
          // Only one header at the top
          ProfileHeader(controller: controller),

          MenuItem(
            label: "Home",
            isActive: categoryController.selectedIndex.value == 0,
            goTo: () {
              categoryController.setActiveMenu(0);
              Get.offAll(
                () => IndexScreen(),
                duration: Duration(seconds: 1),
                curve: Curves.fastLinearToSlowEaseIn,
                arguments: ScreenParams(id: 0, name: "Home", type: 0),
              );
            },
            icon: Icons.home,
          ),

          //Menu item list by categories
          CategoryPartial(
            controller: categoryController,
            postController: postController,
          ),

          //Menu item list by tags
          TagPartial(controller: tagController, postController: postController),
        ],
      ),
    );
  }
}
