import 'package:get/get.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'api_provider.dart';

class PageControllerX extends ApiProvider {
  final RxList<Page> items = <Page>[].obs;
  final RxBool isLoading = false.obs;
  final RxString hasError = ''.obs;

  //fetch pages
  Future<void> _fetchItems() async {
    isLoading.value = true;
    hasError.value = '';

    try {
      final request = ListPageRequest(
        order: Order.desc,
        // perPage: 5,
        orderBy: OrderBy.date,
      );
      final response = await connx.pages.list(request);

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
