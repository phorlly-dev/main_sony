import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/utils/taxonomy_meta.dart';
import 'package:main_sony/views/export_views.dart';
import 'package:wordpress_client/wordpress_client.dart' show Post;

class BlogCard extends StatelessWidget {
  final PostController controller;
  final Post post;
  final String? imageUrl;
  final String title;
  final DateTime date;
  final String description;
  final VoidCallback onReadMore;
  final VoidCallback? onComment;

  const BlogCard({
    super.key,
    this.imageUrl,
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
    final author = controller.authorName[post.author];
    final metaGroups = extractCategoriesAndTagsFromPost(post);
    final classList = controller.classListFor(post.id);
    final groupeds = extractCategoriesAndTags(classList);
    var uniqueCategories = getByIds(metaGroups.categoryIds);
    var uniqueTags = getByIds(metaGroups.tagIds);

    if (uniqueCategories.isEmpty || uniqueTags.isEmpty) {
      uniqueTags = getMenuMetaList(groupeds.tags.toSet().toList());
      uniqueCategories = getMenuMetaList(groupeds.categories.toSet().toList());
    }

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
              screenHeight: .2,
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
                        label: author?.name ?? 'Admin System',
                        onTap: () async {
                          controller.applyFilter(
                            userId: post.author,
                            slug: '',
                            clearSearch: true,
                          );
                          final name = getName(author?.name ?? '');
                          context.goNamed(
                            'posts',
                            pathParameters: {'name': name},
                            queryParameters: {
                              'src': prefix(name),
                              'camp': subfix(name),
                            },
                          );

                          unawaited(
                            setLogEvent(
                              Params(
                                name: name,
                                src: prefix(name),
                                camp: subfix(name),
                                path: '/posts/$name',
                              ),
                            ),
                          );
                        },
                        color: AppColorRole.success.color,
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
                                (meta) => () async {
                                  controller.setActiveMenu(meta.slug);
                                  controller.applyFilter(
                                    slug: meta.slug,
                                    userId: 0,
                                    clearSearch: true,
                                  );

                                  final name = getName(meta.name);
                                  context.goNamed(
                                    'posts',
                                    pathParameters: {'name': name},
                                    queryParameters: {
                                      'src': prefix(name),
                                      'camp': subfix(name),
                                    },
                                  );

                                  unawaited(
                                    setLogEvent(
                                      Params(
                                        name: name,
                                        src: prefix(name),
                                        camp: subfix(name),
                                        path: '/posts/$name',
                                      ),
                                    ),
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
                                (meta) => () async {
                                  controller.applyFilter(
                                    slug: meta.slug,
                                    userId: 0,
                                    clearSearch: true,
                                  );

                                  final name = getName(meta.name);
                                  context.goNamed(
                                    'posts',
                                    pathParameters: {'name': name},
                                    queryParameters: {
                                      'src': prefix(name),
                                      'camp': subfix(name),
                                    },
                                  );

                                  unawaited(
                                    setLogEvent(
                                      Params(
                                        name: name,
                                        src: prefix(name),
                                        camp: subfix(name),
                                        path: '/posts/$name',
                                      ),
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
