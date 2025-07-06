import 'package:flutter/material.dart';
import 'package:main_sony/views/widgets/DataView.w.dart';
import 'package:main_sony/views/widgets/PaginationBar.w.dart';

class PagedListView<T> extends StatelessWidget {
  final List<T> items;
  final int page;
  final int totalPages;
  final bool isLoading;
  final String? hasError;
  final ValueChanged<int> onGoToPage;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  const PagedListView({
    super.key,
    required this.items,
    required this.page,
    required this.totalPages,
    required this.itemBuilder,
    this.isLoading = false,
    this.hasError,
    required this.onGoToPage,
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
            child: Center(
              child: PaginationBar(
                currentPage: page,
                totalPages: totalPages,
                onPageSelected: onGoToPage,
              ),
            ),

            //  Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     if (page != 1)
            //       IconButton(
            //         onPressed: page > 1 && !isLoading ? onPrev : null,
            //         icon: Icon(Icons.arrow_back_rounded),
            //       ),
            //     const SizedBox(width: 16),
            //     Text('Page $page of $totalPages'),
            //     const SizedBox(width: 16),

            //     // Jump to Page Dropdown
            //     DropdownButton<int>(
            //       value: page,
            //       icon: const Icon(Icons.arrow_drop_down),
            //       underline: const SizedBox(),
            //       onChanged: onGoToPage == null || isLoading
            //           ? null
            //           : (newPage) {
            //               if (newPage != null && newPage != page) {
            //                 onGoToPage!(newPage);
            //               }
            //             },
            //       items: List.generate(
            //         totalPages,
            //         (i) =>
            //             DropdownMenuItem(value: i + 1, child: Text('${i + 1}')),
            //       ),
            //     ),

            //     IconButton(
            //       onPressed: page < totalPages && !isLoading ? onNext : null,
            //       icon: Icon(Icons.arrow_forward_rounded),
            //     ),
            //   ],
            // ),
          ),
      ],
    );
  }
}
