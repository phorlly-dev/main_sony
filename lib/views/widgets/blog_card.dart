import 'package:get/get.dart';
import '../../controllers/export_controller.dart';
import '../export_views.dart';

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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final colors = Theme.of(context).colorScheme;
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final author = controller.authorName(post);
    final classList = post.classList ?? [];
    final metaGroups = extractCategoriesAndTags(classList);
    final uniqueCategories = getMenuMetaList(
      metaGroups.categories.toSet().toList(),
    );
    final uniqueTags = getMenuMetaList(metaGroups.tags.toSet().toList());

    return Card(
      color: colors.surface,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                  padding: EdgeInsets.symmetric(vertical: 16),
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
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextContent(
                    article: description,
                    navigate: onReadMore,
                    isLandscape: isLandscape,
                  ),
                ),

                //Categories and Tags
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      // Categories
                      if (uniqueCategories.isNotEmpty)
                        IconTexts(
                          icon: Icons.list,
                          labels: uniqueCategories
                              .map((meta) => meta.name.replaceAll("-", " "))
                              .toList(),
                          color: AppColorRole.warning.color,
                          onLabelTaps: uniqueCategories
                              .map(
                                (meta) => () {
                                  controller.setActiveMenu(meta.slug);
                                  controller.applyFilterAndPaginate(
                                    slug: meta.slug,
                                  );
                                  Get.offAndToNamed(
                                    "/view-posts",
                                    arguments: ScreenParams(name: meta.name),
                                  );
                                },
                              )
                              .toList(),
                        ),

                      //Tags
                      if (uniqueTags.isNotEmpty)
                        IconTexts(
                          icon: Icons.tag_rounded,
                          labels: uniqueTags
                              .map((meta) => meta.name.replaceAll("-", " "))
                              .toList(),
                          color: AppColorRole.info.color,
                          onLabelTaps: uniqueTags
                              .map(
                                (meta) => () {
                                  controller.applyFilterAndPaginate(
                                    slug: meta.slug,
                                  );
                                  Get.offAndToNamed(
                                    "/view-posts",
                                    arguments: ScreenParams(name: meta.name),
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
