import 'package:main_sony/views/export_views.dart';

class NavBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final void Function(String query)? onSearch;

  const NavBar({super.key, required this.title, this.onSearch});

  @override
  State<NavBar> createState() => _NavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NavBarState extends State<NavBar> {
  bool isDark = Get.isDarkMode;
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  void _startSearch() => setState(() => isSearching = true);

  void _stopSearch() {
    setState(() {
      isSearching = false;
      _searchController.clear();
    });
    FocusScope.of(context).unfocus();
    widget.onSearch?.call('');
  }

  void _onSearchSubmitted(String value) {
    FocusScope.of(context).unfocus();
    widget.onSearch?.call(value.trim());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: !isSearching, // Menu icon when not searching
        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: _onSearchSubmitted,
              )
            : Text(widget.title.toUpperCase()),
        leading: isSearching
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: _stopSearch,
                tooltip: 'Close search',
              )
            : null,
        actions: [
          if (!isSearching && widget.onSearch != null)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _startSearch,
              tooltip: 'Search',
            ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              Get.changeTheme(isDark ? ThemeData.light() : ThemeData.dark());
              setState(() {
                isDark = !isDark;
              });
            },
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
    );
  }
}
