import 'package:get/get.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'api_provider.dart';

class TagController extends ApiProvider {
  var items = <Tag>[].obs;

  Future<void> _fetchItems() async {
    isLoading.value = true;
    hasError.value = '';

    final request = ListTagRequest(
      order: Order.asc,
      // perPage: 5,
      orderBy: OrderBy.name,
    );
    final response = await connx.tags.list(request);

    response.map(
      onSuccess: (res) => items.value = res.data,
      onFailure: (err) => hasError.value = err.error?.message ?? 'Error',
    );

    isLoading.value = false;
  }

  // Build a lookup map by id for fast access
  Map<int, Tag> get itemMap => {for (var res in items) res.id: res};

  //Tag
  List<MapEntry<int, String>> tags(Post post) {
    final tagIds = post.tags ?? [];
    return tagIds
        .map((id) {
          final name = itemMap[id]?.name ?? '';
          if (name.isEmpty) return null;
          return MapEntry(id, name);
        })
        .whereType<MapEntry<int, String>>() // only keep non-null
        .toList();
  }

  List<int> tagIds(Post post) {
    return post.tags ?? [];
  }

  List<String> tagNames(Post post) {
    return tagIds(post)
        .map((id) => itemMap[id]?.name ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
  }

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
