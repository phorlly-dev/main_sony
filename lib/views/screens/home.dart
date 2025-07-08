import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/category_controller.dart';
import 'package:main_sony/controllers/page_controller.dart';
import 'package:main_sony/controllers/post_controller.dart';
import 'package:main_sony/views/partials/post_card.dart';
import "package:main_sony/views/widgets/nav_bar.dart";
import 'package:main_sony/views/widgets/side_menu.dart';

class HomeScreen extends StatelessWidget {
  final int id, type;
  final String name;

  const HomeScreen({
    super.key,
    required this.id,
    required this.type,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final post = Get.find<PostController>();
    final category = Get.find<CategoryController>();
    final page = Get.find<PageControllerX>();

    return NavBar(
      title: name,
      menu: SideMenu(category: category, page: page),
      content: RefreshIndicator(
        onRefresh: post.refreshCurrentPage,
        child: SingleChildScrollView(
          child: PostCard(controller: post, id: id, type: type),
        ),
      ),
    );
  }
}
