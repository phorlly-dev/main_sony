import 'package:go_router/go_router.dart';
import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/views/export_views.dart';
import 'package:wordpress_client/wordpress_client.dart' show Post;

class ViewPostScreen extends StatelessWidget {
  final String name;
  final PostListController controller;
  final PageControllerX page;
  final MenuItemController menuItem;
  final ImageSliderController imageSlider;

  const ViewPostScreen({
    super.key,
    required this.name,
    required this.controller,
    required this.page,
    required this.menuItem,
    required this.imageSlider,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BodyContent(
          header: NavBar(
            title: name,
            onSearch: (query) => controller.search(query),
          ),
          menu: SideMenu(controller: menuItem, page: page),
          content: RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                controller.refreshCurrentPage(),
                imageSlider.fetchSliderItems(),
              ]);
            },
            child: Obx(() {
              final sliders = imageSlider.sliderItems;
              return ListView(
                children: [
                  // ImageBanner(),
                  (sliders.isEmpty || name != "home")
                      ? SizedBox.shrink()
                      : ImageSlider(
                          items: sliders,
                          onTap: () async {
                            // Navigate to the post detail screen
                            context.pushNamed<Post>(
                              'details',
                              pathParameters: {
                                'id': imageSlider.postId.value.toString(),
                                'name': getName(controller.selectedItem.value),
                              },
                              extra: controller,
                            );
                          },
                        ),
                  PostCard(
                    controller: controller,
                    name: controller.selectedItem.value,
                  ),
                ],
              );
            }),
          ),
        ),

        ConnectionOverlay(),
      ],
    );
  }
}
