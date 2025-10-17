import 'export_controller.dart';
import 'package:wordpress_client/wordpress_client.dart';

class ApiProvider extends GetxController {
  final _apiUrl = 'https://soepress.com/wp-json/wp/v2';
  late WordpressClient cnx;
  late GetConnect api;
  var classLists = <int, List<String>>{}.obs;
  var yoasts = <int, Map<String, dynamic>>{}.obs;
  var isLoading = false.obs;
  var totalPages = 1.obs;
  var hasError = ''.obs;
  var page = 1.obs;
  var perPage = 6.obs;
  var selectedItem = "home".obs;

  String get apiUrl => _apiUrl; // optional getter

  void setActiveMenu(String item) {
    selectedItem.value = item;
  }

  List<String> classListFor(int id) => classLists[id] ?? const [];
  Map<String, dynamic>? yoastFor(int id) => yoasts[id];
  String? ogImageUrl(int id) {
    final y = yoasts[id];
    if (y == null) return null;
    final images = (y['og_image'] as List?)?.cast<Map<String, dynamic>>();
    return images?.isNotEmpty == true ? images!.first['url'] as String? : null;
  }

  Future<void> fetchExtrasForPostIds(List<int> ids) async {
    // Don’t re-fetch ones we already have
    final pending = ids
        .where((id) => !classLists.containsKey(id) || !yoasts.containsKey(id))
        .toList();
    if (pending.isEmpty) return;

    final url =
        '$apiUrl/posts'
        '?include=${pending.join(",")}'
        '&per_page=${pending.length}'
        '&_fields=id,class_list,yoast_head_json';

    final response = await api.get(url);
    if (response.statusCode == 200 && response.isOk) {
      final data = response.body;
      if (data is List) {
        for (final row in data.cast<Map<String, dynamic>>()) {
          final id = row['id'] as int;

          // Normalize class_list (map or list -> List<String>)
          final raw = row['class_list'];
          final classes = raw is Map
              ? raw.values.map((v) => v.toString()).toList()
              : raw is List
              ? raw.map((e) => e.toString()).toList()
              : const <String>[];
          classLists[id] = classes;

          // Yoast head JSON as a map
          final yoast = row['yoast_head_json'];
          if (yoast is Map<String, dynamic>) {
            yoasts[id] = yoast;
          }
        }
      }
    } else {
      throw Exception('Failed to fetch extras for posts');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCustomFieldsForIds({
    required String slug,
    required List<int> ids,
    required List<String> fields,
  }) async {
    final include = ids.join(',');
    final url =
        '$apiUrl/$slug'
        '?include=$include'
        '&per_page=${ids.length}'
        '&_fields=id,${fields.join(",")}';
    final r = await api.get(url);
    if (r.statusCode == 200 && r.isOk && r.body is List) {
      return (r.body as List).cast<Map<String, dynamic>>();
    }
    return const [];
  }

  @override
  void onInit() {
    super.onInit();
    cnx = WordpressClient(baseUrl: Uri.parse(_apiUrl));
    api = GetConnect();
  }

  @override
  void onClose() {
    // Clean up if needed
    cnx.clearDiscoveryCache();
    super.onClose();
  }
}
