import 'package:get/get.dart';
import '../export_views.dart';
import '../../controllers/export_controller.dart';

class SideMenu extends StatelessWidget {
  final PageControllerX page;
  final MenuItemController controller;

  const SideMenu({super.key, required this.controller, required this.page});

  @override
  Widget build(BuildContext context) {
    // Ensure the PostListController is available
    final postCtrl = Get.find<PostListController>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // remove default padding
        children: [
          // Only one header at the top
          ProfileHeader(controller: page),

          // Home menu item
          MenuItem(
            label: "Home".toUpperCase(),
            isActive: controller.selectedItem.value == "home",
            goTo: () {
              controller.setActiveMenu("home");
              postCtrl.applyFilterAndPaginate(slug: '');
              Get.offAndToNamed(
                "/view-posts",
                arguments: ScreenParams(name: "Home"),
              );
            },
            icon: Icons.home,
          ),

          // Add more menu items as needed
          ListMenuItems(controller: controller, postList: postCtrl),
        ],
      ),
    );
  }
}
