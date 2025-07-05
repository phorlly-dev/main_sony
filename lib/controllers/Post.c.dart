import 'package:get/get.dart';
import 'package:main_sony/controllers/Category.c.dart';
import 'package:main_sony/controllers/Media.c.dart';
import 'package:main_sony/controllers/User.c.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'Api.c.dart';

class PostController extends ApiProvider {
  final catCtrl = Get.put(CategoryController());
  final usrCtrl = Get.put(UserController());
  final medCtrl = Get.put(MediaController());

  // Reactive lists
  var posts = <Post>[].obs;

  // Main fetch
  Future<void> fetchPosts({int? pageNum}) async {
    isLoading.value = true;
    hasError.value = '';

    if (pageNum != null) page.value = pageNum;

    try {
      // Fetch posts
      final request = ListPostRequest(
        order: Order.desc,
        perPage: perPage,
        page: page.value,
        orderBy: OrderBy.date,
      );
      final response = await connx.posts.list(request);

      response.map(
        onSuccess: (res) {
          posts.value = res.data;
          totalPages.value = (res.totalCount / perPage).ceil();
        },
        onFailure: (err) =>
            hasError.value = err.error?.message ?? 'Failure on load data',
      );

      final featuredIds = posts
          .map((p) => p.featuredMedia)
          .whereType<int>()
          .toSet();
      if (featuredIds.isNotEmpty) {
        final mediaResult = await medCtrl.fetchMediaByIds(featuredIds.toList());
        medCtrl.media.value = mediaResult;
      }
    } catch (e) {
      hasError.value = e.toString();
    }

    isLoading.value = false;
  }

  Map<int, Media> get mediaMap => medCtrl.mediaMap;

  // Grouped posts by category ID (computed property)
  Map<int, List<Post>> groupByCategory(List<Post> posts) {
    final map = <int, List<Post>>{};
    for (final post in posts) {
      for (final cat in post.categories ?? []) {
        map.putIfAbsent(cat, () => []).add(post);
      }
    }
    return map;
  }

  // Map of category ID to Category
  String getCategoryNames(Post post) {
    return post.categories
            ?.map((id) => catCtrl.categoryMap[id]?.name ?? '')
            .where((name) => name.isNotEmpty)
            .join(', ') ??
        'Uncategorized';
  }

  //author
  User? authorName(Post post) {
    return usrCtrl.userMap[post.author];
  }

  // Reactive variables
  void nextPage() {
    if (page.value < totalPages.value && !isLoading.value) {
      fetchPosts(pageNum: page.value + 1);
    }
  }

  // Go to previous page
  void prevPage() {
    if (page.value > 1 && !isLoading.value) {
      fetchPosts(pageNum: page.value - 1);
    }
  }

  // Refresh current page
  Future<void> refreshCurrentPage() async {
    await fetchPosts(pageNum: page.value);
  }

  // Go to specific page
  void goToPage(int pageNum) {
    if (pageNum < 1 || pageNum > totalPages.value || isLoading.value) return;
    fetchPosts(pageNum: pageNum);
  }

  // Group posts by tag ID
  Map<int, List<Post>> groupByTag(List<Post> posts) {
    final map = <int, List<Post>>{};
    for (final post in posts) {
      for (final tag in post.tags ?? []) {
        map.putIfAbsent(tag, () => []).add(post);
      }
    }
    return map;
  }

  // Group posts by author ID
  Map<int, List<Post>> groupByAuthor(List<Post> posts) {
    final map = <int, List<Post>>{};
    for (final post in posts) {
      map.putIfAbsent(post.author, () => []).add(post);
    }
    return map;
  }

  // Reactive variables
  @override
  void onInit() {
    super.onInit();
    fetchPosts(pageNum: 1);
  }
}
