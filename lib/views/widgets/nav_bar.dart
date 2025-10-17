import 'package:main_sony/views/export_views.dart';

class NavBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final void Function(String query)? onSearch;
  const NavBar({super.key, required this.title, this.onSearch});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool isSearching = false;
  final _searchController = TextEditingController();

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
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: !isSearching,
      title: isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search…',
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: _onSearchSubmitted,
            )
          : Text(widget.title.replaceAll('-', ' ').toUpperCase()),
      leading: isSearching
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: _stopSearch,
              tooltip: 'Close search',
            )
          : null,
      actions: [
        if (!isSearching && widget.onSearch != null)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _startSearch,
            tooltip: 'Search',
          ),
      ],
    );
  }
}
