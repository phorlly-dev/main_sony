import 'package:flutter/material.dart';
import 'package:main_sony/controllers/Post.c.dart';
import 'package:main_sony/utils/Constants.u.dart';
import 'package:main_sony/utils/Utility.u.dart';
import 'package:main_sony/views/widgets/IconText.w.dart';
import 'package:main_sony/views/widgets/IconTexts.w.dart';
import 'package:main_sony/views/widgets/ImageContent.w.dart';
import 'package:main_sony/views/widgets/TextContent.w.dart';
import 'package:wordpress_client/wordpress_client.dart';

class BlogCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    //calculate the screen
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final colors = Theme.of(context).colorScheme;
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final author = controller.authorName(post);
    final categoryIds = controller.categoryIds(post);
    final categoryNames = controller.categoryNames(post);
    final tagIds = controller.tagIds(post);
    final tagNames = controller.tagNames(post);

    return Card(
      color: colors.surface,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onReadMore,
            child: ImageContent(
              imageUrl: imageUrl,
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
                Text(
                  title,
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
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 6,
                    children: [
                      IconText(
                        icon: Icons.calendar_today,
                        label: dateStr(date: date),
                        color: colors.onSurface.withValues(alpha: 0.7),
                      ),
                      IconText(
                        icon: Icons.person,
                        label: author.toUpperCase(),
                        onTap: () {
                          print("The user id: ${post.author}");
                        },
                        color: AppColorRole.secondary.color,
                      ),
                      IconText(
                        icon: Icons.comment,
                        label: 'Comment'.toUpperCase(),
                        color: AppColorRole.info.color,
                        onTap: onComment,
                      ),
                    ],
                  ),
                ),

                // Description
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextContent(
                    article: description,
                    navigate: onReadMore,
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
                      if (categoryNames.isNotEmpty)
                        IconTexts(
                          icon: Icons.category_rounded,
                          labels: categoryNames,
                          color: AppColorRole.success.color,
                          onLabelTaps: categoryIds
                              .map(
                                (id) => () {
                                  print('Clicked category with id $id');
                                  // navigate to category page with this id
                                },
                              )
                              .toList(),
                        ),

                      //Tags
                      if (tagNames.isNotEmpty)
                        IconTexts(
                          icon: Icons.tag_rounded,
                          labels: tagNames,
                          color: AppColorRole.primary.color,
                          onLabelTaps: tagIds
                              .map(
                                (id) => () {
                                  print('Clicked tag with id $id');
                                  // navigate to category page with this id
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
