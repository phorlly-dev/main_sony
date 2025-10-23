import 'package:go_router/go_router.dart';
import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/utils/theme_manager.dart';
import 'package:main_sony/views/export_views.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  final PageControllerX page;
  final MenuItemController controller;

  const SideMenu({super.key, required this.controller, required this.page});

  @override
  Widget build(BuildContext context) {
    // Ensure the PostListController is available
    final postCtrl = Get.find<PostController>();

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- TOP (fixed) ---
            ProfileHeader(controller: page),

            // --- MIDDLE (scrollable) ---
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero, // remove default padding
                children: [
                  MenuItem(
                    label: "Home".toUpperCase(),
                    isActive: controller.selectedItem.value == "home",
                    goTo: () async {
                      controller.setActiveMenu("home");
                      postCtrl.setActiveMenu("home");
                      postCtrl.applyFilter(
                        slug: '',
                        userId: 0,
                        clearSearch: true,
                      );
                      final name = 'home';
                      final uri = Uri(
                        path: '/posts/$name',
                        queryParameters: {
                          'src': 'in-app-menu',
                          'camp': 'home-page',
                        },
                      );
                      context.go(uri.toString());
                      await setLogEvent(
                        Params(
                          name: name,
                          src: 'in-app-menu',
                          camp: 'home-page',
                          path: uri.path,
                        ),
                      );
                    },
                    icon: Icons.home,
                  ),

                  //AI Assistant
                  // MenuItem(
                  //   label: "Chatbot".toUpperCase(),
                  //   goTo: () {
                  //     Get.toNamed("/ai-chatbots");
                  //   },
                  //   icon: Icons.chat,
                  // ),

                  // Your dynamic items
                  ListMenuItems(controller: controller, postList: postCtrl),
                ],
              ),
            ),

            // --- BOTTOM (fixed / sticky) ---
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Theme',
                    icon: Icon(
                      Theme.of(context).brightness == Brightness.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                    onPressed: () {
                      context.read<ThemeManager>().toggleTheme(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.settings),
                      label: const Text('Settings'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.pushNamed('settings');
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Keep bottom inset safe
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
