import 'package:get/get.dart';
import 'package:main_sony/controllers/Category.c.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'Api.c.dart';

class PostController extends ApiProvider {
  final catCtrl = Get.put(CategoryController());

  // Reactive lists
  var posts = <Post>[].obs;

  Future<void> fetchPosts() async {
    isLoading.value = true;
    hasError.value = '';

    // Fetch posts
    final request = ListPostRequest(
      order: Order.desc,
      perPage: 5,
      orderBy: OrderBy.date,
    );
    final response = await connx.posts.list(request);

    response.map(
      onSuccess: (res) => posts.value = res.data,
      onFailure: (err) => hasError.value = err.error?.message ?? 'Error',
    );

    // Only fetch categories if needed (maybe in onInit of catCtrl)
    if (catCtrl.categoryMap.isEmpty) {
      await catCtrl.fetchCategories();
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

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }
}
