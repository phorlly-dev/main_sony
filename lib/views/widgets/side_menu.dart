import 'package:get/get.dart';
import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/views/export_views.dart';

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

          //AI Assistant
          MenuItem(
            label: "Chatbot".toUpperCase(),
            goTo: () {
              Get.toNamed("/ai-chatbots");
            },
            icon: Icons.chat,
          ),

          // Add more menu items as needed
          ListMenuItems(controller: controller, postList: postCtrl),
        ],
      ),
    );
  }
}
