import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SmartCircleAvatar extends StatelessWidget {
  final String? avatar;
  final double radius;
  const SmartCircleAvatar({super.key, this.avatar, this.radius = 32});

  @override
  Widget build(BuildContext context) {
    // If the avatar URL is null or empty, show the fallback asset
    if (avatar!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        child: ClipOval(
          child: Image.asset(
            'assets/icons/KT.png',
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatar!,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: (context, url) => SizedBox(
            width: radius * 2,
            height: radius * 2,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          errorWidget: (context, url, error) => Image.asset(
            'assets/icons/KT.png',
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
