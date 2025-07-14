import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/image_slider_controller.dart';
import 'package:main_sony/controllers/menu_item_controller.dart';
import 'package:main_sony/controllers/page_controller.dart';
import 'package:main_sony/controllers/post_list_controller.dart';
import 'package:main_sony/views/partials/post_card.dart';
import 'package:main_sony/views/widgets/connection_overlay.dart';
import 'package:main_sony/views/widgets/image_slider.dart';
import "package:main_sony/views/widgets/nav_bar.dart";
import 'package:main_sony/views/widgets/side_menu.dart';

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
