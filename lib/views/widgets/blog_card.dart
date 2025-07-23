import 'package:get/get.dart';
import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/views/export_views.dart';

class BlogCard extends StatelessWidget {
  final PostListController controller;
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
    final isLandscape = context.isLandscape;
    final colors = Theme.of(context).colorScheme;
    final author = controller.authorName(post);
    // final classList = post.classList ?? [];
    // final metaGroups = extractCategoriesAndTags(classList);
    // final uniqueCategories = getMenuMetaList(
    //   metaGroups.categories.toSet().toList(),
    // );
    // final uniqueTags = getMenuMetaList(metaGroups.tags.toSet().toList());
    // EdgeInsets.symmetric(horizontal: 12, vertical: 4) // mobile

    return Card(
      color: colors.surface,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onReadMore,
            child: ImageContent(
              imageUrl: imageUrl,
              screenHeight: .20,
              isLandscape: isLandscape,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                InkWell(
                  onTap: onReadMore,
                  child: Text(
                    unescape(title),
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
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 6,
                    children: [
                      IconText(
                        icon: Icons.calendar_month_rounded,
                        label: dateStr(date: date),
                        color: colors.secondaryFixedDim,
                      ),
                      IconText(
                        icon: Icons.person,
                        label: author,
                        onTap: () {
                          controller.applyFilterAndPaginate(
                            userId: post.author,
                            slug: '',
                          );
                          Get.offAndToNamed(
                            "/view-posts",
                            arguments: ScreenParams(name: author),
                          );
                        },
                        color: colors.secondary,
                      ),
                      IconText(
                        icon: Icons.comment,
                        label: 'Comment',
                        color: colors.outline,
                        onTap: onComment,
                      ),
                    ],
                  ),
                ),

                // Description
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: TextContent(
                    article: description,
                    navigate: onReadMore,
                    isLandscape: isLandscape,
                  ),
                ),

                //Categories and Tags
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: 16),
                //   child: Wrap(
                //     spacing: 8,
                //     runSpacing: 4,
                //     children: [
                //       // Categories
                //       if (uniqueCategories.isNotEmpty)
                //         IconTexts(
                //           icon: Icons.list,
                //           labels: uniqueCategories
                //               .map((meta) => meta.name.replaceAll("-", " "))
                //               .toList(),
                //           color: AppColorRole.warning.color,
                //           onLabelTaps: uniqueCategories
                //               .map(
                //                 (meta) => () {
                //                   controller.setActiveMenu(meta.slug);
                //                   log("The slug card item: ${meta.slug}");
                //                   controller.applyFilterAndPaginate(
                //                     slug: meta.slug,
                //                   );
                //                   Get.offAndToNamed(
                //                     "/view-posts",
                //                     arguments: ScreenParams(
                //                       name: meta.name.replaceAll("-", " "),
                //                     ),
                //                   );
                //                 },
                //               )
                //               .toList(),
                //         ),

                //       //Tags
                //       if (uniqueTags.isNotEmpty)
                //         IconTexts(
                //           icon: Icons.tag_rounded,
                //           labels: uniqueTags
                //               .map((meta) => meta.name.replaceAll("-", " "))
                //               .toList(),
                //           color: AppColorRole.info.color,
                //           onLabelTaps: uniqueTags
                //               .map(
                //                 (meta) => () {
                //                   controller.applyFilterAndPaginate(
                //                     slug: meta.slug,
                //                   );
                //                   Get.offAndToNamed(
                //                     "/view-posts",
                //                     arguments: ScreenParams(
                //                       name: meta.name.replaceAll("-", " "),
                //                     ),
                //                   );
                //                 },
                //               )
                //               .toList(),
                //         ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
