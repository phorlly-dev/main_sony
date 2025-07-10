import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageContent extends StatelessWidget {
  final String? imageUrl;
  final double screenHeight;
  final bool isLandscape, isDetail;

  const ImageContent({
    super.key,
    this.imageUrl,
    this.screenHeight = 200,
    required this.isLandscape,
    this.isDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl!.isEmpty) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Icon(Icons.broken_image, size: 48),
      );
    }

    return ClipRRect(
      borderRadius: isDetail
          ? BorderRadius.all(Radius.circular(6))
          : BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: double.infinity,
        height: isLandscape ? screenHeight : 160,
        fit: BoxFit.cover,
        placeholder: (context, url) => AspectRatio(
          aspectRatio: 16 / 9,
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => const AspectRatio(
          aspectRatio: 16 / 9,
          child: Icon(Icons.broken_image, size: 48),
        ),
      ),
    );
  }
}
