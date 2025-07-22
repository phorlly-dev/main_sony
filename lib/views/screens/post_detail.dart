import 'package:get/get.dart';
import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/views/export_views.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;
  final PostListController controller;

  const PostDetailScreen({
    super.key,
    required this.post,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    //calculate the screen
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final colors = Theme.of(context).colorScheme;

    final classList = post.classList ?? [];
    final metaGroups = extractCategoriesAndTags(classList);
    final uniqueCategories = getMenuMetaList(
      metaGroups.categories.toSet().toList(),
    );
    final uniqueTags = getMenuMetaList(metaGroups.tags.toSet().toList());

    return NavBar(
      title: "Post Details",
      content: Container(
        color: colors.surface,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                unescape(post.title?.rendered ?? 'No Title'),
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
                      icon: Icons.calendar_month_rounded,
                      label: dateStr(date: post.date ?? DateTime.now()),
                      color: colors.onSurface.withValues(alpha: 0.7),
                    ),

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
                                Get.toNamed(
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

              //Content post
              HtmlContent(
                htmlContent: post.content?.rendered ?? "No Content",
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                isLandscape: isLandscape,
              ),

              Divider(color: colors.onSurface.withValues(alpha: 0.2)),
              //Tags
              if (uniqueTags.isNotEmpty)
                Container(
                  padding: EdgeInsets.only(top: 2, bottom: 12),
                  child: IconTexts(
                    icon: Icons.tag_rounded,
                    labels: uniqueTags
                        .map((meta) => meta.name.replaceAll("-", " "))
                        .toList(),
                    color: AppColorRole.info.color,
                    onLabelTaps: uniqueTags
                        .map(
                          (meta) => () {
                            controller.applyFilterAndPaginate(slug: meta.slug);
                            Get.toNamed(
                              "/view-posts",
                              arguments: ScreenParams(name: meta.name),
                            );
                          },
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
