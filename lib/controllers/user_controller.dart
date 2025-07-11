import 'package:get/get.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'api_provider.dart';

class UserController extends ApiProvider {
  final RxList<User> items = <User>[].obs;
  final RxBool isLoading = false.obs;
  final RxString hasError = ''.obs;

  Future<void> _fetchItems() async {
    isLoading.value = true;
    hasError.value = '';
    final request = ListUserRequest(
      order: Order.asc,
      // perPage: 5,
      orderBy: OrderBy.date,
    );
    final response = await connx.users.list(request);

    response.map(
      onSuccess: (res) => items.value = res.data,
      onFailure: (err) => hasError.value = err.error?.message ?? 'Error',
    );

    isLoading.value = false;
  }

  // Build a lookup map by id for fast access
  Map<int, User> get itemMap => {for (var res in items) res.id: res};

  //User
  String authorName(Post post) => itemMap[post.author]?.name ?? "User";

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
