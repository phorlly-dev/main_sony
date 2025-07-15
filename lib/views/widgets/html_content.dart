import 'package:main_sony/views/export_views.dart';

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
      style: {
        "body": Style(
          fontSize: FontSize(14.0),
          lineHeight: LineHeight(1.7),
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.normal,
          textAlign: TextAlign.start,
          color: colors.onSurface,
        ),
        "h1": Style(
          fontSize: FontSize(20.0),
          fontWeight: FontWeight.bold,
          margin: Margins.symmetric(vertical: 12),
        ),
        "h2": Style(
          fontSize: FontSize(17.0),
          fontWeight: FontWeight.bold,
          margin: Margins.only(top: 24, bottom: 10),
        ),
        "h3": Style(
          fontSize: FontSize(15.0),
          fontWeight: FontWeight.bold,
          margin: Margins.only(top: 18, bottom: 8),
        ),
        "h4": Style(fontSize: FontSize(14.0), fontWeight: FontWeight.bold),
        "blockquote": Style(
          fontStyle: FontStyle.italic,
          backgroundColor: colors.onSurfaceVariant.withValues(alpha: 0.1),
          border: Border(left: BorderSide(width: 4, color: colors.primary)),
          padding: HtmlPaddings.all(12, Unit.px),
          margin: Margins.symmetric(vertical: 16, horizontal: 0),
          color: colors.primary,
        ),
        "img": Style(
          alignment: Alignment.center,
          width: Width(screenWidth, Unit.auto),
          height: Height(isLandscape ? screenHeight * .8 : screenHeight * .3),
          margin: Margins.symmetric(vertical: 8),
        ),
        "figure": Style(margin: Margins.symmetric(vertical: 12)),
        "a": Style(
          color: colors.primary,
          textDecoration: TextDecoration.underline,
        ),
        "ul": Style(
          margin: Margins.only(left: 12, top: 6, bottom: 6),
          padding: HtmlPaddings.only(left: 12),
        ),
        "ol": Style(
          margin: Margins.only(left: 14, top: 6, bottom: 6),
          padding: HtmlPaddings.only(left: 12),
        ),
        "li": Style(
          margin: Margins.only(bottom: 4),
          padding: HtmlPaddings.zero,
        ),
        "hr": Style(
          margin: Margins.symmetric(vertical: 6),
          border: Border(top: BorderSide(width: 1, color: colors.outline)),
          height: Height(0.5), // as thin as possible
        ),
        "p": Style(
          margin: Margins.symmetric(vertical: 10),
          padding: HtmlPaddings.zero,
        ),
        "table": Style(
          width: Width(screenWidth, Unit.auto),
          margin: Margins.symmetric(vertical: 12),
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
            horizontal: isLandscape ? screenWidth * .149 : 16,
            vertical: 8,
            unit: Unit.px,
          ),
          textAlign: TextAlign.center,
        ),
        "code": Style(
          backgroundColor: colors.surfaceContainerLow,
          padding: HtmlPaddings.symmetric(
            horizontal: 4,
            vertical: 2,
            unit: Unit.px,
          ),
          fontFamily: 'monospace',
          fontSize: FontSize(13.0),
        ),
        "pre": Style(
          backgroundColor: colors.surfaceContainerLow,
          padding: HtmlPaddings.symmetric(
            horizontal: 8,
            vertical: 4,
            unit: Unit.px,
          ),
          fontFamily: 'monospace',
          fontSize: FontSize(13.0),
        ),
        "mark": Style(
          backgroundColor: colors.primaryContainer,
          color: colors.onPrimaryContainer,
        ),
        "strong": Style(fontWeight: FontWeight.bold),
        "b": Style(fontWeight: FontWeight.bold),
        "i": Style(fontStyle: FontStyle.italic),
        "u": Style(textDecoration: TextDecoration.underline),
        "s": Style(textDecoration: TextDecoration.lineThrough),
        "del": Style(textDecoration: TextDecoration.lineThrough),
        "ins": Style(
          textDecoration: TextDecoration.underline,
          color: colors.primary,
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
          fontSize: FontSize(11.0),
          color: colors.onSurfaceVariant,
        ),
        "big": Style(fontSize: FontSize(15.0)),
        "center": Style(textAlign: TextAlign.center),
        // More tags as needed...
      },
      onLinkTap: (url, attributes, element) {
        if (url != null) linkUrl(url);
      },
      extensions: const [
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
