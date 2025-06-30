import 'package:get/get.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'Api.c.dart';

class PageControllerX extends ApiProvider {
  var pages = <Page>[].obs;

  Future<void> fetchPages() async {
    isLoading.value = true;
    hasError.value = '';
    final request = ListPageRequest(
      order: Order.desc,
      perPage: 5,
      orderBy: OrderBy.date,
    );
    final response = await connx.pages.list(request);

    response.map(
      onSuccess: (res) => pages.value = res.data,
      onFailure: (err) => hasError.value = err.error?.message ?? 'Error',
    );

    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchPages();
  }
}
