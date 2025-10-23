import 'package:wordpress_client/wordpress_client.dart';

import 'export_controller.dart';

class PageControllerX extends ApiProvider<Page> {
  Future<void> _getPages() async {
    await fetchList(
      callback: () => cnx.pages.list(ListPageRequest()),
      append: true,
    );

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
  }

  @override
  void onInit() {
    super.onInit();
    _getPages();
  }
}
