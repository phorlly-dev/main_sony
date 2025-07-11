import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_audio/flutter_html_audio.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:flutter_html_math/flutter_html_math.dart';
import 'package:flutter_html_svg/flutter_html_svg.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_html_video/flutter_html_video.dart';

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
          textAlign: TextAlign.start,
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
        "figure": Style(margin: Margins.symmetric(unit: Unit.auto)),
        "img": Style(
          display: Display.inlineBlock,
          alignment: Alignment.center,
          width: Width(screenWidth, Unit.auto),
          height: Height(
            isLandscape ? screenHeight * .8 : screenHeight * .3,
            Unit.auto,
          ),
        ),
        "a": Style(
          color: colors.primary,
          textDecoration: TextDecoration.underline,
        ),
        "th": Style(
          backgroundColor: colors.surfaceContainerHigh,
          color: colors.onSurface,
          padding: HtmlPaddings.symmetric(vertical: 8, unit: Unit.px),
          border: Border.all(width: .6, color: colors.outline),
          fontWeight: FontWeight.w900,
        ),
        "td": Style(
          color: colors.onSurface,
          backgroundColor: colors.surfaceContainerLow,
          border: Border.all(width: .4, color: colors.outline),
          padding: HtmlPaddings.symmetric(
            horizontal: isLandscape ? screenWidth * .15 : 22,
            vertical: 8,
            unit: Unit.px,
          ),
          textAlign: TextAlign.center,
        ),
      },
      extensions: [
        VideoHtmlExtension(),
        TableHtmlExtension(),
        SvgHtmlExtension(),
        MathHtmlExtension(),
        IframeHtmlExtension(),
        AudioHtmlExtension(),
      ],
    );
  }
}
