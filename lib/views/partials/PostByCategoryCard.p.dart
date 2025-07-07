import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Post.c.dart';
import 'package:main_sony/utils/Utility.u.dart';
import 'package:main_sony/views/widgets/BlogCart.w.dart';
import 'package:main_sony/views/widgets/DataView.w.dart';

class PostByCategoryCard extends StatefulWidget {
  final int id;
  final PostController controller;

  const PostByCategoryCard({
    super.key,
    required this.controller,
    required this.id,
  });

  @override
  State<PostByCategoryCard> createState() => _PostByCategoryCardState();
}

class _PostByCategoryCardState extends State<PostByCategoryCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.fetchItemsByCategory(widget.id);
    });
  }

  @override
  void didUpdateWidget(covariant PostByCategoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.controller.fetchItemsByCategory(widget.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DataView(
        isLoading: widget.controller.isLoading.value,
        hasError: widget.controller.hasError.value,
        notFound: widget.controller.itemsBy,
        itemCounter: widget.controller.itemsBy.length,
        itemBuilder: (context, index) {
          final item = widget.controller.itemsBy[index];
          final yoast = item.yoastHeadJson;
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
            onComment: () {
              print("The comment text here!");
            },
            post: item,
            controller: widget.controller,
          );
        },
      ),
    );
  }
}
