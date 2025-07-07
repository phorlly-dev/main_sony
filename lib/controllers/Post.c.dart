import 'package:get/get.dart';
import 'package:main_sony/controllers/Category.c.dart';
import 'package:main_sony/controllers/Media.c.dart';
import 'package:main_sony/controllers/Tag.c.dart';
import 'package:main_sony/controllers/User.c.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'Api.c.dart';

class PostController extends ApiProvider {
  final _category = Get.put(CategoryController());
  final _user = Get.put(UserController());
  final _media = Get.put(MediaController());
  final _tag = Get.put(TagController());

  // Reactive lists
  var items = <Post>[].obs;
  var itemsBy = <Post>[].obs;
  RxInt get selectedIndex => _category.selectedIndex;

  // Main fetch
  Future<void> _fetchItems({int? pageNum}) async {
    isLoading.value = true;
    hasError.value = '';

    if (pageNum != null) page.value = pageNum;

    try {
      // Fetch posts
      final request = ListPostRequest(
        order: Order.desc,
        perPage: perPage,
        page: page.value,
        orderBy: OrderBy.date,
      );
      final response = await connx.posts.list(request);

      response.map(
        onSuccess: (res) {
          items.value = res.data;
          totalPages.value = (res.totalCount / perPage).ceil();
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

  Future<void> fetchItemsByCategory(int id) async {
    isLoading.value = true;
    hasError.value = '';

    try {
      // Fetch posts
      final request = ListPostRequest(
        order: Order.desc,
        categories: [id],
        orderBy: OrderBy.date,
      );
      final response = await connx.posts.list(request);

      response.map(
        onSuccess: (res) => itemsBy.value = res.data,
        onFailure: (err) =>
            hasError.value = err.error?.message ?? 'Failure on load data',
      );

      final featuredIds = itemsBy
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

  //Category
  List<MapEntry<int, String>> Function(Post post) get categories =>
      _category.categories;

  //Tag
  List<int> Function(Post post) get tagIds => _tag.tagIds;
  List<String> Function(Post post) get tagNames => _tag.tagNames;

  //User
  String Function(Post post) get authorName => _user.authorName;

  //Post by categories
  List<Post> Function(List<Post> posts, int categoryId) get filterByCategory =>
      _category.filterByCategory;

  // Refresh current page
  Future<void> refreshCurrentPage() async {
    await _fetchItems(pageNum: page.value);
  }

  // Go to specific page
  void goToPage(int pageNum) {
    if (pageNum < 1 || pageNum > totalPages.value || isLoading.value) return;
    _fetchItems(pageNum: pageNum);
  }

  // Reactive variables
  @override
  void onInit() {
    super.onInit();
    _fetchItems(pageNum: 1);
  }

  @override
  void onClose() {
    super.onClose();
    hasError.value = '';
    isLoading.value = false;
  }
}
