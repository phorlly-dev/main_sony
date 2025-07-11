import 'package:flutter/material.dart';
import 'package:main_sony/controllers/menu_item_controller.dart';
import 'package:main_sony/controllers/page_controller.dart';
import 'package:main_sony/controllers/post_controller.dart';
import 'package:main_sony/utils/params.dart';
import 'package:main_sony/views/partials/post_card.dart';
import "package:main_sony/views/widgets/nav_bar.dart";
import 'package:main_sony/views/widgets/side_menu.dart';

class HomeScreen extends StatelessWidget {
  final int id;
  final TypeParams type;
  final String? name;
  final PostController controller;
  final PageControllerX page;
  final MenuItemController menuItem;

  const HomeScreen({
    super.key,
    this.name,
    required this.id,
    required this.type,
    required this.controller,
    required this.page,
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    return NavBar(
      title: name ?? "Home",
      menu: SideMenu(controller: menuItem, page: page),
      content: RefreshIndicator(
        onRefresh: controller.refreshCurrentPage,
        child: SingleChildScrollView(
          child: PostCard(controller: controller, id: id, type: type),
        ),
      ),
    );
  }
}
