import 'dart:math';

import 'package:wordpress_client/wordpress_client.dart';
import 'export_controller.dart';

class PostListController extends ApiProvider<Post> {
  final _media = Get.put(MediaController());
  final _user = Get.put(UserController());

  // Data stores
  final RxList<Post> _allPosts = <Post>[].obs;
  final RxBool hasMore = true.obs;
  final RxInt _currentUser = 0.obs;
  final RxString _currentSlug = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxInt pageCount = 24.obs;

  int get totalViewPages =>
      ((_filteredPosts.length / perPage.value).ceil()).clamp(1, 999);

  // --- FILTER LOGIC ---
  List<Post> get _filteredPosts {
    final slug = _currentSlug.value.trim();
    final userId = _currentUser.value;
    final query = searchQuery.value.trim().toLowerCase();

    List<Post> posts = _allPosts;

    // Filter by user if set
    if (userId != 0) {
      posts = posts.where((post) => post.author == userId).toList();
    }

    // Filter by slug (category/tag) if set
    if (slug.isNotEmpty) {
      posts = posts.where((post) {
        final cl = classListFor(post.id);
        return cl.any((c) => c == 'category-$slug' || c == 'tag-$slug');
      }).toList();
    }

    // Filter by search query if set
    if (query.isNotEmpty) {
      posts = posts.where((post) {
        final title = post.title?.rendered?.toLowerCase() ?? '';
        final excerpt = post.excerpt?.rendered?.toLowerCase() ?? '';
        // You can add more fields as needed!
        return title.contains(query) || excerpt.contains(query);
      }).toList();
    }

    return posts;
  }

  // --- FETCH ALL POSTS ---
  Future<void> _fetchAllPosts({int? userId, String? search}) async {
    isLoading.value = true;
    hasError.value = '';
    _allPosts.clear();
    _media.items.clear();

    List<int>? authors;
    if (userId != null && userId != 0) authors = [userId];
    if (userId != null) _currentUser.value = userId;

    try {
      int currPage = 1;
      int lastPage = 1;

      pageCount.value = 100; // Fetch in larger batches for all-posts
      do {
        final request = ListPostRequest(
          order: Order.desc,
          perPage: pageCount.value,
          page: currPage,
          author: authors,
          search: search ?? searchQuery.value,
          orderBy: OrderBy.date,
        );
        final response = await cnx.posts.list(request);

        bool keepFetching = false;
        await response.map(
          onSuccess: (res) async {
            final fetchedPosts = res.data;
            fetchedPosts.shuffle(Random());
            _allPosts.addAll(fetchedPosts);

            // Media fetching as before
            final ids = fetchedPosts
                .map((p) => p.featuredMedia)
                .whereType<int>()
                .toSet();
            if (ids.isNotEmpty) {
              final mediaResult = await _media.fetchItemByIds(ids.toList());
              _media.items.addAll(mediaResult);
            }
            // NEW: fetch extras for these posts
            await fetchExtrasForPostIds(fetchedPosts.map((p) => p.id).toList());

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
    } finally {
      isLoading.value = false;
    }
  }

  Future<Post> fetchItemById(int postId) async {
    try {
      final request = RetrievePostRequest(id: postId);
      final response = await cnx.posts.retrieve(request);

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
  void applyFilter({String? slug, int? userId, bool clearSearch = false}) {
    bool changed = false;

    if (slug != null) {
      // allow '' to clear
      _currentSlug.value = slug;
      changed = true;
    }
    if (userId != null) {
      // allow 0 to clear
      _currentUser.value = userId;
      changed = true;
    }
    if (clearSearch) {
      searchQuery.value = '';
      changed = true;
    }

    if (changed) page.value = 1;
    _updatePagedPosts();
  }

  void search(String query) async {
    searchQuery.value = query;
    page.value = 1; // Reset to first page on search
    _currentUser.value = 0;
    await _fetchAllPosts(search: query, userId: 0); // <-- server-side search!
    _updatePagedPosts();
  }

  void goToPage(int newPage) {
    page.value = newPage.clamp(1, totalViewPages);
    _updatePagedPosts();
  }

  // Update pagedPosts based on filter/page/perPage
  void _updatePagedPosts() {
    final all = _filteredPosts;
    final from = (page.value - 1) * perPage.value;
    final to = (from + perPage.value).clamp(0, all.length);
    items.value = all.sublist(
      from.clamp(0, all.length),
      to.clamp(0, all.length),
    );
  }

  // --- STAY ON CURRENT PAGE ON REFRESH ---
  Future<void> refreshKeepingPosition() async {
    final int curPage = page.value;
    await _fetchAllPosts(userId: _currentUser.value);

    // After refetch, reapply filter and go to same page
    goToPage(curPage);
  }

  // --- MISC ---
  Map<int, Media> get mediaMap => _media.itemMapping;
  Map<int, User> get authorName => _user.itemMapping;

  @override
  void onInit() {
    super.onInit();
    _fetchAllPosts();
  }
}
