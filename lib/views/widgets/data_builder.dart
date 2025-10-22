import 'package:main_sony/views/export_views.dart';

class DataBuilder<T> extends StatelessWidget {
  final T? initData;
  final Future<T> future;
  final Widget Function(BuildContext ctx, T? data) builder;

  const DataBuilder({
    super.key,
    required this.builder,
    required this.future,
    this.initData,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: initData,
      future: future,
      builder: (ctx, spt) {
        switch (spt.connectionState) {
          case ConnectionState.none:
            return AbsorbPointer(
              absorbing: true,
              child: Container(
                color: Colors.black.withValues(alpha: .8),
                alignment: Alignment.center,
                child: NotFound(),
              ),
            );
          case ConnectionState.waiting:
            return Container(
              margin: EdgeInsets.only(top: .3.sh),
              child: LoadingAnimation(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (spt.hasError) {
              return Container(
                margin: EdgeInsets.only(top: .3.sh),
                child: LoadingAnimation(
                  label: spt.error.toString(),
                  type: LoadingType.flickr,
                  themeColor: AppColorRole.error,
                ),
              );
            } else if (!spt.hasData) {
              return Container(
                margin: EdgeInsets.only(top: .3.sh),
                child: LoadingAnimation(
                  label: 'No data found!',
                  type: LoadingType.staggeredDotsWave,
                  themeColor: AppColorRole.secondary,
                ),
              );
            }

            return builder(ctx, spt.data);
        }
      },
    );
  }
}
