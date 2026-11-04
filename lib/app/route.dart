import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/Widget/bottom_navbar.dart';
import '../features/home/ui/HomePage.dart';
import '../features/profile/ui/ProfilePage.dart';
import '../features/settings/ui/SettingsPage.dart';

import '../features/auth/ui/LoginPage.dart';
import '../features/auth/ui/RegisterPage.dart';
import '../features/auth/ui/SplashPage.dart';
import '../features/auth/ui/SetupProfilePage.dart';

import '../features/product/ui/product_detail_page.dart';
import '../features/search/ui/SearchPage.dart';
import '../features/filter/ui/FilterPage.dart';
import '../features/chat/ui/ChatListPage.dart';
import '../features/chat/ui/ChatRoomPage.dart';
import '../features/timeline/ui/TimelinePage.dart';
import '../features/notification/ui/NotificationPage.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Aturan sederhana untuk bottom bar:
/// - Halaman di dalam StatefulShellRoute (/home, /timeline, /notifications,
///   /profile) -> bottom bar TAMPIL.
/// - Halaman di luar shell (login, register, chat, detail produk)
///   -> bottom bar OTOMATIS HILANG.
///
/// Untuk halaman yang secara URL ada di bawah sebuah tab (misal
/// /home/product/:id) tapi tidak boleh punya bottom bar, tambahkan
/// `parentNavigatorKey: _rootNavigatorKey`.
final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // ---------- Halaman DENGAN bottom bar ----------
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        // 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
              routes: [
                GoRoute(
                  path: 'product/:id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => ProductDetailPage(
                    id: int.parse(state.pathParameters['id']!),
                  ),
                ),
              ],
            ),
          ],
        ),

        // 1: Timeline
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/timeline',
              builder: (context, state) => const TimelinePage(),
            ),
          ],
        ),

        // 2: Notification
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const NotificationPage(),
            ),
          ],
        ),

        // 3: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),

    // ---------- Halaman TANPA bottom bar ----------
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
       GoRoute(
     path: '/setup-profile',
     builder: (context, state) => const SetupProfilePage(),
   ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: '/filter',
      builder: (context, state) => const FilterPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatListPage(),
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) =>
          ChatRoomPage(id: state.pathParameters['id']!),
    ),
  ],
);
