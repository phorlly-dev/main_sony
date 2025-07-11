import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/menu_item_controller.dart';
import 'package:main_sony/controllers/page_controller.dart';
import 'package:main_sony/controllers/post_controller.dart';
import 'package:main_sony/utils/params.dart';
import 'package:main_sony/views/screens/home.dart';
import 'package:main_sony/views/screens/sub_post.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  //controller
  late final PostController post;
  late final MenuItemController menuItem;
  late final PageControllerX page;
  late final ScreenParams params;

  @override
  void initState() {
    super.initState();
    //get arguments
    final args = Get.arguments;
    params = args is ScreenParams
        ? args
        : const ScreenParams(id: 0, name: "Home", type: TypeParams.all);

    //controller
    post = Get.find<PostController>();
    page = Get.find<PageControllerX>();
    menuItem = Get.find<MenuItemController>();
  }

  @override
  Widget build(BuildContext context) {
    if (params.type == TypeParams.all) {
      return SafeArea(
        child: HomeScreen(
          id: params.id,
          type: params.type,
          controller: post,
          page: page,
          menuItem: menuItem,
        ),
      );
    }

    return SafeArea(
      child: SubPostScreen(
        id: params.id,
        type: params.type,
        controller: post,
        page: page,
        menuItem: menuItem,
      ),
    );
  }
}
