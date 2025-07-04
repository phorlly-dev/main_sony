import 'package:get/get.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'Api.c.dart';

class MediaController extends ApiProvider {
  var media = <Media>[].obs;

  Future<void> fetchMedia() async {
    isLoading.value = true;
    hasError.value = '';

    final request = ListMediaRequest(
      order: Order.desc,
      perPage: 100,
      orderBy: OrderBy.date,
    );
    final response = await connx.media.list(request);

    response.map(
      onSuccess: (res) => media.value = res.data,
      onFailure: (err) => hasError.value = err.error?.message ?? 'Error',
    );

    isLoading.value = false;
  }

  Future<List<Media>> fetchMediaByIds(List<int> ids) async {
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

  Map<int, List<Media>> get mediaByPost {
    final map = <int, List<Media>>{};
    for (var med in media) {
      if (med.post != null) {
        map.putIfAbsent(med.post!, () => []).add(med);
      }
    }
    return map;
  }

  // Build a lookup map by id for fast access
  Map<int, Media> get mediaMap => {for (var med in media) med.id: med};

  @override
  void onInit() {
    super.onInit();
    fetchMedia();
  }
}
