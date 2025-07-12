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
        "table": Style(
          width: Width(screenWidth, Unit.px),
          margin: Margins.symmetric(horizontal: 0, vertical: 12),
          border: Border.all(width: .4, color: colors.outline),
        ),
        "ul": Style(
          margin: Margins.symmetric(horizontal: 0, vertical: 12),
          padding: HtmlPaddings.symmetric(vertical: 16, unit: Unit.px),
        ),
        "ol": Style(
          margin: Margins.symmetric(horizontal: 0, vertical: 12),
          padding: HtmlPaddings.symmetric(vertical: 16, unit: Unit.px),
        ),
        "li": Style(
          margin: Margins.symmetric(horizontal: 0, vertical: 4),
          padding: HtmlPaddings.symmetric(horizontal: 16, unit: Unit.px),
        ),
        "p": Style(
          margin: Margins.symmetric(horizontal: 0, vertical: 12),
          padding: HtmlPaddings.symmetric(vertical: 8, unit: Unit.px),
        ),
        "code": Style(
          backgroundColor: colors.surfaceContainerLow,
          padding: HtmlPaddings.symmetric(
            horizontal: 4,
            vertical: 2,
            unit: Unit.px,
          ),
          fontFamily: 'monospace',
          fontSize: FontSize(12.0),
        ),
        "pre": Style(
          backgroundColor: colors.surfaceContainerLow,
          padding: HtmlPaddings.symmetric(
            horizontal: 8,
            vertical: 4,
            unit: Unit.px,
          ),
          fontFamily: 'monospace',
          fontSize: FontSize(12.0),
        ),
        "span": Style(color: colors.onSurface, fontSize: FontSize(13.0)),
        "h1": Style(
          fontSize: FontSize(20.0),
          fontWeight: FontWeight.bold,
          margin: Margins.symmetric(vertical: 12),
        ),
        "h3": Style(
          fontSize: FontSize(14.0),
          fontWeight: FontWeight.bold,
          margin: Margins.symmetric(vertical: 8),
        ),
        "h4": Style(
          fontSize: FontSize(12.0),
          fontWeight: FontWeight.bold,
          margin: Margins.symmetric(vertical: 8),
        ),
        "h5": Style(
          fontSize: FontSize(11.0),
          fontWeight: FontWeight.bold,
          margin: Margins.symmetric(vertical: 8),
        ),
        "h6": Style(
          fontSize: FontSize(10.0),
          fontWeight: FontWeight.bold,
          margin: Margins.symmetric(vertical: 8),
        ),
        "strong": Style(fontWeight: FontWeight.bold, color: colors.onSurface),
        "em": Style(fontStyle: FontStyle.italic, color: colors.onSurface),
        "mark": Style(
          backgroundColor: colors.primaryContainer,
          color: colors.onPrimaryContainer,
          padding: HtmlPaddings.symmetric(
            horizontal: 4,
            vertical: 2,
            unit: Unit.px,
          ),
        ),
        "sub": Style(
          fontSize: FontSize(10.0),
          verticalAlign: VerticalAlign.sub,
        ),
        "sup": Style(
          fontSize: FontSize(10.0),
          verticalAlign: VerticalAlign.sup,
        ),
        "small": Style(
          fontSize: FontSize(10.0),
          color: colors.onSurfaceVariant,
        ),
        "big": Style(fontSize: FontSize(16.0), color: colors.onSurface),
        "del": Style(
          textDecoration: TextDecoration.lineThrough,
          color: colors.onSurfaceVariant,
        ),
        "ins": Style(
          textDecoration: TextDecoration.underline,
          color: colors.primary,
        ),
        "u": Style(
          textDecoration: TextDecoration.underline,
          color: colors.primary,
        ),
        "s": Style(
          textDecoration: TextDecoration.lineThrough,
          color: colors.onSurfaceVariant,
        ),
        "b": Style(fontWeight: FontWeight.bold, color: colors.onSurface),
        "i": Style(fontStyle: FontStyle.italic, color: colors.onSurface),
        "center": Style(textAlign: TextAlign.center),
        "justify": Style(textAlign: TextAlign.justify),
        "left": Style(textAlign: TextAlign.left),
        "right": Style(textAlign: TextAlign.right),
        "nowrap": Style(whiteSpace: WhiteSpace.normal),
        "pre-wrap": Style(whiteSpace: WhiteSpace.pre),
        "pre-line": Style(whiteSpace: WhiteSpace.pre),
        "break-all": Style(
          whiteSpace: WhiteSpace.values.firstWhere(
            (value) => value.toString() == 'WhiteSpace.breakAll',
          ),
        ),
        "break-word": Style(
          whiteSpace: WhiteSpace.values.firstWhere(
            (value) => value.toString() == 'WhiteSpace.breakWord',
          ),
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
