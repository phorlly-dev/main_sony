import 'package:get/get.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'Api.c.dart';

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

  @override
  void onInit() {
    super.onInit();
    _fetchItems();
  }
}
