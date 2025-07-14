import '../export_views.dart';

class Pagination extends StatelessWidget {
  final int page;
  final dynamic items;
  final int totalPages;
  final ValueChanged<int> onGoToPage;
  final Widget child;

  const Pagination({
    super.key,
    required this.page,
    required this.totalPages,
    required this.onGoToPage,
    this.items,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(margin: EdgeInsets.only(bottom: 80, top: 4), child: child),
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
          ),
      ],
    );
  }
}
