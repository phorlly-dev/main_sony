import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Post.c.dart';
import 'package:main_sony/views/partials/PostedCard.p.dart';
import 'package:main_sony/views/widgets/NavBar.w.dart';
import 'package:main_sony/views/widgets/SideMenu.w.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PostController>();

    return SafeArea(
      child: NavBar(
        title: "Main Sony",
        menu: SideMenu(title: "Home"),
        content: RefreshIndicator(
          onRefresh: () => ctrl.refreshCurrentPage(),
          child: SingleChildScrollView(child: PostedCard()),
        ),
      ),
    );
  }
}
