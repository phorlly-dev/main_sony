import 'package:main_sony/views/export_views.dart';

const double _kSize = 50;

enum LoadingType {
  discreteCircle,
  waveDots,
  inkDrop,
  threeRotatingDots,
  staggeredDotsWave,
  fourRotatingDots,
  fallingDot,
  progressiveDots,
  threeArchedCircle,
  bouncingBall,
  flickr,
  hexagonDots,
  beat,
  horizontalRotatingDots,
  newtonCradle,
  stretchedDots,
  halfTriangleDot,
  dotsTriangle,
  twistingDots,
}

class LoadingAnimation extends StatelessWidget {
  final LoadingType? type;
  final String label;
  final double textSize;
  final AppColorRole themColor;
  const LoadingAnimation({
    super.key,
    this.type,
    this.themColor = AppColorRole.info,
    this.label = "Loading...",
    this.textSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final kColor = context.getAppColor(themColor);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: kColor,
              fontSize: textSize,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 16),
          _widget(kColor),
        ],
      ),
    );
  }

  Widget _widget(Color kColor) {
    Widget loading = LoadingAnimationWidget.discreteCircle(
      color: kColor,
      size: _kSize,
    );
    switch (type) {
      case LoadingType.waveDots:
        loading = LoadingAnimationWidget.waveDots(
          color: Colors.blue,
          size: _kSize,
        );
        break;
      case LoadingType.inkDrop:
        loading = LoadingAnimationWidget.inkDrop(color: kColor, size: _kSize);
        break;
      case LoadingType.twistingDots:
        loading = LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color(0xFF1A1A3F),
          rightDotColor: const Color(0xFFEA3799),
          size: _kSize,
        );
        break;
      case LoadingType.threeRotatingDots:
        loading = LoadingAnimationWidget.threeRotatingDots(
          color: kColor,
          size: _kSize,
        );
        break;
      case LoadingType.staggeredDotsWave:
        loading = LoadingAnimationWidget.staggeredDotsWave(
          color: kColor,
          size: _kSize,
        );
        break;
      case LoadingType.fourRotatingDots:
        loading = LoadingAnimationWidget.fourRotatingDots(
          color: kColor,
          size: _kSize,
        );
        break;
      case LoadingType.fallingDot:
        loading = LoadingAnimationWidget.fallingDot(
          color: kColor,
          size: _kSize,
        );
        break;
      case LoadingType.progressiveDots:
        loading = LoadingAnimationWidget.progressiveDots(
          color: kColor,
          size: _kSize,
        );
        break;
      case LoadingType.threeArchedCircle:
        loading = LoadingAnimationWidget.threeArchedCircle(
          color: kColor,
          size: _kSize,
        );
        break;
      case LoadingType.bouncingBall:
        loading = LoadingAnimationWidget.bouncingBall(
          color: kColor,
          size: _kSize,
        );
        break;
      case LoadingType.flickr:
        loading = LoadingAnimationWidget.flickr(
          leftDotColor: const Color(0xFF0063DC),
          rightDotColor: const Color(0xFFFF0084),
          size: _kSize,
        );
        break;
      case LoadingType.hexagonDots:
        loading = LoadingAnimationWidget.hexagonDots(
          color: kColor,
          size: _kSize,
        );
        break;
      case LoadingType.beat:
        loading = LoadingAnimationWidget.beat(color: kColor, size: _kSize);
        break;
      case LoadingType.horizontalRotatingDots:
        loading = LoadingAnimationWidget.horizontalRotatingDots(
          color: kColor,
          size: _kSize,
        );
        break;
      case LoadingType.newtonCradle:
        loading = LoadingAnimationWidget.newtonCradle(
          color: kColor,
          size: 2 * _kSize,
        );
        break;
      case LoadingType.stretchedDots:
        loading = LoadingAnimationWidget.stretchedDots(
          color: kColor,
          size: _kSize,
        );
        break;
      case LoadingType.halfTriangleDot:
        loading = LoadingAnimationWidget.halfTriangleDot(
          color: kColor,
          size: _kSize,
        );
        break;
      case LoadingType.dotsTriangle:
        loading = LoadingAnimationWidget.dotsTriangle(
          color: kColor,
          size: _kSize,
        );
        break;
      default:
        loading;
    }

    return loading;
  }
}
