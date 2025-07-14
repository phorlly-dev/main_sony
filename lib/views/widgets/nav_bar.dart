import 'package:get/get.dart';
import '../export_views.dart';

class NavBar extends StatefulWidget {
  final String title;
  final Widget? menu, content;
  final void Function(String query)? onSearch; // Callback for search query

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
    if (widget.onSearch != null) widget.onSearch!('');
  }

  void _onSearchSubmitted(String value) {
    if (widget.onSearch != null) widget.onSearch!(value.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.menu,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true, // show/hide on scroll up/down
            snap: true, // snap in/out
            pinned: false, // true = always at top
            elevation: 4,
            centerTitle: true,
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
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            leading: isSearching
                ? IconButton(icon: Icon(Icons.close), onPressed: _stopSearch)
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
          // Main content - as a sliver
          SliverToBoxAdapter(child: widget.content),
        ],
      ),
    );
  }
}
