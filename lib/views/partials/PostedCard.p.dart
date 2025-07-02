import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Post.c.dart';
import 'package:main_sony/utils/Constants.u.dart';
import 'package:main_sony/views/widgets/ImageContent.w.dart';
import 'package:main_sony/views/widgets/PagedListView.w.dart';
import 'package:wordpress_client/wordpress_client.dart';

class PostedCard extends StatelessWidget {
  const PostedCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PostController>();
    // final connection = Get.find<ConnectionController>();

    //calculate the screen
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isFullScreenCard = isLandscape; // first card only

    return Obx(() {
      // log("The online is: Closed of ${connection.isOnline.value}");

      return PagedListView<Post>(
        items: ctrl.posts,
        page: ctrl.page.value,
        totalPages: ctrl.totalPages.value,
        isLoading: ctrl.isLoading.value,
        hasError: ctrl.hasError.value,
        onNext: () => ctrl.nextPage(),
        onPrev: () => ctrl.prevPage(),
        itemBuilder: (context, item, index) {
          final yoast = item.yoastHeadJson;
          final title = yoast?['title'] ?? 'No Title';
          final desc = yoast?['description'] ?? '';
          final imgUrl =
              (yoast?['og_image'] != null &&
                  yoast?['og_image'] is List &&
                  (yoast?['og_image'] as List).isNotEmpty)
              ? (yoast?['og_image'] as List)[0]['url']
              : null;

          return SizedBox(
            width: isFullScreenCard ? screenWidth : null,
            height: isFullScreenCard ? screenHeight : null,
            child: Card(
              margin: isFullScreenCard
                  ? EdgeInsets.symmetric(vertical: 6)
                  : EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              // elevation: 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ImageContent(
                    imageUrl: imgUrl,
                    screenHeight: screenHeight,
                    isFullScreen: isFullScreenCard,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Text(
                  //     title,
                  //     style: TextStyle(
                  //       // fontSize: 18,
                  //       // fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  ListTile(
                    title: Text(
                      title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        // fontSize: Responsive.isDesktop(context) ? 32 : 24,
                        fontFamily: "Raleway",
                        color: kDarkBlackColor,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      desc!,
                      maxLines: 4,
                      style: TextStyle(height: 1.5),
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //     vertical: kDefaultPadding,
                  //     horizontal: 16,
                  //   ),
                  //   child: Text(
                  //     title!,
                  //     maxLines: 2,
                  //     overflow: TextOverflow.ellipsis,
                  //     style: TextStyle(
                  //       // fontSize: Responsive.isDesktop(context) ? 32 : 24,
                  //       fontFamily: "Raleway",
                  //       color: kDarkBlackColor,
                  //       height: 1.3,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),
                  // Text(desc!, maxLines: 4, style: TextStyle(height: 1.5)),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
