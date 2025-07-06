import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Post.c.dart';
import 'package:main_sony/utils/Utility.u.dart';
import 'package:main_sony/views/widgets/BlogCart.w.dart';
import 'package:main_sony/views/widgets/PagedListView.w.dart';

class PostCard extends StatelessWidget {
  final PostController controller;
  const PostCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PagedListView(
        items: controller.items,
        page: controller.page.value,
        totalPages: controller.totalPages.value,
        isLoading: controller.isLoading.value,
        hasError: controller.hasError.value,
        onGoToPage: (page) => controller.goToPage(page),
        itemBuilder: (context, item, index) {
          final yoast = item.yoastHeadJson;
          // final title = getValue(object: yoast, key: 'title').toString();
          // final desc = getValue(object: yoast, key: 'description').toString();
          final title = item.title?.rendered ?? 'No Title';
          final desc = item.excerpt?.rendered ?? 'No Decription';
          final media = controller.mediaMap[item.featuredMedia];
          final ogImage = getValue(object: yoast, key: 'og_image');
          final imgUrl = (ogImage is List && ogImage.isNotEmpty)
              ? ogImage[0]['url']
              : null;

          return BlogCard(
            imageUrl: media?.sourceUrl ?? imgUrl,
            title: title,
            description: desc,
            date: item.date ?? DateTime.now(),
            onReadMore: () {
              print("Read more");
            },
            // category: catName,
            onComment: () {},
            post: item,
            controller: controller,
          );
        },
      ),
    );
  }
}
