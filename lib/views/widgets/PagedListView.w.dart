import 'package:flutter/material.dart';
import 'package:main_sony/views/widgets/DataView.w.dart';

class PagedListView<T> extends StatelessWidget {
  final List<T> items;
  final int page;
  final int totalPages;
  final bool isLoading;
  final String? hasError;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  const PagedListView({
    super.key,
    required this.items,
    required this.page,
    required this.totalPages,
    required this.itemBuilder,
    this.isLoading = false,
    this.hasError,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 80, top: 4),
          child: DataView(
            isLoading: isLoading && items.isEmpty,
            hasError: hasError,
            notFound: items,
            itemCounter: items.length,
            itemBuilder: (context, index) =>
                itemBuilder(context, items[index], index),
          ),
        ),

        // Pagination controls (always show if >1 page)
        if (totalPages > 1 && items.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            bottom: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: page > 1 && !isLoading ? onPrev : null,
                  icon: Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: 16),
                Text('Page $page of $totalPages'),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: page < totalPages && !isLoading ? onNext : null,
                  icon: Icon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
