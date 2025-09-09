import 'package:flutter/material.dart';
import 'package:roundmetry/features/auth/views/login_screen.dart';
import 'package:roundmetry/features/auth/views/register_screen.dart'; // Pastikan ini di-import
import 'package:roundmetry/features/dashboard/views/dashboard_screen.dart';
import 'package:roundmetry/features/material_viewer/views/material_viewer_screen.dart';
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

    // 1. Buat daftar rute yang tidak memerlukan login
    final publicRoutes = ['/login', '/register'];
    
    // 2. Cek apakah tujuan navigasi ada di dalam daftar rute publik
    final isGoingToPublicRoute = publicRoutes.contains(state.matchedLocation);

    // Jika pengguna belum login DAN mencoba akses halaman non-publik
    if (!isLoggedIn && !isGoingToPublicRoute) {
      return '/login';
    }

    // Jika pengguna sudah login DAN mencoba akses halaman publik (login/register)
    if (isLoggedIn && isGoingToPublicRoute) {
      return '/';
    }

    return null; // Lanjutkan navigasi
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
          path: '/materi',
          builder: (context, state) => const MaterialViewerScreen(),
        ),
        GoRoute(
          path: '/quiz',
          builder: (context, state) => const QuizScreen(),
        ),
      ],
    ),
  ],
);

// Kelas helper (tidak ada perubahan di sini)
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.asBroadcastStream().listen((_) => notifyListeners());
  }
}