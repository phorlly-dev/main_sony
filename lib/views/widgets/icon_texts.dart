import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class IconTexts extends StatelessWidget {
  final List<String> labels;
  final IconData? icon;
  final double? iconSize, textSize;
  final Color? color;
  final List<VoidCallback?>? onLabelTaps;

  const IconTexts({
    super.key,
    required this.labels,
    this.icon = Icons.menu_open_rounded,
    this.iconSize = 18,
    this.textSize = 13,
    this.color,
    this.onLabelTaps,
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
          ...List.generate(
            labels.length,
            (i) => TextSpan(
              text: (i == 0 ? '' : ', ') + labels[i],
              style: TextStyle(
                fontSize: textSize,
                color: color ?? Colors.grey[600],
              ),
              recognizer:
                  onLabelTaps != null &&
                      onLabelTaps!.length > i &&
                      onLabelTaps![i] != null
                  ? (TapGestureRecognizer()..onTap = onLabelTaps![i])
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
