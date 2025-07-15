import 'package:main_sony/views/export_views.dart';

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  /// Number of page neighbors to show around the current page.
  final int visibleRange;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
    this.visibleRange = 1,
  });

  List<Widget> _buildPageItems(BuildContext context, int currentPageParam) {
    List<Widget> widgets = [];

    Color selectedColor = Colors.teal;
    Color normalColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;

    void addPage(int page) {
      bool selected = page == currentPageParam;
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Material(
            color: selected ? selectedColor : Colors.transparent,
            shape: selected ? const CircleBorder() : null,
            child: InkWell(
              onTap: selected ? null : () => onPageSelected(page),
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                child: Text(
                  '$page',
                  style: TextStyle(
                    color: selected ? Colors.white : normalColor,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    void addEllipsis() {
      widgets.add(
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "...",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    // Disable pagination when no pages or only one page
    if (totalPages <= 1) {
      addPage(1);
      return widgets;
    }

    // PREVIOUS Button
    widgets.add(
      TextButton(
        onPressed: currentPageParam > 1
            ? () => onPageSelected(currentPageParam - 1)
            : null,
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: currentPageParam != 1 ? normalColor : null,
        ),
      ),
    );

    // Always show first page
    addPage(1);

    // Left ellipsis
    if (currentPageParam > visibleRange + 2) {
      addEllipsis();
    }

    // Middle page numbers (only if more than 2 pages)
    if (totalPages > 2) {
      int start = (currentPageParam - visibleRange).clamp(2, totalPages - 1);
      int end = (currentPageParam + visibleRange).clamp(2, totalPages - 1);
      if (start <= end) {
        for (int i = start; i <= end; i++) {
          addPage(i);
        }
      }
    }

    // Right ellipsis
    if (currentPageParam < totalPages - visibleRange - 1) {
      addEllipsis();
    }

    // Always show last page if > 1
    addPage(totalPages);

    // NEXT Button
    widgets.add(
      TextButton(
        onPressed: currentPageParam < totalPages
            ? () => onPageSelected(currentPageParam + 1)
            : null,
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          color: currentPageParam < totalPages ? normalColor : null,
        ),
      ),
    );

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    // Prevent going out of page bounds
    final int validCurrentPage = currentPage.clamp(
      1,
      totalPages > 0 ? totalPages : 1,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildPageItems(context, validCurrentPage),
      ),
    );
  }
}
