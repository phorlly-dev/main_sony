import 'package:flutter/material.dart';

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
    this.visibleRange = 1, // 1 or 2 depending on your taste
  });

  List<Widget> _buildPageItems(BuildContext context) {
    List<Widget> widgets = [];

    Color selectedColor = Colors.teal;
    Color normalColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;

    void addPage(int page) {
      bool selected = page == currentPage;
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Material(
            color: selected ? selectedColor : Colors.transparent,
            shape: selected ? const CircleBorder() : null,
            child: InkWell(
              // borderRadius: BorderRadius.circular(38),
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

    // PREVIOUS Button
    if (currentPage != 1) {
      widgets.add(
        TextButton(
          onPressed: currentPage > 1
              ? () => onPageSelected(currentPage - 1)
              : null,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            // size: 20,
            color: normalColor,
          ),
        ),
      );
    }

    // Always show first page
    addPage(1);

    // Left ellipsis
    if (currentPage > visibleRange + 2) {
      addEllipsis();
    }

    // Middle page numbers
    int start = (currentPage - visibleRange).clamp(2, totalPages - 1);
    int end = (currentPage + visibleRange).clamp(2, totalPages - 1);
    for (int i = start; i <= end; i++) {
      addPage(i);
    }

    // Right ellipsis
    if (currentPage < totalPages - visibleRange - 1) {
      addEllipsis();
    }

    // Always show last page if > 1
    if (totalPages > 1) {
      addPage(totalPages);
    }

    // NEXT Button
    widgets.add(
      TextButton(
        onPressed: currentPage < totalPages
            ? () => onPageSelected(currentPage + 1)
            : null,
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          // size: 20,
          color: normalColor,
        ),
      ),
    );

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildPageItems(context),
      ),
    );
  }
}
