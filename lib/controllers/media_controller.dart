import 'package:get/get.dart';
import 'export_controller.dart';

class MediaController extends ApiProvider {
  final RxList<Media> items = <Media>[].obs;
  final RxBool isLoading = false.obs;
  final RxString hasError = ''.obs;

  Future<void> _fetchItems() async {
    isLoading.value = true;
    hasError.value = '';

    try {
      final request = ListMediaRequest(
        order: Order.desc,
        perPage: 100,
        orderBy: OrderBy.date,
      );
      final response = await cnx.media.list(request);

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

  Future<List<Media>> fetchItemByIds(List<int> ids) async {
    final url = '$apiUrl/media?include=${ids.join(",")}';
    final response = await api.get(url);
    if (response.statusCode == 200 && response.isOk) {
      final data = response.body;

      if (data is List) {
        return (data).map((json) => Media.fromJson(json)).toList();
      } else if (data is Map<String, dynamic>) {
        return [Media.fromJson(data)];
      } else {
        hasError.value = 'Unexpected response format';
        return [];
      }
    } else {
      hasError.value = 'Failed to fetch media';
      return [];
    }
  }

  Map<int, List<Media>> get itemBy {
    final map = <int, List<Media>>{};
    for (var res in items) {
      if (res.post != null) {
        map.putIfAbsent(res.post!, () => []).add(res);
      }
    }
    return map;
  }

  // Build a lookup map by id for fast access
  Map<int, Media> get itemMap => {for (var res in items) res.id: res};

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
