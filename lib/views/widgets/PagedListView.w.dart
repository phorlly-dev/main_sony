import 'package:flutter/material.dart';

class PagedListView<T> extends StatefulWidget {
  final List<T> items;
  final int itemsPerPage;
  final Widget Function(BuildContext, T, int) itemBuilder;

  const PagedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.itemsPerPage = 5,
  });

  @override
  State<PagedListView<T>> createState() => _PagedListViewState<T>();
}

class _PagedListViewState<T> extends State<PagedListView<T>> {
  int currentPage = 0;
  bool showPagination = false;
  final ScrollController _scrollController = ScrollController();

  int get totalPages => (widget.items.length / widget.itemsPerPage).ceil();

  List<T> get currentItems {
    final start = currentPage * widget.itemsPerPage;
    final end = (start + widget.itemsPerPage).clamp(0, widget.items.length);
    return widget.items.sublist(start, end);
  }

  void nextPage() {
    if (currentPage < totalPages - 1) {
      setState(() => currentPage++);
      // Scroll to top of list when changing page
      _scrollController.jumpTo(0);
      showPagination = false;
    }
  }

  void prevPage() {
    if (currentPage > 0) {
      setState(() => currentPage--);
      _scrollController.jumpTo(0);
      showPagination = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // If user scrolls to the end, show pagination
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 20) {
        if (!showPagination) setState(() => showPagination = true);
      } else {
        if (showPagination) setState(() => showPagination = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: currentItems.length,
            itemBuilder: (context, index) =>
                widget.itemBuilder(context, currentItems[index], index),
          ),
        ),

        // Pagination controls appear only if showPagination is true
        if (showPagination)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: currentPage > 0 ? prevPage : null,
                  icon: Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: 16),
                Text('Page ${currentPage + 1} of $totalPages'),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: currentPage < totalPages - 1 ? nextPage : null,
                  icon: Icon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
