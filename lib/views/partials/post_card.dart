import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/post_controller.dart';
import 'package:main_sony/utils/utility.dart';
import 'package:main_sony/views/widgets/blog_cart.dart';
import 'package:main_sony/views/widgets/page_data_view.dart';
import 'package:wordpress_client/wordpress_client.dart';

class PostCard extends StatefulWidget {
  final int id, type;
  final PostController controller;
  const PostCard({
    super.key,
    required this.controller,
    required this.id,
    required this.type,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showFilter();
    });
  }

  @override
  void didUpdateWidget(covariant PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showFilter();
      });
    }
  }

  void showFilter() {
    widget.controller.dataView(id: widget.id, type: widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PageDataView<Post>(
        items: widget.controller.items,
        page: widget.controller.page.value,
        totalPages: widget.controller.totalPages.value,
        isLoading: widget.controller.isLoading.value,
        hasError: widget.controller.hasError.value,
        prevPage: widget.controller.prevPage,
        nextPage: widget.controller.nextPage,
        onGoToPage: (page) => widget.controller.goToPage(page),
        itemBuilder: (context, item, index) {
          final yoast = item.yoastHeadJson;
          // final title = getValue(object: yoast, key: 'title').toString();
          // final desc = getValue(object: yoast, key: 'description').toString();
          final title = item.title?.rendered ?? 'No Title';
          final desc = item.excerpt?.rendered ?? 'No Decription';
          final media = widget.controller.mediaMap[item.featuredMedia];
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
            onComment: () {
              print("The comment text here!");
            },
            post: item,
            controller: widget.controller,
          );
        },
      );
    });
  }
}
