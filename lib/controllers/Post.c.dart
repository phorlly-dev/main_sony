import 'package:get/get.dart';
import 'package:main_sony/controllers/Category.c.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'Api.c.dart';

class PostController extends ApiProvider {
  final catCtrl = Get.put(CategoryController());

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

      // Only fetch categories if needed (maybe in onInit of catCtrl)
      if (catCtrl.categoryMap.isEmpty) {
        await catCtrl.fetchCategories();
      }
    } catch (e) {
      hasError.value = e.toString();
    }

    isLoading.value = false;
  }

  // Grouped posts by category ID (computed property)
  Map<int, List<Post>> get groupPostsByCategory {
    final grouped = <int, List<Post>>{};
    for (final post in posts) {
      if (post.categories != null) {
        for (final catId in post.categories!) {
          grouped.putIfAbsent(catId, () => []).add(post);
        }
      }
    }
    return grouped;
  }

  // Map of category ID to Category
  Map<int, Category> get categoryMap => catCtrl.categoryMap;

  void nextPage() {
    if (page.value < totalPages.value && !isLoading.value) {
      fetchPosts(pageNum: page.value + 1);
    }
  }

  void prevPage() {
    if (page.value > 1 && !isLoading.value) {
      fetchPosts(pageNum: page.value - 1);
    }
  }

  Future<void> refreshCurrentPage() async {
    await fetchPosts(pageNum: page.value);
  }

  void goToPage(int pageNum) {
    if (pageNum < 1 || pageNum > totalPages.value || isLoading.value) return;
    fetchPosts(pageNum: pageNum);
  }

  @override
  void onInit() {
    super.onInit();
    fetchPosts(pageNum: 1);
  }
}
