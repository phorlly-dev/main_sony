import 'package:flutter/material.dart';
import 'package:main_sony/controllers/post_controller.dart';
import 'package:main_sony/utils/constants.dart';
import 'package:main_sony/utils/utility.dart';
import 'package:main_sony/views/widgets/html_content.dart';
import 'package:main_sony/views/widgets/icon_text.dart';
import 'package:main_sony/views/widgets/nav_bar.dart';
import 'package:wordpress_client/wordpress_client.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  final PostController controller;

  const PostDetailScreen({
    super.key,
    required this.post,
    required this.controller,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late final Post post;
  late final String title, category, tag;
  late final DateTime date;
  late final List<String>? classList;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    classList = post.classList;
    title = post.title?.rendered ?? 'No Title';
    date = post.date!;
    // final catEntry = classList?.firstWhere(
    //   (s) => s.startsWith('category-'),
    //   orElse: () => '',
    // );
    // final slug = catEntry.replaceFirst('category-', '');

    category = post.classList?[6].replaceFirst('category-', '') ?? '';
    tag = post.classList?[7].replaceFirst('tag-', '') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    //calculate the screen
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final colors = Theme.of(context).colorScheme;
    // final ogImage = getValue(object: yoast, key: 'og_image');
    // final imgUrl = (ogImage is List && ogImage.isNotEmpty)
    //     ? ogImage[0]['url']
    //     : null;

    return NavBar(
      title: "Post Details",
      content: SingleChildScrollView(
        child: Container(
          color: colors.surface,
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      unescape(title),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),

                    // Date and author
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 6,
                        children: [
                          IconText(
                            icon: Icons.calendar_today,
                            label: dateStr(date: date),
                            color: colors.onSurface.withValues(alpha: 0.7),
                          ),
                          if (category.isNotEmpty)
                            IconText(
                              icon: Icons.category_rounded,
                              label: category,
                              color: AppColorRole.success.color,
                              onTap: () {
                                // Get.offAll(
                                //   () => IndexScreen(),
                                //   duration: Duration(milliseconds: 800),
                                //   curve: Curves.fastLinearToSlowEaseIn,
                                //   arguments: ScreenParams(
                                //     id: e.key,
                                //     name: e.value,
                                //     type: 1,
                                //   ),
                                // );
                              },
                            ),
                        ],
                      ),
                    ),

                    HtmlContent(
                      htmlContent: post.content?.rendered ?? "No Content",
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      isLandscape: isLandscape,
                    ),

                    // ImageContent(
                    //   imageUrl: media?.sourceUrl ?? imgUrl,
                    //   screenHeight: screenHeight,
                    //   isLandscape: isLandscape,
                    //   isDetail: true,
                    // ),

                    //Tags
                    if (tag.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: IconText(
                          icon: Icons.tag_rounded,
                          label: tag,
                          color: AppColorRole.primary.color,
                          onTap: () {
                            // Get.offAll(
                            //   () => IndexScreen(),
                            //   duration: Duration(milliseconds: 800),
                            //   curve: Curves.fastLinearToSlowEaseIn,
                            //   arguments: ScreenParams(
                            //     id: e.key,
                            //     name: e.value,
                            //     type: 3,
                            //   ),
                            // );
                          },
                        ),
                      ),

                    //Tags
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
