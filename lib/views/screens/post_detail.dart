import 'package:go_router/go_router.dart';
import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/views/export_views.dart';
import 'package:wordpress_client/wordpress_client.dart' show Post;

class PostDetailScreen extends StatefulWidget {
  final Params params;
  final PostListController controller;

  const PostDetailScreen({
    super.key,
    required this.params,
    required this.controller,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Post? _post;
  bool _loading = true;
  bool _logged = false;
  late PostListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _logEvent();
    if (_post != null) {
      _loading = false;
    } else {
      _load();
    }
  }

  void _logEvent() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_logged) return;
      await setLogEvent(widget.params);
      _logged = true;
    });
  }

  Future<void> _load() async {
    final p = await _controller.fetchItemById(widget.params.id!);
    if (!mounted) return;
    setState(() {
      _post = p;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //calculate the screen
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final colors = Theme.of(context).colorScheme;
    final classList = _controller.classListFor(widget.params.id!);

    final metaGroups = extractCategoriesAndTags(classList);
    final uniqueCategories = getMenuMetaList(
      metaGroups.categories.toSet().toList(),
    );
    final uniqueTags = getMenuMetaList(metaGroups.tags.toSet().toList());

    return BodyContent(
      header: NavBar(title: "Post Details"),
      content: _loading
          ? const Center(child: CircularProgressIndicator())
          : _post == null
          ? const Center(child: Text('Not found'))
          : Container(
              color: colors.surface,
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      unescape(_post!.title?.rendered ?? 'No Title'),
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
                            label: dateStr(date: _post!.date ?? DateTime.now()),
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
                                    (meta) => () async {
                                      _controller.applyFilterAndPaginate(
                                        slug: meta.slug,
                                        clearSearch: true,
                                      );
                                      final name = getName(meta.name);
                                      context.goNamed(
                                        'view_posts',
                                        pathParameters: {'name': name},
                                        queryParameters: {
                                          'src': prefix(name),
                                          'camp': subfix(name),
                                        },
                                      );
                                      await setLogEvent(
                                        Params(
                                          name: name,
                                          src: prefix(name),
                                          camp: subfix(name),
                                          path: '/view-posts/$name',
                                        ),
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
                      htmlContent: _post!.content?.rendered ?? "No Content",
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
                                (meta) => () async {
                                  _controller.applyFilterAndPaginate(
                                    slug: meta.slug,
                                    clearSearch: true,
                                  );
                                  final name = getName(meta.name);
                                  context.goNamed(
                                    'view_posts',
                                    pathParameters: {'name': name},
                                    queryParameters: {
                                      'src': prefix(name),
                                      'camp': subfix(name),
                                    },
                                  );
                                  await setLogEvent(
                                    Params(
                                      name: name,
                                      src: prefix(name),
                                      camp: subfix(name),
                                      path: '/view-posts/$name',
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
            ),
    );
  }
}
