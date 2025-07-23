import 'package:main_sony/views/export_views.dart';

class ImageContent extends StatelessWidget {
  final String? imageUrl;
  final double screenHeight;
  final bool isLandscape, isDetail;

  const ImageContent({
    super.key,
    this.imageUrl,
    required this.screenHeight,
    required this.isLandscape,
    this.isDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    // If the image URL is null or empty, show a placeholder
    if (imageUrl!.isEmpty) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Icon(Icons.broken_image, size: 48),
      );
    }

    // If the image URL is valid, show the network image
    // Use ClipRRect for rounded corners if it's a detail view
    return ClipRRect(
      borderRadius: isDetail
          ? BorderRadius.all(Radius.circular(6))
          : BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: double.infinity,
        height: isLandscape ? screenHeight.sw * 1.5 : screenHeight.sh,
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
