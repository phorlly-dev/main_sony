import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlContent extends StatelessWidget {
  final String htmlContent;
  final bool isLandscape;
  final double screenHeight, screenWidth;

  const HtmlContent({
    super.key,
    required this.htmlContent,
    required this.screenHeight,
    required this.screenWidth,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Html(
      data: htmlContent,
      // shrinkWrap: true,
      style: {
        "body": Style(
          fontSize: FontSize(13.0),
          lineHeight: LineHeight(1.7),
          margin: Margins.symmetric(horizontal: 0),
        ),
        "h2": Style(
          fontSize: FontSize(16.0),
          fontWeight: FontWeight.bold,
          margin: Margins.symmetric(vertical: 0),
        ),
        "blockquote": Style(
          fontStyle: FontStyle.italic,
          color: colors.secondary,
          margin: Margins.symmetric(vertical: 12),
        ),
        "figure": Style(margin: Margins.symmetric(horizontal: 0)),
        "img": Style(
          display: Display.inlineBlock,
          alignment: Alignment.center,
          width: Width(isLandscape ? screenWidth * .93 : screenWidth * .9),
          height: Height(isLandscape ? screenHeight * .88 : screenHeight * .3),
        ),
        "a": Style(
          color: colors.primary,
          textDecoration: TextDecoration.underline,
        ),
        // "body": Style(alignment: Alignment.center),
      },
    );
  }
}
