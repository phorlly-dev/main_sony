import 'package:flutter/material.dart';
import 'package:main_sony/controllers/category_controller.dart';
import 'package:main_sony/controllers/page_controller.dart';
import 'package:main_sony/controllers/post_controller.dart';
import 'package:main_sony/controllers/tag_controller.dart';
import 'package:main_sony/views/partials/post_card.dart';
import "package:main_sony/views/widgets/nav_bar.dart";
import 'package:main_sony/views/widgets/side_menu.dart';

class SubPostScreen extends StatelessWidget {
  final int id, type;
  final String? name;
  final PostController postController;
  final PageControllerX pageController;
  final CategoryController categoryController;
  final TagController tagController;

  const SubPostScreen({
    super.key,
    required this.id,
    required this.type,
    this.name,
    required this.postController,
    required this.pageController,
    required this.categoryController,
    required this.tagController,
  });

  @override
  Widget build(BuildContext context) {
    return NavBar(
      title: name ?? "Category",
      menu: SideMenu(
        tagController: tagController,
        postController: postController,
        categoryController: categoryController,
        controller: pageController,
      ),
      content: RefreshIndicator(
        onRefresh: postController.refreshCurrentPage,
        child: SingleChildScrollView(
          child: PostCard(controller: postController, id: id, type: type),
        ),
      ),
    );
  }
}
