import 'package:get/get.dart';
import 'package:main_sony/controllers/api_provider.dart';
import 'package:main_sony/controllers/media_controller.dart';
import 'package:main_sony/controllers/user_controller.dart';
import 'package:wordpress_client/wordpress_client.dart';

class PostListController extends ApiProvider {
  final _media = Get.put(MediaController());
  final _user = Get.put(UserController());

  // Data stores
  final RxList<Post> allPosts = <Post>[].obs;
  final RxList<Media> allMedia = <Media>[].obs;
  final RxList<Post> pagedPosts = <Post>[].obs;

  final RxBool isLoading = false.obs;
  final RxString hasError = ''.obs;

  final RxInt page = 1.obs;
  final RxInt perPage = 5.obs;
  final RxInt _currentUser = 0.obs;
  final RxString _currentSlug = ''.obs;

  int get totalViewPages =>
      ((filteredPosts.length / perPage.value).ceil()).clamp(1, 999);

  // --- FILTER LOGIC ---
  List<Post> get filteredPosts {
    final slug = _currentSlug.value.trim();
    final userId = _currentUser.value;

    List<Post> posts = allPosts;

    // Filter by user if set
    if (userId != 0) {
      posts = posts.where((post) => post.author == userId).toList();
    }

    // Filter by slug (category/tag) if set
    if (slug.isNotEmpty) {
      posts = posts.where((post) {
        final cl = post.classList ?? [];
        return cl.any((c) => c == 'category-$slug' || c == 'tag-$slug');
      }).toList();
    }

    return posts;
  }

  // --- FETCH ALL POSTS ---
  Future<void> fetchAllPosts({int? userId}) async {
    isLoading.value = true;
    hasError.value = '';
    allPosts.clear();
    allMedia.clear();

    List<int>? authors;
    if (userId != null && userId != 0) authors = [userId];
    if (userId != null) _currentUser.value = userId;

    try {
      int currPage = 1;
      int lastPage = 1;

      do {
        final request = ListPostRequest(
          order: Order.desc,
          perPage: 100,
          page: currPage,
          author: authors,
          orderBy: OrderBy.date,
        );
        final response = await connx.posts.list(request);

        bool keepFetching = false;
        await response.map(
          onSuccess: (res) async {
            final fetchedPosts = res.data;
            allPosts.addAll(fetchedPosts);

            // Media
            final ids = fetchedPosts
                .map((p) => p.featuredMedia)
                .whereType<int>()
                .toSet();
            if (ids.isNotEmpty) {
              final mediaResult = await _media.fetchItemByIds(ids.toList());
              allMedia.addAll(mediaResult);
            }
            lastPage = ((res.totalCount / 100).ceil()).clamp(1, 999);
            keepFetching = currPage < lastPage;
          },
          onFailure: (err) {
            hasError.value = err.error?.message ?? 'Failure on load data';
            keepFetching = false;
          },
        );
        currPage++;
        if (!keepFetching) break;
      } while (currPage <= lastPage);

      // Don't reset page! Just re-apply filter/page
      _updatePagedPosts();
    } catch (e) {
      hasError.value = e.toString();
    }
    isLoading.value = false;
  }

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
      rethrow;
    }
  }

  // --- PAGINATION AND FILTER ---
  void applyFilterAndPaginate({String? slug, int? userId}) {
    bool filterChanged = false;

    if (slug != null && slug != _currentSlug.value) {
      _currentSlug.value = slug;
      filterChanged = true;
    }
    if (userId != null && userId != _currentUser.value) {
      _currentUser.value = userId;
      filterChanged = true;
    }

    // If filter changes, reset to first page
    if (filterChanged) {
      page.value = 1;
    }
    _updatePagedPosts();
  }

  void goToPage(int newPage) {
    page.value = newPage.clamp(1, totalViewPages);
    _updatePagedPosts();
  }

  // Update pagedPosts based on filter/page/perPage
  void _updatePagedPosts() {
    final all = filteredPosts;
    final from = (page.value - 1) * perPage.value;
    final to = (from + perPage.value).clamp(0, all.length);
    pagedPosts.value = all.sublist(
      from.clamp(0, all.length),
      to.clamp(0, all.length),
    );
  }

  // --- STAY ON CURRENT PAGE ON REFRESH ---
  Future<void> refreshCurrentPage() async {
    final int curPage = page.value;
    await fetchAllPosts(userId: _currentUser.value);
    // After refetch, reapply filter and go to same page
    goToPage(curPage);
  }

  // --- MISC ---
  Map<int, Media> get mediaMap => {for (var res in allMedia) res.id: res};
  String Function(Post post) get authorName => _user.authorName;

  @override
  void onInit() {
    super.onInit();
    fetchAllPosts();
  }
}
