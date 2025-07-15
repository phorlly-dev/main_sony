import 'package:get/get.dart';
import 'package:main_sony/views/export_views.dart';

class NavBar extends StatefulWidget {
  final String title;
  final Widget? menu, content;
  final void Function(String query)? onSearch;

  const NavBar({
    super.key,
    required this.title,
    this.menu,
    this.content,
    this.onSearch,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool isDark = Get.isDarkMode;
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  void _startSearch() {
    setState(() => isSearching = true);
  }

  void _stopSearch() {
    setState(() {
      isSearching = false;
      _searchController.clear();
    });
    FocusScope.of(context).unfocus();
    if (widget.onSearch != null) widget.onSearch!('');
  }

  void _onSearchSubmitted(String value) {
    FocusScope.of(context).unfocus();
    if (widget.onSearch != null) widget.onSearch!(value.trim());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.menu,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            elevation: 4,
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            automaticallyImplyLeading:
                !isSearching, // Menu icon when not searching
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
                    icon: Icon(Icons.close, semanticLabel: 'Close search'),
                    onPressed: _stopSearch,
                  )
                : null,
            actions: [
              if (!isSearching && widget.onSearch != null)
                IconButton(
                  icon: Icon(Icons.search, semanticLabel: 'Search'),
                  onPressed: _startSearch,
                  tooltip: 'Search',
                ),
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  semanticLabel: 'Toggle theme',
                ),
                onPressed: () {
                  Get.changeTheme(
                    isDark ? ThemeData.light() : ThemeData.dark(),
                  );
                  setState(() {
                    isDark = !isDark;
                  });
                },
                tooltip: 'Toggle Theme',
              ),
            ],
          ),
          SliverToBoxAdapter(child: widget.content),
        ],
      ),
    );
  }
}
