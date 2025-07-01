import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Post.c.dart';
import 'package:main_sony/views/widgets/DataView.w.dart';
import 'package:main_sony/views/widgets/ImageContent.w.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PostController>();

    //calculate the screen
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isFullScreenCard = isLandscape; // first card only

    return Obx(
      () => DataView(
        itemCounter: ctrl.posts.length,
        isLoading: ctrl.isLoading.value,
        hasError: ctrl.hasError.value,
        notFound: ctrl.posts,
        itemBuilder: (context, index) {
          final item = ctrl.posts[index];
          final yoast = item.yoastHeadJson;
          final title = yoast?['title'] ?? 'No Title';
          // final desc = yoast?['description'] ?? '';
          final imgUrl =
              (yoast?['og_image'] != null &&
                  yoast?['og_image'] is List &&
                  (yoast?['og_image'] as List).isNotEmpty)
              ? (yoast?['og_image'] as List)[0]['url']
              : null;

          return Container(
            width: isFullScreenCard ? screenWidth : null,
            height: isFullScreenCard ? screenHeight : null,
            margin: isFullScreenCard
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ImageContent(
                    imageUrl: imgUrl,
                    screenHeight: screenHeight,
                    isFullScreen: isFullScreenCard,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      title,
                      // yoast?.title ?? '',
                      style: TextStyle(
                        // fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    //get item from api
    // final yoast = item?.yoastHeadJson;
    // final imageUrl = (yoast?.ogImage?.isNotEmpty == true)
    //     ? yoast!.ogImage!.first.url ?? ''
    //     : '';
  }
}
