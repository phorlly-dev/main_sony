import 'export_controller.dart';

class TagController extends ApiProvider {
  final RxList<Tag> items = <Tag>[].obs;
  final RxBool isLoading = false.obs;
  final RxString hasError = ''.obs;

  Future<void> _fetchItems() async {
    isLoading.value = true;
    hasError.value = '';
    try {
      final request = ListTagRequest(
        order: Order.asc,
        // perPage: 5,
        orderBy: OrderBy.name,
      );
      final response = await cnx.tags.list(request);

      response.map(
        onSuccess: (res) => items.value = res.data,
        onFailure: (err) => hasError.value = err.error?.message ?? 'Error',
      );
    } catch (e) {
      hasError.value = e.toString();
    } finally {
      isLoading.value = false;
    }
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
