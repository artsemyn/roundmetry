import 'package:flutter/material.dart';
import 'package:roundmetry/features/auth/views/login_screen.dart';
import 'package:roundmetry/features/auth/views/register_screen.dart';
import 'package:roundmetry/features/dashboard/views/dashboard_screen.dart';
import 'package:roundmetry/features/materi/views/halaman_belajar_screen.dart';
import 'package:roundmetry/features/materi/views/materi_screen.dart';
import 'package:roundmetry/features/profil/views/profil_screen.dart';
import 'package:roundmetry/features/quiz/views/quiz_screen.dart';
import 'package:roundmetry/main.dart';
import 'package:roundmetry/shared/widgets/main_layout.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/login',
  refreshListenable: GoRouterRefreshStream(supabase.auth.onAuthStateChange),
  redirect: (context, state) {
    final session = supabase.auth.currentSession;
    final isLoggedIn = session != null;
    final publicRoutes = ['/login', '/register'];
    final isGoingToPublicRoute = publicRoutes.contains(state.matchedLocation);

    if (!isLoggedIn && !isGoingToPublicRoute) {
      return '/login';
    }
    if (isLoggedIn && isGoingToPublicRoute) {
      return '/';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/belajar/:babId/:langkahIndex',
      builder: (context, state) {
        final babId = state.pathParameters['babId']!;
        // Ubah langkahIndex dari String menjadi integer
        final langkahIndex = int.parse(state.pathParameters['langkahIndex']!);
        return HalamanBelajarScreen(
          babId: babId,
          initialLangkahIndex: langkahIndex,
        );
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/materi-list',
          builder: (context, state) => const MateriScreen(),
        ),
        GoRoute(
          path: '/materi/:babId',
          builder: (context, state) {
            final babId = state.pathParameters['babId']!;
            return HalamanBelajarScreen(babId: babId);
          },
        ),
        GoRoute(
          path: '/profil',
          builder: (context, state) => const ProfilScreen(),
        ),
        GoRoute(
          path: '/quiz',
          builder: (context, state) => const QuizScreen(),
        ),
      ],
    ),
  ],
);

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.asBroadcastStream().listen((_) => notifyListeners());
  }
}