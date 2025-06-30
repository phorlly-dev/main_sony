import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final int index;
  final dynamic item;
  const PostCard({super.key, required this.index, required this.item});

  @override
  Widget build(BuildContext context) {
    //calculate the screen
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isFullScreenCard = isLandscape && index == 0; // first card only

    //get item from api
    // final yoast = item?.yoastHeadJson;
    // final imageUrl = (yoast?.ogImage?.isNotEmpty == true)
    //     ? yoast!.ogImage!.first.url ?? ''
    //     : '';

    return Container(
      width: isFullScreenCard ? screenWidth : null,
      height: isFullScreenCard ? screenHeight : null,
      margin: isFullScreenCard
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ImageContent(
            //   imageUrl: imageUrl,
            //   screenHeight: screenHeight,
            //   isFullScreen: isFullScreenCard,
            // ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "",
                // yoast?.title ?? '',
                style: TextStyle(
                  // fontSize: 18,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
