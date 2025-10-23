import 'package:wordpress_client/wordpress_client.dart';
import 'export_controller.dart';
import 'package:main_sony/utils/export_util.dart';

class ImageSliderController extends ApiProvider<SlideItem> {
  final RxInt postId = 0.obs;
  final _media = Get.put(MediaController());

  Future<void> fetchSliderItems() async {
    try {
      final request = ListPostRequest(order: Order.desc, orderBy: OrderBy.date);

      final response = await cnx.posts.list(request);
      response.map(
        onSuccess: (res) async {
          final posts = res.data;

          // Media lookup
          await _media.ensureMediaForPosts(posts);
          await fetchExtrasForPostIds(posts.map((p) => p.id).toList());

          final allItems = posts.take(10).map((post) {
            final media = _media.itemMapping[post.featuredMedia];
            final imgUrl = ogImageUrl(post.id);
            postId.value = post.id;

            return SlideItem(
              imageUrl: media?.sourceUrl ?? imgUrl ?? '',
              title: post.title?.rendered ?? 'No Title',
              date: dateStr(date: post.date ?? DateTime.now()),
            );
          }).toList();

          items.assignAll(allItems); // Use assignAll to update observable
        },
        onFailure: (err) => log(err.error?.message ?? 'Failed to load posts'),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchSliderItems();
  }
}
