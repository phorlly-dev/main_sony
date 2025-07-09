import 'package:flutter/material.dart';
import 'package:main_sony/views/widgets/data_view.dart';
import 'package:main_sony/views/widgets/pagination_bar.dart';

class PageDataView<T> extends StatelessWidget {
  final List<T> items;
  final int page;
  final int totalPages;
  final bool isLoading;
  final String? hasError;
  final ValueChanged<int> onGoToPage;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  const PageDataView({
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
    // Prevent out-of-bounds page
    final safePage = page.clamp(1, totalPages > 0 ? totalPages : 1);

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 76, top: 4),
          child: DataView(
            isLoading: isLoading && items.isEmpty,
            hasError: hasError,
            notFound: items,
            itemCounter: items.length,
            itemBuilder: (context, index) =>
                itemBuilder(context, items[index], index),
          ),
        ),

        if (totalPages > 1 && items.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: Center(
              child: PaginationBar(
                currentPage: safePage,
                totalPages: totalPages,
                onPageSelected: onGoToPage,
              ),
            ),
          ),
      ],
    );
  }
}
