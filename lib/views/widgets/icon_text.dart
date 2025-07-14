import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final String label;
  final IconData? icon;
  final double? iconSize, textSize;
  final Color? color;
  final VoidCallback? onTap;

  const IconText({
    super.key,
    required this.label,
    this.icon = Icons.menu_open_rounded,
    this.iconSize = 16,
    this.textSize = 12,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(icon, size: iconSize, color: color ?? Colors.grey[600]),
          ),
          WidgetSpan(child: SizedBox(width: 4)),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: textSize,
                  color: color ?? Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
