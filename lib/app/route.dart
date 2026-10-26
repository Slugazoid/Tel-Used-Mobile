import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../core/widgets/State/notification_state.dart';
import '../core/widgets/Widget/app_top_bar.dart';
import '../core/widgets/Widget/bottom_navbar.dart';
import '../core/widgets/Widget/placeholder_screen.dart';
import '../features/profile/ui/ProfilePage.dart';
import '../features/settings/ui/SettingsPage.dart';

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
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
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
              builder: (context, state) => PlaceholderScreen(
                title: 'Home',
                children: [
                  ElevatedButton(
                    onPressed: () => context.push('/home/product/1'),
                    child: const Text('Buka Detail Produk (bar hilang)'),
                  ),
                  ElevatedButton(
                    onPressed: () => context.push('/chat/1'),
                    child: const Text('Buka Chat (bar hilang)'),
                  ),
                  ElevatedButton(
                    onPressed: () => context.push('/login'),
                    child: const Text('Buka Login (bar hilang)'),
                  ),
                ],
              ),
              routes: [
                GoRoute(
                  path: 'product/:id',
                  parentNavigatorKey: _rootNavigatorKey, // sembunyikan bar
                  builder: (context, state) => PlaceholderScreen(
                    title: 'Detail Produk #${state.pathParameters['id']}',
                    appBar: AppTopBar.withBack(
                      title: 'Detail Produk',
                      actions: [
                        AppTopBar.action(
                          icon: LucideIcons.shoppingCart,
                          onPressed: () {},
                        ),
                      ],
                    ),
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
              builder: (context, state) => const PlaceholderScreen(
                title: 'Timeline',
                appBar: AppTopBar(title: 'Timeline'),
              ),
            ),
          ],
        ),

        // 2: Notification
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notifications',
              builder: (context, state) => PlaceholderScreen(
                title: 'Notification',
                appBar: const AppTopBar(title: 'Notification'),
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: unreadNotifications,
                    builder: (context, count, _) =>
                        Text('Belum dibaca: $count'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => unreadNotifications.value = 0,
                    child: const Text('Tandai semua dibaca'),
                  ),
                  ElevatedButton(
                    onPressed: () => unreadNotifications.value += 1,
                    child: const Text('Simulasi notifikasi baru'),
                  ),
                ],
              ),
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
      path: '/login',
      builder: (context, state) => PlaceholderScreen(
        title: 'Login',
        children: [
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Masuk'),
          ),
          TextButton(
            onPressed: () => context.push('/register'),
            child: const Text('Belum punya akun? Daftar'),
          ),
        ],
      ),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => PlaceholderScreen(
        title: 'Register',
        appBar: const AppTopBar.withBack(title: 'Daftar'),
        children: [
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Daftar'),
          ),
        ],
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) => PlaceholderScreen(
        title: 'Chat #${state.pathParameters['id']}',
        appBar: AppTopBar.withBack(
          title: 'Chat',
          actions: [
            AppTopBar.action(icon: LucideIcons.search, onPressed: () {}),
          ],
        ),
      ),
    ),
  ],
);
