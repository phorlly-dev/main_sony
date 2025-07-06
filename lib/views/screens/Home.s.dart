import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Category.c.dart';
import 'package:main_sony/controllers/Page.c.dart';
import 'package:main_sony/controllers/Post.c.dart';
import 'package:main_sony/views/partials/PostCard.p.dart';
import 'package:main_sony/views/widgets/NavBar.w.dart';
import 'package:main_sony/views/widgets/SideMenu.w.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = Get.find<PostController>();
    final category = Get.find<CategoryController>();
    final page = Get.find<PageControllerX>();

    return SafeArea(
      child: NavBar(
        title: "Main Sony",
        menu: SideMenu(category: category, page: page, title: "Home"),
        content: RefreshIndicator(
          onRefresh: () => post.refreshCurrentPage(),
          child: SingleChildScrollView(child: PostCard(controller: post)),
        ),
      ),
    );
  }
}
