import 'package:get/get.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'Api.c.dart';

class CategoryController extends ApiProvider {
  var items = <Category>[].obs;

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

  @override
  void onInit() {
    super.onInit();
    _fetchItems();
  }

  @override
  void onClose() {
    super.onClose();
    selectedIndex.value = 0;
    hasError.value = '';
    isLoading.value = false;
  }
}
