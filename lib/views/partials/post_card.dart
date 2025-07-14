import 'package:get/get.dart';
import '../export_views.dart';
import '../../controllers/export_controller.dart';

class PostCard extends StatelessWidget {
  final PostListController controller;

  const PostCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PageDataView<Post>(
        items: controller.pagedPosts,
        page: controller.page.value,
        totalPages: controller.totalViewPages,
        isLoading: controller.isLoading.value,
        hasError: controller.hasError.value,
        noDataMessage: controller.searchQuery.isEmpty
            ? "No data found."
            : "No results for '${controller.searchQuery.value}'",
        onGoToPage: (page) => controller.goToPage(page),
        itemBuilder: (context, item, index) {
          final yoast = item.yoastHeadJson;

          // Extract relevant metadata
          final title = item.title?.rendered ?? 'No Title';
          final desc = item.excerpt?.rendered ?? 'No Decription';
          final media = controller.mediaMap[item.featuredMedia];
          final ogImage = getValue(object: yoast, key: 'og_image');
          final imgUrl = (ogImage is List && ogImage.isNotEmpty)
              ? ogImage[0]['url']
              : null;

          return BlogCard(
            imageUrl: media?.sourceUrl ?? imgUrl,
            title: title,
            description: desc,
            date: item.date ?? DateTime.now(),
            onReadMore: () async {
              final post = await controller.fetchItemById(item.id);

              // Navigate to the post detail screen
              Get.to(
                () => PostDetailScreen(post: post, controller: controller),
                curve: Curves.fastLinearToSlowEaseIn,
              );
            },
            controller: controller,
            post: item,
            onComment: () =>
                showCommentDialog(context: context, postId: item.id),
          );
        },
      );
    });
  }
}
