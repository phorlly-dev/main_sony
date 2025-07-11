import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/menu_item_controller.dart';
import 'package:main_sony/controllers/page_controller.dart';
import 'package:main_sony/utils/params.dart';
import 'package:main_sony/views/partials/list_menu_items.dart';
import 'package:main_sony/views/partials/profile_header.dart';
import 'package:main_sony/views/screens/index.dart';
import 'package:main_sony/views/widgets/menu_item.dart';

class SideMenu extends StatelessWidget {
  final PageControllerX page;
  final MenuItemController controller;

  const SideMenu({super.key, required this.controller, required this.page});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // remove default padding
        children: [
          // Only one header at the top
          ProfileHeader(controller: page),

          MenuItem(
            label: "Home".toUpperCase(),
            isActive: controller.selectedItem.value == "home",
            goTo: () {
              controller.setActiveMenu("home");
              Get.offAll(
                () => IndexScreen(),
                duration: Duration(seconds: 1),
                curve: Curves.fastLinearToSlowEaseIn,
                arguments: ScreenParams(
                  id: 0,
                  name: "Home",
                  type: TypeParams.all,
                ),
              );
            },
            icon: Icons.home,
          ),

          ListMenuItems(controller: controller),
        ],
      ),
    );
  }
}
