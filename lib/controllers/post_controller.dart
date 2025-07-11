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
  final RxList<Post> items = <Post>[].obs;
  final RxBool isLoading = false.obs;
  final RxString hasError = ''.obs;
  final RxInt page = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt perPage = 5.obs;

  int? _currentUser;

  // Main fetch
  Future<void> fetchItems({int? pageNum, int? userId}) async {
    isLoading.value = true;
    hasError.value = '';

    // Define variables for filters
    List<int>? authors;
    if (userId != null) authors = [userId];
    _currentUser = userId;

    // Clamp page
    if (pageNum != null) page.value = pageNum;

    try {
      // Fetch posts
      final request = ListPostRequest(
        order: Order.desc,
        perPage: perPage.value,
        page: page.value,
        author: authors,
        orderBy: OrderBy.date,
      );
      final response = await connx.posts.list(request);

      response.map(
        onSuccess: (res) {
          items.value = res.data;
          totalPages.value = (res.totalCount / perPage.value).ceil();

          // AUTO-CORRECT: If current page > totalPages, reset to last page and refetch!
          if (page.value > totalPages.value) {
            page.value = totalPages.value;
            fetchItems(pageNum: page.value); // Re-call with valid page
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

  // Fetch a single post by ID
  Future<Post> fetchItemById(int postId) async {
    try {
      final request = RetrievePostRequest(id: postId);
      final response = await connx.posts.retrieve(request);

      return response.map(
        onSuccess: (res) => res.data,
        onFailure: (err) => throw Exception(err.error?.message),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }

    throw Exception('Failed to load post details');
  }

  Map<int, Media> get mediaMap => _media.itemMap;

  //Category
  List<MapEntry<int, String>> Function(Post post) get categories =>
      _category.categories;

  //Tag
  List<MapEntry<int, String>> Function(Post post) get tags => _tag.tags;

  //User
  String Function(Post post) get authorName => _user.authorName;

  // Refresh current page
  // This will always refresh using the last filter (category/tag/author)
  Future<void> refreshCurrentPage() async {
    await fetchItems(pageNum: page.value, userId: _currentUser);
  }

  // Go to specific page
  void goToPage(int pageNum) {
    fetchItems(userId: _currentUser, pageNum: pageNum);
  }

  void dataView({int? userId}) {
    _currentUser = userId;

    fetchItems(pageNum: 1, userId: userId);
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
