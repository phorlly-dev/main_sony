import 'package:main_sony/views/export_views.dart';

class BodyContent extends StatelessWidget {
  final Widget? menu, content, button;
  final PreferredSizeWidget? header;

  const BodyContent({
    super.key,
    this.menu,
    this.content,
    this.button,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header,
      drawer: menu == null ? null : SafeArea(child: menu!),
      body: SafeArea(child: content ?? SizedBox.shrink()),
      floatingActionButton: button,
    );
  }
}

 //  CustomScrollView(
      //   slivers: [
      //     SliverAppBar(
      //       floating: true,
      //       snap: true,
      //       pinned: false,
      //       elevation: 4,
      //       centerTitle: true,
      //       backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      //       automaticallyImplyLeading:
      //           !isSearching, // Menu icon when not searching
      //       title: isSearching
      //           ? TextField(
      //               controller: _searchController,
      //               autofocus: true,
      //               decoration: InputDecoration(
      //                 hintText: 'Search...',
      //                 border: InputBorder.none,
      //               ),
      //               textInputAction: TextInputAction.search,
      //               onSubmitted: _onSearchSubmitted,
      //             )
      //           : Text(widget.title.toUpperCase()),
      //       leading: isSearching
      //           ? IconButton(
      //               icon: Icon(Icons.close, semanticLabel: 'Close search'),
      //               onPressed: _stopSearch,
      //             )
      //           : null,
      //       actions: [
      //         if (!isSearching && widget.onSearch != null)
      //           IconButton(
      //             icon: Icon(Icons.search, semanticLabel: 'Search'),
      //             onPressed: _startSearch,
      //             tooltip: 'Search',
      //           ),
      //         IconButton(
      //           icon: Icon(
      //             isDark ? Icons.light_mode : Icons.dark_mode,
      //             semanticLabel: 'Toggle theme',
      //           ),
      //           onPressed: () {
      //             Get.changeTheme(
      //               isDark ? ThemeData.light() : ThemeData.dark(),
      //             );
      //             setState(() {
      //               isDark = !isDark;
      //             });
      //           },
      //           tooltip: 'Toggle Theme',
      //         ),
      //       ],
      //     ),
      //     SliverToBoxAdapter(child: widget.content),
      //   ],
      // ),