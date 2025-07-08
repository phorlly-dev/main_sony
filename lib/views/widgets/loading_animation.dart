import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:main_sony/utils/constants.dart';

const double _kSize = 50;

class LoadingAnimation extends StatelessWidget {
  final int type;
  final String label;
  final double textSize;
  final AppColorRole themColor;
  const LoadingAnimation({
    super.key,
    this.type = 0,
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
            label.toUpperCase(),
            style: TextStyle(color: kColor, fontSize: textSize),
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
      case 1:
        loading = LoadingAnimationWidget.waveDots(
          color: Colors.blue,
          size: _kSize,
        );
        break;
      case 2:
        loading = LoadingAnimationWidget.inkDrop(color: kColor, size: _kSize);
        break;
      case 3:
        loading = LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color(0xFF1A1A3F),
          rightDotColor: const Color(0xFFEA3799),
          size: _kSize,
        );
        break;
      case 4:
        loading = LoadingAnimationWidget.threeRotatingDots(
          color: kColor,
          size: _kSize,
        );
        break;
      case 5:
        loading = LoadingAnimationWidget.staggeredDotsWave(
          color: kColor,
          size: _kSize,
        );
        break;
      case 6:
        loading = LoadingAnimationWidget.fourRotatingDots(
          color: kColor,
          size: _kSize,
        );
        break;
      case 7:
        loading = LoadingAnimationWidget.fallingDot(
          color: kColor,
          size: _kSize,
        );
        break;
      case 8:
        loading = LoadingAnimationWidget.progressiveDots(
          color: kColor,
          size: _kSize,
        );
        break;
      case 9:
        loading = LoadingAnimationWidget.threeArchedCircle(
          color: kColor,
          size: _kSize,
        );
        break;
      case 10:
        loading = LoadingAnimationWidget.bouncingBall(
          color: kColor,
          size: _kSize,
        );
        break;
      case 11:
        loading = LoadingAnimationWidget.flickr(
          leftDotColor: const Color(0xFF0063DC),
          rightDotColor: const Color(0xFFFF0084),
          size: _kSize,
        );
        break;
      case 12:
        loading = LoadingAnimationWidget.hexagonDots(
          color: kColor,
          size: _kSize,
        );
        break;
      case 13:
        loading = LoadingAnimationWidget.beat(color: kColor, size: _kSize);
        break;
      case 14:
        loading = LoadingAnimationWidget.horizontalRotatingDots(
          color: kColor,
          size: _kSize,
        );
        break;
      case 15:
        loading = LoadingAnimationWidget.newtonCradle(
          color: kColor,
          size: 2 * _kSize,
        );
        break;
      case 16:
        loading = LoadingAnimationWidget.stretchedDots(
          color: kColor,
          size: _kSize,
        );
        break;
      case 17:
        loading = LoadingAnimationWidget.halfTriangleDot(
          color: kColor,
          size: _kSize,
        );
        break;
      case 18:
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
