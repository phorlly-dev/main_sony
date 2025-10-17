import 'package:main_sony/views/export_views.dart';

class PageDataView<T> extends StatelessWidget {
  final List<T> items;
  final int page;
  final int totalPages;
  final bool isLoading;
  final String? hasError;
  final String noDataMessage;
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
    required this.noDataMessage,
  });

  @override
  Widget build(BuildContext context) {
    // Prevent out-of-bounds page
    final safePage = page.clamp(1, totalPages > 0 ? totalPages : 1);

    // If there are no items and an error is present, show the error
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 76, top: 4),
          child: DataView<T>(
            isLoading: isLoading && items.isEmpty,
            hasError: hasError,
            noDataMessage: noDataMessage,
            notFound: items,
            itemCounter: items.length,
            itemBuilder: (context, index) =>
                itemBuilder(context, items[index], index),
          ),
        ),

        // Show pagination bar only if there are multiple pages and items
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
