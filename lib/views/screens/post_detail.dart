import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:main_sony/configs/router.dart';
import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/utils/taxonomy_meta.dart';
import 'package:main_sony/views/export_views.dart';
import 'package:main_sony/views/widgets/copy_link.dart';
import 'package:wordpress_client/wordpress_client.dart' show Post;

class PostDetailScreen extends StatelessWidget {
  final Params params;
  final PostController controller;

  // Create the future once so it doesn't refetch on rebuilds.
  late final Future<Post> _future = controller.fetchItemById(params.id!);

  PostDetailScreen({super.key, required this.params, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Fire analytics exactly once after the first frame.
    Future.microtask(() => setLogEvent(params));

    final colors = Theme.of(context).colorScheme;

    return BodyContent(
      header: const NavBar(title: 'Post Details'),
      content: FutureBuilder<Post>(
        future: _future,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.none:
              return const NotFound(title: 'No data matches.!');
            default:
              if (snap.hasError) {
                return Center(child: Text('Failed to load: ${snap.error}'));
              }

              final post = snap.data;
              if (post == null) {
                return const Center(child: Text('Not found.!'));
              }

              // ---- everything below is your previous UI, using `post` instead of `_post!` ----
              final metaGroups = extractCategoriesAndTagsFromPost(post);
              final classList = controller.classListFor(post.id);
              final groupeds = extractCategoriesAndTags(classList);
              var uniqueCategories = getByIds(metaGroups.categoryIds);
              var uniqueTags = getByIds(metaGroups.tagIds);

              if (uniqueCategories.isEmpty || uniqueTags.isEmpty) {
                uniqueTags = getMenuMetaList(groupeds.tags.toSet().toList());
                uniqueCategories = getMenuMetaList(
                  groupeds.categories.toSet().toList(),
                );
              }

              return Container(
                color: colors.surface,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.all(8),
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

                      // Date + cats + copy
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          spacing: 8,
                          children: [
                            IconText(
                              icon: Icons.calendar_month_rounded,
                              label: dateStr(date: post.date ?? DateTime.now()),
                              color: colors.onSurface.withValues(alpha: 0.8),
                            ),

                            if (uniqueCategories.isNotEmpty)
                              IconTexts(
                                icon: Icons.list,
                                labels: uniqueCategories
                                    .map((m) => m.name.replaceAll("-", " "))
                                    .toList(),
                                color: AppColorRole.warning.color,
                                onLabelTaps: uniqueCategories
                                    .map(
                                      (meta) => () async {
                                        controller.applyFilter(
                                          slug: meta.slug,
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

                            CopyLinkButton(
                              link: Uri.parse('${MyRouter.url}${params.path}'),
                            ),
                          ],
                        ),
                      ),

                      // Content
                      HtmlContent(
                        htmlContent: post.content?.rendered ?? 'No Content',
                        screenHeight: ctx.height,
                        screenWidth: ctx.width,
                        isLandscape: ctx.isLandscape,
                      ),

                      if (uniqueTags.isNotEmpty)
                        Divider(color: colors.onSurface.withValues(alpha: 0.2)),

                      // Tags
                      if (uniqueTags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 12),
                          child: IconTexts(
                            icon: Icons.tag_rounded,
                            labels: uniqueTags
                                .map((m) => m.name.replaceAll("-", " "))
                                .toList(),
                            color: AppColorRole.info.color,
                            onLabelTaps: uniqueTags
                                .map(
                                  (meta) => () async {
                                    controller.applyFilter(
                                      slug: meta.slug,
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
                        ),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
