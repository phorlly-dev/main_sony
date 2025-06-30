import 'package:get/get.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'Api.c.dart';

class MediaController extends ApiProvider {
  var medies = <Media>[].obs;

  Future<void> fetchMedia() async {
    isLoading.value = true;
    hasError.value = '';
    final request = ListMediaRequest(
      order: Order.desc,
      perPage: 5,
      orderBy: OrderBy.date,
    );
    final response = await connx.media.list(request);

    response.map(
      onSuccess: (res) => medies.value = res.data,
      onFailure: (err) => hasError.value = err.error?.message ?? 'Error',
    );

    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchMedia();
  }
}
