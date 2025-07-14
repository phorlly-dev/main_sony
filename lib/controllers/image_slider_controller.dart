import 'dart:developer';

import 'package:get/get.dart';
import 'package:main_sony/controllers/api_provider.dart';
import 'package:main_sony/controllers/media_controller.dart';
import 'package:main_sony/utils/params.dart';
import 'package:main_sony/utils/utility.dart';
import 'package:wordpress_client/wordpress_client.dart';

final class ImageSliderController extends ApiProvider {
  final _media = Get.put(MediaController());
  // Use RxList!
  final RxList<SlideItem> sliderItems = <SlideItem>[].obs;

  Future<void> fetchSliderItems() async {
    try {
      final request = ListPostRequest(order: Order.desc, orderBy: OrderBy.date);

      final response = await connx.posts.list(request);
      response.map(
        onSuccess: (res) async {
          final List<Post> posts = res.data;
          final List<Media> allMedia = [];

          // Media lookup
          final ids = posts
              .map((p) => p.featuredMedia)
              .whereType<int>()
              .toSet();
          if (ids.isNotEmpty) {
            final mediaResult = await _media.fetchItemByIds(ids.toList());
            allMedia.addAll(mediaResult);
          }
          final mediaMap = {for (var res in allMedia) res.id: res};

          final items = posts.take(10).map((post) {
            final yoast = post.yoastHeadJson;
            final media = mediaMap[post.featuredMedia];
            final ogImage = getValue(object: yoast, key: 'og_image');
            final imgUrl = (ogImage is List && ogImage.isNotEmpty)
                ? ogImage[0]['url']
                : null;

            return SlideItem(
              imageUrl: media?.sourceUrl ?? imgUrl,
              title: post.title?.rendered ?? 'No Title',
              date: dateStr(date: post.date ?? DateTime.now()),
            );
          }).toList();

          sliderItems.assignAll(items); // Use assignAll to update observable
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
