import 'package:flutter/material.dart';

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
      return Center(child: CircularProgressIndicator());
    }
    if (hasError!.isNotEmpty) {
      return Center(child: Text(hasError!));
    }
    if (notFound == null || notFound!.isEmpty) {
      return Center(child: Text("No data found."));
    }

    return Column(children: List.generate(length, (index) => child(index)));
  }
}
