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
    if (isLoading == true) {
      return Container(
        margin: EdgeInsets.only(top: Get.height * .3),
        child: LoadingAnimation(),
      );
    }
    if (hasError!.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(top: Get.height * .3),
        child: LoadingAnimation(
          label: hasError!,
          type: 11,
          themColor: AppColorRole.error,
        ),
      );
    }
    if (notFound == null || notFound!.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: Get.height * .3),
        child: LoadingAnimation(
          label: "No data found.",
          type: 5,
          themColor: AppColorRole.secondary,
        ),
      );
    }

    return ListView.builder(
      itemCount: itemCounter,
      itemBuilder: itemBuilder,
      physics: NeverScrollableScrollPhysics(), // Not scrollable
      shrinkWrap: true, // Take only needed space
    );
  }
}
