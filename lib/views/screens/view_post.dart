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
            onSearch: (query) async {
              controller.search(query);
              await analytics.logSearch(
                searchTerm: query,
                startDate: DateTime.now().toIso8601String(),
                endDate: DateTime.now()
                    .add(const Duration(minutes: 30))
                    .toIso8601String(),
              );
            },
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
                            final id = imageSlider.postId.value.toString();
                            final name = getName(controller.selectedItem.value);

                            context.pushNamed<Post>(
                              'post_details',
                              pathParameters: {'id': id, 'name': name},
                              queryParameters: {
                                'src': 'post-$name-details',
                                'camp': 'from-image-banner',
                              },
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
