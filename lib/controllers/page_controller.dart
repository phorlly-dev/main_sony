import 'package:wordpress_client/wordpress_client.dart';

import 'export_controller.dart';

class PageControllerX extends ApiProvider<Page> {
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
      final response = await cnx.pages.list(request);

      response.map(
        onSuccess: (res) async {
          items.value = res.data;
          final ids = items.map((p) => p.id).toList();
          await fetchCustomFieldsForIds(
            slug: 'pages',
            ids: ids,
            fields: ['yoast_head_json'],
          ).then((fetchCustom) {
            for (final row in fetchCustom) {
              final id = row['id'] as int;

              // Yoast head JSON as a map
              final yoast = row['yoast_head_json'];
              if (yoast is Map<String, dynamic>) {
                yoasts[id] = yoast;
              }
            }
          });
        },
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
