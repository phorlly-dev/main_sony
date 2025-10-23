import 'package:main_sony/views/export_views.dart';

import 'export_controller.dart';
import 'package:wordpress_client/wordpress_client.dart';

abstract class ApiProvider<T> extends GetxController {
  final _apiUrl = 'https://soepress.com/wp-json/wp/v2';
  late WordpressClient cnx;
  late GetConnect api;
  var items = <T>[].obs;
  var isLoading = false.obs;
  var totalPages = 1.obs;
  var hasError = ''.obs;
  var page = 1.obs;
  var perPage = 5.obs;
  var selectedItem = "home".obs;
  var classLists = <int, List<String>>{}.obs;
  var yoasts = <int, Map<String, dynamic>>{}.obs;
  final Map<String, int> categoryIdBySlug = {};
  final Map<String, int> tagIdBySlug = {};
  final Map<int, String> categorySlugById = {};
  final Map<int, String> tagSlugById = {};

  String get apiUrl => _apiUrl;

  void setActiveMenu(String item) {
    selectedItem.value = item;
  }

  List<String> classListFor(int id) => classLists[id] ?? const [];
  Map<String, dynamic>? yoastFor(int id) => yoasts[id];
  String? ogImageUrl(int id) {
    final y = yoasts[id];
    if (y == null) return null;
    final images = (y['og_image'] as List?)?.cast<Map<String, dynamic>>();

    return images?.isNotEmpty == true ? images?.first['url'] as String? : null;
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

  Map<int, T> get itemMapping => {for (final res in items as List) res.id: res};

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

  Future<void> preloadTaxonomies() async {
    await Future.wait([
      _fetchTaxonomy('categories', categoryIdBySlug, categorySlugById),
      _fetchTaxonomy('tags', tagIdBySlug, tagSlugById),
    ]);
  }

  Future<void> _fetchTaxonomy(
    String type,
    Map<String, int> slugToId,
    Map<int, String> idToSlug,
  ) async {
    int page = 1;
    while (true) {
      final response = await api.get(
        '$_apiUrl/$type',
        query: {
          'per_page': '100',
          'page': '$page',
          'hide_empty': 'false',
          '_fields': 'id,slug,name',
        },
      );

      if (response.statusCode != 200) break;
      final data = response.body;
      if (data is! List) break;

      for (final item in data) {
        final id = item['id'];
        final slug = item['slug'];
        slugToId[slug] = id;
        idToSlug[id] = slug;
      }

      // pagination check
      final totalPages =
          int.tryParse(
            response.headers?['x-wp-totalpages']?.split(',').first ?? '1',
          ) ??
          1;
      if (page >= totalPages) break;
      page++;
    }
  }

  Future<List<T>> getByIds({
    required String slug,
    required List<int> ids,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final url = '$_apiUrl/$slug?include=${ids.join(",")}';
    final response = await api.get(url);
    if (response.statusCode == 200 && response.isOk) {
      final data = response.body;

      if (data is List) {
        return (data).map<T>((json) => fromJson(json)).toList();
      } else if (data is Map<String, dynamic>) {
        return [fromJson(data)];
      } else {
        hasError.value = 'Unexpected response format';
        return [];
      }
    } else {
      hasError.value = 'Failed to fetched!';
      return [];
    }
  }

  Future<void> fetchList({
    required Future<WordpressResponse<List<T>>> Function() callback,
    bool append = false,
  }) async {
    isLoading.value = true;
    hasError.value = '';
    try {
      final response = await callback();
      response.map(
        onSuccess: (res) {
          if (append) {
            items.addAll(res.data);
          } else {
            items.value = res.data;
          }
        },
        onFailure: (err) =>
            hasError.value = err.error?.message ?? 'Something when wrong!',
      );
    } catch (e, st) {
      hasError.value = e.toString();
      if (kDebugMode) log('${T}Controler error: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    api = GetConnect();
    cnx = WordpressClient(baseUrl: Uri.parse(_apiUrl));
  }

  @override
  void onClose() {
    // Clean up if needed
    cnx.clearDiscoveryCache();
    super.onClose();
    hasError.value = '';
    isLoading.value = false;
  }
}
