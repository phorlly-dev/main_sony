import 'package:get/get.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'Api.c.dart';

class CategoryController extends ApiProvider {
  var categories = <Category>[].obs;

  Future<void> fetchCategories() async {
    isLoading.value = true;
    hasError.value = '';
    final request = ListCategoryRequest(
      order: Order.asc,
      perPage: 5,
      orderBy: OrderBy.name,
    );
    final response = await connx.categories.list(request);

    response.map(
      onSuccess: (res) => categories.value = res.data,
      onFailure: (err) => hasError.value = err.error?.message ?? 'Error',
    );

    isLoading.value = false;
  }

  // Build a lookup map by id for fast access
  Map<int, Category> get categoryMap => {
    for (var cat in categories) cat.id: cat,
  };

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
}
