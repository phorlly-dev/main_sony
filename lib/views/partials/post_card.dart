import 'package:go_router/go_router.dart';
import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/views/export_views.dart';
import 'package:wordpress_client/wordpress_client.dart' show Post;

class PostCard extends StatelessWidget {
  final String name;
  final PostListController controller;

  const PostCard({super.key, required this.controller, required this.name});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PageDataView<Post>(
        items: controller.items,
        page: controller.page.value,
        totalPages: controller.totalViewPages,
        isLoading: controller.isLoading.value,
        hasError: controller.hasError.value,
        noDataMessage: controller.searchQuery.isEmpty
            ? "No data found."
            : "No results for '${controller.searchQuery.value}'",
        onGoToPage: (page) => controller.goToPage(page),
        itemBuilder: (ctx, item, idx) {
          // Extract relevant metadata
          final title = item.title?.rendered ?? 'No Title';
          final desc = item.excerpt?.rendered ?? 'No Description';
          final media = controller.mediaMap[item.featuredMedia];
          final imgUrl = controller.ogImageUrl(item.id) as String;
          return BlogCard(
            imageUrl: media?.sourceUrl ?? imgUrl,
            title: title,
            description: desc,
            date: item.date ?? DateTime.now(),
            onReadMore: () {
              ctx.pushNamed<Post>(
                'post_details',
                pathParameters: {
                  'id': encodeId(item.id),
                  'name': getName(name),
                },
                queryParameters: {
                  'src': 'post-${getName(name)}-details',
                  'camp': 'from-card-blog',
                },
              );
            },
            controller: controller,
            post: item,
            onComment: () {
              showCommentDialog(context: ctx, postId: item.id);
            },
          );
        },
      );
    });
  }
}
