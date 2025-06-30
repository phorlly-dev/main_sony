import 'package:flutter/material.dart';

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
      return Center(child: CircularProgressIndicator());
    }
    if (hasError!.isNotEmpty) {
      return Center(child: Text(hasError!));
    }
    if (notFound == null || notFound!.isEmpty) {
      return Center(child: Text("No data found."));
    }

    return ListView.builder(itemCount: itemCounter, itemBuilder: itemBuilder);
  }
}
