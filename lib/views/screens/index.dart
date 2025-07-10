import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/category_controller.dart';
import 'package:main_sony/controllers/page_controller.dart';
import 'package:main_sony/controllers/post_controller.dart';
import 'package:main_sony/controllers/tag_controller.dart';
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
  late final CategoryController category;
  late final PageControllerX page;
  late final TagController tag;
  late final ScreenParams params;

  @override
  void initState() {
    super.initState();
    //get arguments
    final args = Get.arguments;
    params = args is ScreenParams
        ? args
        : const ScreenParams(id: 0, name: "Home", type: 0);

    //controller
    post = Get.find<PostController>();
    category = Get.find<CategoryController>();
    page = Get.find<PageControllerX>();
    tag = Get.find<TagController>();
  }

  @override
  Widget build(BuildContext context) {
    if (params.type == 0) {
      return SafeArea(
        child: HomeScreen(
          postController: post,
          controller: page,
          categoryController: category,
          id: params.id,
          type: params.type,
          name: params.name,
          tagController: tag,
        ),
      );
    }

    return SafeArea(
      child: SubPostScreen(
        tagController: tag,
        postController: post,
        pageController: page,
        categoryController: category,
        id: params.id,
        type: params.type,
        name: params.name,
      ),
    );
  }
}
