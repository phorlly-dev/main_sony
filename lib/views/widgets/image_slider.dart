import 'package:flutter/cupertino.dart';
import 'package:main_sony/views/export_views.dart';

class ImageSlider extends StatefulWidget {
  final VoidCallback? onTap;
  final List<SlideItem> items;

  const ImageSlider({super.key, required this.items, this.onTap});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _current = 0;
  final _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isLandscape = size.width > size.height;
    final sliderHeight = isLandscape ? .7.sh : .25.sh;
    final borderRadius = 8.0;
    final items = widget.items;

    return items.isEmpty
        ? SizedBox.shrink()
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 6).w,
            child: Column(
              children: [
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: items.length,
                  itemBuilder: (ctx, idx, _) {
                    final slide = items[idx];
                    return InkWell(
                      onTap: widget.onTap,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: slide.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.broken_image,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                            ),
                            // Overlay with gradient and title
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  24,
                                  16,
                                  14,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black54,
                                    ],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      slide.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 8,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      slide.date,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: sliderHeight,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 900,
                    ),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    viewportFraction: 0.94,
                    aspectRatio: isLandscape ? 16 / 7 : 16 / 9,
                    onPageChanged: (index, reason) {
                      setState(() => _current = index);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Dot indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.items.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _current == index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _current == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
