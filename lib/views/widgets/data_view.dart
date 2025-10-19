import 'package:main_sony/views/export_views.dart';

class DataView<T> extends StatelessWidget {
  final int itemCounter;
  final bool? isLoading;
  final String? hasError;
  final List<T>? notFound;
  final String noDataMessage;
  final NullableIndexedWidgetBuilder itemBuilder;

  const DataView({
    super.key,
    required this.itemBuilder,
    required this.itemCounter,
    this.isLoading = false,
    this.hasError = '',
    this.notFound = const [],
    required this.noDataMessage,
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
          label: noDataMessage,
          type: LoadingType.staggeredDotsWave,
          themeColor: AppColorRole.secondary,
        ),
      );
    }

    // If items are found, display them in a ListView

    return ListView.builder(
      itemCount: itemCounter,
      itemBuilder: itemBuilder,
      physics: NeverScrollableScrollPhysics(), // Not scrollable
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );

    // return Responsive(
    //   mobile: ListView.builder(
    //     itemCount: itemCounter,
    //     itemBuilder: itemBuilder,
    //     physics: NeverScrollableScrollPhysics(), // Not scrollable
    //     shrinkWrap: true,
    //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4).w,
    //   ),
    //   tablet: GridView.builder(
    //     itemCount: itemCounter,
    //     itemBuilder: itemBuilder,
    //     physics: NeverScrollableScrollPhysics(), // Not scrollable
    //     shrinkWrap: true,
    //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    //       maxCrossAxisExtent: 2,
    //       // crossAxisSpacing: 0,
    //       // mainAxisSpacing: 12,
    //       // childAspectRatio: .98,
    //     ),
    //   ),
    // );
  }
}
