import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Category.c.dart';
import 'package:main_sony/controllers/Page.c.dart';
import 'package:main_sony/controllers/Post.c.dart';
import 'package:main_sony/views/partials/PostByCategoryCard.p.dart';
import 'package:main_sony/views/widgets/NavBar.w.dart';
import 'package:main_sony/views/widgets/SideMenu.w.dart';

class ViewByCategory extends StatelessWidget {
  final int id;
  final String name;

  const ViewByCategory({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    final post = Get.find<PostController>();
    final category = Get.find<CategoryController>();
    final page = Get.find<PageControllerX>();

    return SafeArea(
      child: NavBar(
        title: name,
        menu: SideMenu(category: category, page: page),
        content: RefreshIndicator(
          onRefresh: () => post.fetchItemsByCategory(id),
          child: SingleChildScrollView(
            child: PostByCategoryCard(controller: post, id: id),
          ),
        ),
      ),
    );
  }
}
