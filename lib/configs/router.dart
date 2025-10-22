import 'package:go_router/go_router.dart';
import 'package:main_sony/controllers/post_list_controller.dart';
import 'package:main_sony/utils/custom_class.dart';
import 'package:main_sony/views/screens/settings.dart';
import '../views/export_views.dart';

const url = 'https://bubble-blast-shooter.vercel.app';
final appReady = ValueNotifier<bool>(false);
final rootNavKey = GlobalKey<NavigatorState>();
GoRouter get router {
  return GoRouter(
    observers: [AnalyticsObserver()],
    navigatorKey: rootNavKey,
    // debugLogDiagnostics: true,
    initialLocation: '/splash',
    // Whenever appReady changes, re-run redirect logic
    refreshListenable: appReady,
    // Global redirect (replace your GetMiddleware)
    redirect: (context, state) {
      final goingTo = state.matchedLocation; // e.g. /ai-chatbots
      if (!appReady.value && goingTo != '/splash') return '/splash';
      if (appReady.value && (goingTo == '/' || goingTo == '/splash')) {
        return '/posts/home';
      }

      return null; // no redirect
    },
    routes: [
      // Simple pages
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (ctx, st) => const SplashScreen(),
      ),
      GoRoute(
        path: '/posts/:name',
        name: 'posts',
        builder: (ctx, st) {
          final name = st.pathParameters['name'] ?? 'home';

          return IndexScreen(name: name);
        },
        routes: [
          GoRoute(
            path: '/details/:id',
            name: 'post_details',
            builder: (ctx, st) {
              final idStr = st.pathParameters['id']!;
              final id = decodeId(idStr);
              if (id == null) throw Exception('Invalid post ID: $idStr');

              return PostDetailScreen(
                params: Params(
                  id: id,
                  path: st.matchedLocation,
                  name: st.pathParameters['name'] ?? 'home',
                  src: st.uri.queryParameters['src'] ?? 'in-app',
                  camp: st.uri.queryParameters['camp'] ?? 'none',
                ),
                controller: Get.find<PostListController>(),
              );
            },
          ),
        ],
      ),

      GoRoute(
        path: '/ai-chatbots',
        name: 'ai_chatbots',
        builder: (ctx, st) => const AiChatbotScreen(),
      ),

      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (ctx, st) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (ctx, st) {
      return Scaffold(
        body: Center(child: Text('No route for: ${st.uri.toString()}')),
      );
    },
    extraCodec: CustomCodec(),
  );
}
