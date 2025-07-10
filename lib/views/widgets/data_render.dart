import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/utils/constants.dart';
import 'package:main_sony/views/widgets/loading_animation.dart';

class DataRender extends StatelessWidget {
  final int length;
  final bool? isLoading;
  final String? hasError;
  final List<dynamic>? notFound;
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
          type: LoadingType.flickr,
          themColor: AppColorRole.error,
        ),
      );
    }
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

    return Column(children: List.generate(length, (index) => child(index)));
  }
}
