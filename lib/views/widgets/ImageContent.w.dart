import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageContent extends StatelessWidget {
  final String? imageUrl;
  final double screenHeight;
  final bool isFullScreen;
  const ImageContent({
    super.key,
    this.imageUrl,
    required this.screenHeight,
    required this.isFullScreen,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl!.isEmpty) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Icon(Icons.broken_image, size: 48),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: double.infinity,
      height: isFullScreen ? screenHeight * .6 : 200,
      fit: BoxFit.cover,
      placeholder: (context, url) => AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => const AspectRatio(
        aspectRatio: 16 / 9,
        child: Icon(Icons.broken_image, size: 48),
      ),
    );
  }
}
