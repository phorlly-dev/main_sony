import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Post.c.dart';
import 'package:main_sony/utils/Utility.u.dart';
import 'package:main_sony/views/widgets/BlogCart.w.dart';
import 'package:main_sony/views/widgets/DataView.w.dart';

class PostByCategoryCard extends StatelessWidget {
  final int id;
  final PostController controller;

  const PostByCategoryCard({
    super.key,
    required this.controller,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    // Filter posts by category
    final filteredPosts = controller.postsByCategory(id);

    return Obx(
      () => DataView(
        isLoading: controller.isLoading.value,
        hasError: controller.hasError.value,
        notFound: filteredPosts,
        itemCounter: filteredPosts.length,
        itemBuilder: (context, index) {
          final item = filteredPosts[index];
          final yoast = item.yoastHeadJson;
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
            onComment: () {
              print("The comment text here!");
            },
            post: item,
            controller: controller,
          );
        },
      ),
    );
  }
}
