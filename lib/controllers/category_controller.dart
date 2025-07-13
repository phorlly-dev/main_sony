import 'package:get/get.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'api_provider.dart';

class CategoryController extends ApiProvider {
  final RxList<Category> items = <Category>[].obs;
  final RxBool isLoading = false.obs;
  final RxString hasError = ''.obs;

  Future<void> _fetchItems() async {
    isLoading.value = true;
    hasError.value = '';

    final request = ListCategoryRequest(
      order: Order.asc,
      // perPage: 5,
      orderBy: OrderBy.name,
    );
    final response = await connx.categories.list(request);

    response.map(
      onSuccess: (res) => items.value = res.data,
      onFailure: (err) => hasError.value = err.error?.message ?? 'Error',
    );

    isLoading.value = false;
  }

  // Build a lookup map by id for fast access
  Map<int, Category> get itemMap => {for (var res in items) res.id: res};

  List<MapEntry<int, String>> categories(Post post) {
    final categoryIds = post.categories ?? [];
    final categoryNames = categoryIds
        .map((id) => itemMap[id]?.name ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    return categoryIds
        .asMap()
        .entries
        .map((entry) => MapEntry(entry.value, categoryNames[entry.key]))
        .toList();
  }

  List<Post> filterByCategory(List<Post> posts, int categoryId) =>
      posts.where((post) => post.categories!.contains(categoryId)).toList();

  @override
  void onInit() {
    super.onInit();
    _fetchItems();
  }

  @override
  void onClose() {
    super.onClose();
    hasError.value = '';
    isLoading.value = false;
  }
}
