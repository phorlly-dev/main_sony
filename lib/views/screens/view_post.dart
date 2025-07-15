import 'package:get/get.dart';
import '../../controllers/export_controller.dart';
import '../export_views.dart';

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
        NavBar(
          title: name,
          onSearch: (query) => controller.search(query),
          menu: SideMenu(controller: menuItem, page: page),
          content: Obx(() {
            final sliders = imageSlider.sliderItems;
            return RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  controller.refreshCurrentPage(),
                  imageSlider.fetchSliderItems(),
                ]);
              },
              child: Column(
                children: [
                  ImageBanner(),
                  (sliders.isEmpty || name != "Home")
                      ? SizedBox.shrink()
                      : ImageSlider(items: sliders),
                  PostCard(controller: controller),
                ],
              ),
            );
          }),
        ),

        ConnectionOverlay(),
      ],
    );
  }
}
