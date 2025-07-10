import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/post_controller.dart';
import 'package:main_sony/utils/constants.dart';
import 'package:main_sony/utils/params.dart';
import 'package:main_sony/utils/utility.dart';
import 'package:main_sony/views/screens/index.dart';
import 'package:main_sony/views/widgets/icon_text.dart';
import 'package:main_sony/views/widgets/icon_texts.dart';
import 'package:main_sony/views/widgets/image_content.dart';
import 'package:main_sony/views/widgets/text_content.dart';
import 'package:wordpress_client/wordpress_client.dart';

class BlogCard extends StatefulWidget {
  final PostController controller;
  final Post post;
  final String imageUrl;
  final String title;
  final DateTime date;
  final String description;
  final VoidCallback onReadMore;
  final VoidCallback? onComment;

  const BlogCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.description,
    required this.onReadMore,
    this.onComment,
    required this.post,
    required this.controller,
  });

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  late final PostController controller;
  late final String author;
  late final List<MapEntry<int, String>> categories, tags;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    author = widget.controller.authorName(widget.post);
    categories = widget.controller.categories(widget.post);
    tags = widget.controller.tags(widget.post);
  }

  @override
  Widget build(BuildContext context) {
    //calculate the screen
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final colors = Theme.of(context).colorScheme;
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      color: colors.surface,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: widget.onReadMore,
            child: ImageContent(
              imageUrl: widget.imageUrl,
              screenHeight: screenHeight,
              isLandscape: isLandscape,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                InkWell(
                  onTap: widget.onReadMore,
                  child: Text(
                    unescape(widget.title),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                ),

                // Date and author
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 6,
                    children: [
                      IconText(
                        icon: Icons.calendar_today,
                        label: dateStr(date: widget.date),
                        color: colors.onSurface.withValues(alpha: 0.7),
                      ),
                      IconText(
                        icon: Icons.person,
                        label: author.toUpperCase(),
                        onTap: () {
                          Get.offAll(
                            () => IndexScreen(),
                            duration: Duration(milliseconds: 800),
                            curve: Curves.fastLinearToSlowEaseIn,
                            arguments: ScreenParams(
                              id: widget.post.author,
                              name: author,
                              type: 2,
                            ),
                          );
                        },
                        color: AppColorRole.secondary.color,
                      ),
                      IconText(
                        icon: Icons.comment,
                        label: 'Comment'.toUpperCase(),
                        color: AppColorRole.info.color,
                        onTap: widget.onComment,
                      ),
                    ],
                  ),
                ),

                // Description
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextContent(
                    article: widget.description,
                    navigate: widget.onReadMore,
                    isLandscape: isLandscape,
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      // Categories
                      if (categories.isNotEmpty)
                        IconTexts(
                          icon: Icons.category_rounded,
                          labels: categories.map((e) => e.value).toList(),
                          color: AppColorRole.success.color,
                          onLabelTaps: categories
                              .map(
                                (e) => () {
                                  widget.controller.setActiveMenu(e.key);
                                  Get.offAll(
                                    () => IndexScreen(),
                                    duration: Duration(milliseconds: 800),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    arguments: ScreenParams(
                                      id: e.key,
                                      name: e.value,
                                      type: 1,
                                    ),
                                  );
                                },
                              )
                              .toList(),
                        ),

                      //Tags
                      if (tags.isNotEmpty)
                        IconTexts(
                          icon: Icons.tag_rounded,
                          labels: tags.map((e) => e.value).toList(),
                          color: AppColorRole.primary.color,
                          onLabelTaps: tags
                              .map(
                                (e) => () {
                                  Get.offAll(
                                    () => IndexScreen(),
                                    duration: Duration(milliseconds: 800),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    arguments: ScreenParams(
                                      id: e.key,
                                      name: e.value,
                                      type: 3,
                                    ),
                                  );
                                },
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
