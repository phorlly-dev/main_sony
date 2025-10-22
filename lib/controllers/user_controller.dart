import 'package:wordpress_client/wordpress_client.dart';

import 'export_controller.dart';

class UserController extends ApiProvider<User> {
  Future<void> _fetchItems() async {
    isLoading.value = true;
    hasError.value = '';
    try {
      final request = ListUserRequest();
      final response = await cnx.users.list(request);

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
