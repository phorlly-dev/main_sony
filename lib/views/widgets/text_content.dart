import 'package:flutter/material.dart';
import 'package:main_sony/utils/constants.dart';
import 'package:main_sony/utils/utility.dart';

class TextContent extends StatelessWidget {
  final String article;
  final String? linkLabel;
  final VoidCallback? navigate;
  final bool isLandscape;

  const TextContent({
    super.key,
    required this.article,
    this.linkLabel,
    this.navigate,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: stripHtml(htmlText: article, length: isLandscape ? 212 : 80),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          // WidgetSpan(child: SizedBox(width: 6)),
          WidgetSpan(
            child: GestureDetector(
              onTap: navigate,
              child: Text(
                linkLabel ?? "Read More",
                style: TextStyle(
                  color: AppColorRole.info.color,

                  // fontSize: 15,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
