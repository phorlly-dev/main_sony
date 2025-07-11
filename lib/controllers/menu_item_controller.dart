import 'package:get/get.dart';
import 'package:main_sony/controllers/api_provider.dart';
import 'package:wordpress_client/wordpress_client.dart';

final class MenuItemController extends ApiProvider {
  var items = <Post>[].obs;

  Future<void> fetchItems() async {
    final request = ListPostRequest(perPage: 100);
    final response = await connx.posts.list(request);

    response.map(
      onSuccess: (res) => items.value = res.data,
      onFailure: (err) => err.error?.message,
    );
  }

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }
}
