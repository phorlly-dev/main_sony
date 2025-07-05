import 'package:get/get.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'Api.c.dart';

class UserController extends ApiProvider {
  var users = <User>[].obs;

  Future<void> fetchUsers() async {
    isLoading.value = true;
    hasError.value = '';
    final request = ListUserRequest(
      order: Order.asc,
      perPage: 5,
      orderBy: OrderBy.date,
    );
    final response = await connx.users.list(request);

    response.map(
      onSuccess: (res) => users.value = res.data,
      onFailure: (err) => hasError.value = err.error?.message ?? 'Error',
    );

    isLoading.value = false;
  }

  // Build a lookup map by id for fast access
  Map<int, User> get userMap => {for (var usr in users) usr.id: usr};

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }
}
