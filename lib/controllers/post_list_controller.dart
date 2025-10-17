import 'package:wordpress_client/wordpress_client.dart';

import 'export_controller.dart';

class PostListController extends ApiProvider {
  final _media = Get.put(MediaController());
  final _user = Get.put(UserController());

  // Data stores
  final RxList<Post> _allPosts = <Post>[].obs;
  final RxList<Media> _allMedia = <Media>[].obs;
  final RxList<Post> pagedPosts = <Post>[].obs;
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
    _allMedia.clear();

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
            _allPosts.addAll(fetchedPosts);

            // Media fetching as before
            final ids = fetchedPosts
                .map((p) => p.featuredMedia)
                .whereType<int>()
                .toSet();
            if (ids.isNotEmpty) {
              final mediaResult = await _media.fetchItemByIds(ids.toList());
              _allMedia.addAll(mediaResult);
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
  void applyFilterAndPaginate({
    String? slug,
    int? userId,
    bool clearSearch = false,
  }) {
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
    pagedPosts.value = all.sublist(
      from.clamp(0, all.length),
      to.clamp(0, all.length),
    );
  }

  // --- STAY ON CURRENT PAGE ON REFRESH ---
  Future<void> refreshCurrentPage() async {
    final int curPage = page.value;
    if (pageCount.value <= 24 || _allPosts.isEmpty) {
      await _fetchAllPosts(userId: _currentUser.value);
    }
    // After refetch, reapply filter and go to same page
    goToPage(curPage);
  }

  // --- MISC ---
  Map<int, Media> get mediaMap => {for (var res in _allMedia) res.id: res};
  User? Function(Post post) get authorName => _user.authorName;

  Future<void> fetchFirstPage({int? userId, String? search}) async {
    isLoading.value = true;
    hasError.value = '';
    _allPosts.clear();
    _allMedia.clear();
    page.value = 1;
    hasMore.value = true;

    try {
      await _fetchPage(1, userId: userId, search: search);
      _updatePagedPosts(); // show something NOW
      // optionally kick off prefetch of page 2 in background
      unawaited(loadMore());
    } catch (e) {
      hasError.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    isLoading.value = true;
    try {
      final next = ((_allPosts.length ~/ 100) + 1);
      await _fetchPage(
        next,
        userId: _currentUser.value,
        search: searchQuery.value,
      );
      _updatePagedPosts();
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch only ONE page (100 was your batch size; use 10–20 for faster paints)
  Future<void> _fetchPage(int currPage, {int? userId, String? search}) async {
    final authors = (userId != null && userId != 0) ? [userId] : null;

    final request = ListPostRequest(
      order: Order.desc,
      perPage: pageCount.value, // smaller -> faster
      page: currPage,
      author: authors,
      search: search ?? searchQuery.value,
      orderBy: OrderBy.date,
    );

    final response = await cnx.posts.list(request);
    await response.map(
      onSuccess: (res) async {
        final fetched = res.data;

        _allPosts.addAll(fetched);

        // batch media fetch (already ok); keep it concurrent with await
        final ids = fetched
            .map((p) => p.featuredMedia)
            .whereType<int>()
            .toSet();
        if (ids.isNotEmpty) {
          final media = await _media.fetchItemByIds(ids.toList());
          _allMedia.addAll(media);
        }

        await fetchExtrasForPostIds(fetched.map((p) => p.id).toList());

        // stop when last page
        final lastPage = ((res.totalCount / request.perPage).ceil()).clamp(
          1,
          999,
        );
        hasMore.value = currPage < lastPage;
      },
      onFailure: (err) {
        hasError.value = err.error?.message ?? 'Failure on load data';
        hasMore.value = false;
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    fetchFirstPage();
    // _fetchAllPosts();
  }
}
