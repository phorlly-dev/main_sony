import 'package:wordpress_client/wordpress_client.dart';

import 'export_controller.dart';

final class MenuItemController extends ApiProvider<Post> {
  Future<void> _fetchItems() async {
    final request = ListPostRequest(perPage: 100);
    final response = await cnx.posts.list(request);

    response.map(
      onSuccess: (res) async {
        items.value = res.data;
        await fetchExtrasForPostIds(res.data.map((p) => p.id).toList());
      },
      onFailure: (err) => err.error?.message,
    );
  }

  @override
  void onInit() {
    super.onInit();
    _fetchItems();
  }
}
