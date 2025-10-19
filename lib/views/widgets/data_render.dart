import 'package:main_sony/views/export_views.dart';

class DataRender<T> extends StatelessWidget {
  final int length;
  final bool? isLoading;
  final String? hasError;
  final List<T>? notFound;
  final Widget Function(int index) child;

  const DataRender({
    super.key,
    required this.length,
    required this.child,
    this.isLoading,
    this.hasError,
    this.notFound,
  });

  @override
  Widget build(BuildContext context) {
    // If loading, show a loading animation
    if (isLoading == true) {
      return Container(
        margin: EdgeInsets.only(top: .3.sh),
        child: LoadingAnimation(),
      );
    }

    // If an error is present, show the error message
    if (hasError!.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(top: .3.sh),
        child: LoadingAnimation(
          label: hasError!,
          type: LoadingType.flickr,
          themeColor: AppColorRole.error,
        ),
      );
    }

    // If no items are found and notFound is empty, show a loading animation
    if (notFound == null || notFound!.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: .3.sh),
        child: LoadingAnimation(
          label: "No data found.",
          type: LoadingType.staggeredDotsWave,
          themeColor: AppColorRole.secondary,
        ),
      );
    }

    // If items are found, display them in a Column
    return Column(children: List.generate(length, (index) => child(index)));
  }
}
