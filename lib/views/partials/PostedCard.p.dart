import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Post.c.dart';
import 'package:main_sony/views/widgets/BlogCart.w.dart';
import 'package:main_sony/views/widgets/PagedListView.w.dart';
import 'package:wordpress_client/wordpress_client.dart';

class PostedCard extends StatelessWidget {
  const PostedCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PostController>();

    return Obx(() {
      return PagedListView<Post>(
        items: ctrl.posts,
        page: ctrl.page.value,
        totalPages: ctrl.totalPages.value,
        isLoading: ctrl.isLoading.value,
        hasError: ctrl.hasError.value,
        onNext: ctrl.nextPage,
        onPrev: ctrl.prevPage,
        onGoToPage: (page) => ctrl.goToPage(page),
        itemBuilder: (context, item, index) {
          final yoast = item.yoastHeadJson;
          // final title = yoast?['title'] ?? 'No Title';
          // final desc = yoast?['description'] ?? '';
          final title = item.title?.rendered ?? 'No Title';
          final desc = item.excerpt?.rendered ?? 'No Decription';
          final imgUrl =
              (yoast?['og_image'] != null &&
                  yoast?['og_image'] is List &&
                  (yoast?['og_image'] as List).isNotEmpty)
              ? (yoast?['og_image'] as List)[0]['url']
              : null;

          return BlogCard(
            imageUrl: imgUrl,
            title: title,
            description: desc,
            date: item.date ?? DateTime.now(),
            onReadMore: () {
              print("Read more");
            },
            author: ' Karmila',
            onComment: () {},
          );
        },
      );
    });
  }
}
