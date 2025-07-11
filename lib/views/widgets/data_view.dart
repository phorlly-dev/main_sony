import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/utils/constants.dart';
import 'package:main_sony/views/widgets/loading_animation.dart';

class DataView extends StatelessWidget {
  final int itemCounter;
  final bool? isLoading;
  final String? hasError;
  final List<dynamic>? notFound;
  final NullableIndexedWidgetBuilder itemBuilder;

  const DataView({
    super.key,
    required this.itemBuilder,
    required this.itemCounter,
    this.isLoading = false,
    this.hasError = '',
    this.notFound = const [],
  });

  @override
  Widget build(BuildContext context) {
    // If loading, show a loading animation
    if (isLoading == true) {
      return Container(
        margin: EdgeInsets.only(top: Get.height * .3),
        child: LoadingAnimation(),
      );
    }

    // If an error is present, show the error message
    if (hasError!.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(top: Get.height * .3),
        child: LoadingAnimation(
          label: hasError!,
          type: LoadingType.flickr,
          themColor: AppColorRole.error,
        ),
      );
    }

    // If no items are found and notFound is empty, show a loading animation
    if (notFound == null || notFound!.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: Get.height * .3),
        child: LoadingAnimation(
          label: "No data found.",
          type: LoadingType.staggeredDotsWave,
          themColor: AppColorRole.secondary,
        ),
      );
    }

    // If items are found, display them in a ListView
    return ListView.builder(
      itemCount: itemCounter,
      itemBuilder: itemBuilder,
      physics: NeverScrollableScrollPhysics(), // Not scrollable
      shrinkWrap: true, // Take only needed space
    );
  }
}
