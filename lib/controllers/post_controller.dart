import 'package:get/get.dart';
import 'package:main_sony/controllers/category_controller.dart';
import 'package:main_sony/controllers/media_controller.dart';
import 'package:main_sony/controllers/tag_controller.dart';
import 'package:main_sony/controllers/user_controller.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'api_provider.dart';

class PostController extends ApiProvider {
  final _category = Get.put(CategoryController());
  final _user = Get.put(UserController());
  final _media = Get.put(MediaController());
  final _tag = Get.put(TagController());

  // Reactive lists
  var items = <Post>[].obs;
  RxInt get selectedIndex => _category.selectedIndex;

  // Store last filter type and value
  int? _currentFilterId;
  int _currentFilterType = 0; // 1=category, 2=author, 3=tag, 0=all

  // Main fetch
  Future<void> fetchItems({int? pageNum, int? byId, int type = 0}) async {
    isLoading.value = true;
    hasError.value = '';

    // Save filter params
    _currentFilterId = byId;
    _currentFilterType = type;

    // Define variables for filters
    List<int>? categories;
    List<int>? authors;
    List<int>? tags;

    // Switch logic for assigning the correct filter
    switch (type) {
      case 1:
        categories = [?byId];
        break;
      case 2:
        authors = [?byId];
        break;
      case 3:
        tags = [?byId];
        break;
      default:
        // no filter
        break;
    }

    if (pageNum != null) page.value = pageNum;

    try {
      // Fetch posts
      final request = ListPostRequest(
        order: Order.desc,
        perPage: perPage,
        page: page.value,
        categories: categories,
        author: authors,
        tags: tags,
        orderBy: OrderBy.date,
      );
      final response = await connx.posts.list(request);

      response.map(
        onSuccess: (res) {
          items.value = res.data;
          totalPages.value = (res.totalCount / perPage).ceil();

          // AUTO-CORRECT: If current page > totalPages, reset to last page and refetch!
          if (page.value > totalPages.value && totalPages.value > 0) {
            page.value = totalPages.value;
            fetchItems(
              pageNum: page.value,
              byId: byId,
              type: type,
            ); // Re-call with valid page
            return;
          }
        },
        onFailure: (err) =>
            hasError.value = err.error?.message ?? 'Failure on load data',
      );

      final featuredIds = items
          .map((p) => p.featuredMedia)
          .whereType<int>()
          .toSet();
      if (featuredIds.isNotEmpty) {
        final mediaResult = await _media.fetchItemByIds(featuredIds.toList());
        _media.items.value = mediaResult;
      }
    } catch (e) {
      hasError.value = e.toString();
    }

    isLoading.value = false;
  }

  Map<int, Media> get mediaMap => _media.itemMap;

  //Category
  List<MapEntry<int, String>> Function(Post post) get categories =>
      _category.categories;
  List<MapEntry<int, String>> Function(Post post) get tags => _tag.tags;

  //Tag
  List<int> Function(Post post) get tagIds => _tag.tagIds;
  List<String> Function(Post post) get tagNames => _tag.tagNames;

  //User
  String Function(Post post) get authorName => _user.authorName;

  // Refresh current page
  // This will always refresh using the last filter (category/tag/author)
  Future<void> refreshCurrentPage() async {
    await fetchItems(
      pageNum: page.value,
      byId: _currentFilterId,
      type: _currentFilterType,
    );
  }

  // Go to specific page
  void goToPage(int pageNum) {
    fetchItems(
      byId: _currentFilterId,
      type: _currentFilterType,
      pageNum: pageNum,
    );
  }

  void nextPage() {
    if (page.value < totalPages.value && !isLoading.value) {
      goToPage(page.value + 1);
    }
  }

  void prevPage() {
    if (page.value > 1 && !isLoading.value) {
      goToPage(page.value - 1);
    }
  }

  void dataView({int type = 0, int? id}) {
    _currentFilterType = type;
    _currentFilterId = id;
    switch (type) {
      case 1:
        fetchItems(byId: id, type: 1, pageNum: 1);
        break;
      case 2:
        fetchItems(byId: id, type: 2, pageNum: 1);
        break;
      case 3:
        fetchItems(byId: id, type: 3, pageNum: 1);
        break;
      default:
        fetchItems(pageNum: 1);
    }
  }

  // Reactive variables
  @override
  void onInit() {
    super.onInit();
    dataView();
  }

  @override
  void onClose() {
    super.onClose();
    hasError.value = '';
    isLoading.value = false;
  }
}
