import 'export_controller.dart';

final class MenuItemController extends ApiProvider {
  final RxList<Post> items = <Post>[].obs;

  Future<void> _fetchItems() async {
    final request = ListPostRequest(perPage: 100);
    final response = await cnx.posts.list(request);

    response.map(
      onSuccess: (res) => items.value = res.data,
      onFailure: (err) => err.error?.message,
    );
  }

  @override
  void onInit() {
    super.onInit();
    _fetchItems();
  }
}
