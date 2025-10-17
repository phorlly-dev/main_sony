import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:main_sony/controllers/post_list_controller.dart';
import 'package:main_sony/views/screens/settings.dart';
import 'views/export_views.dart';

final appReady = ValueNotifier<bool>(false);
final rootNavKey = GlobalKey<NavigatorState>();

final router = Provider<GoRouter>((_) {
  return GoRouter(
    navigatorKey: rootNavKey,
    debugLogDiagnostics: true,
    initialLocation: '/splash',
    // Whenever appReady changes, re-run redirect logic
    refreshListenable: appReady,
    // Global redirect (replace your GetMiddleware)
    redirect: (context, state) {
      final goingTo = state.matchedLocation; // e.g. /ai-chatbots
      if (!appReady.value && goingTo != '/splash') return '/splash';
      if (appReady.value && (goingTo == '/' || goingTo == '/splash')) {
        return '/view-posts/home';
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
        path: '/view-posts/:name',
        name: 'view_posts',
        builder: (ctx, st) {
          return IndexScreen(name: st.pathParameters['name']!);
        },
        routes: [
          GoRoute(
            path: '/details/:id',
            name: 'details',
            builder: (ctx, st) {
              final idStr = st.pathParameters['id'];
              final id = int.tryParse(idStr ?? '');
              if (id == null) throw Exception('Invalid post ID: $idStr');

              return PostDetailScreen(
                postId: id,
                controller: st.extra as PostListController,
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
  );
});
