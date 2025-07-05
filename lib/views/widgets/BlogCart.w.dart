import 'package:flutter/material.dart';
import 'package:main_sony/utils/Utility.u.dart';
import 'package:main_sony/views/widgets/IconText.w.dart';
import 'package:main_sony/views/widgets/ImageContent.w.dart';
import 'package:main_sony/views/widgets/TextContent.w.dart';

class BlogCard extends StatelessWidget {
  final int? id;
  final String imageUrl;
  final String title;
  final DateTime date;
  final String author;
  final String description;
  final VoidCallback onReadMore;
  final VoidCallback? onComment;
  final VoidCallback? onAuthor;

  const BlogCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.author,
    required this.description,
    required this.onReadMore,
    this.onComment,
    this.onAuthor,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    //calculate the screen
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Date and author
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconText(
                        icon: Icons.calendar_today,
                        label: dateStr(date: date),
                      ),
                      IconText(icon: Icons.person, label: author.toUpperCase()),
                      IconText(
                        icon: Icons.comment,
                        label: 'Comment'.toUpperCase(),
                        color: Colors.lightBlue,
                      ),
                    ],
                  ),
                ),

                // Description
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextContent(
                    article: description,
                    navigate: () {},
                    isLandscape: isLandscape,
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
