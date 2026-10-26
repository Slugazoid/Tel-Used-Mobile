import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Top app bar yang dipakai di banyak halaman.
///
/// Varian:
/// - `AppTopBar(title: 'Judul')`                          -> hanya judul
/// - `AppTopBar.withBack(title: 'Chat')`                  -> tombol back + judul
/// - `AppTopBar.withActions(title: 'Home', actions: [...])` -> judul + ikon aksi
/// - `AppTopBar.withBack(title: 'Chat', actions: [...])`  -> back + judul + aksi
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.showBack = false,
    this.actions = const [],
  });

  /// Dengan tombol back (kembali ke halaman sebelumnya).
  const AppTopBar.withBack({
    super.key,
    this.title,
    this.actions = const [],
  }) : showBack = true;

  /// Dengan ikon aksi di kanan, tanpa tombol back.
  const AppTopBar.withActions({
    super.key,
    this.title,
    required this.actions,
  }) : showBack = false;

  final String? title;
  final bool showBack;
  final List<Widget> actions;

  /// Helper untuk membuat ikon aksi dengan gaya seragam.
  static Widget action({
    required IconData icon,
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return IconButton(
      icon: Icon(icon, size: 24),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      centerTitle: false,
      leading: showBack
          ? IconButton(
              icon: const Icon(LucideIcons.arrowLeft),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
            )
          : null,
      title: title == null
          ? null
          : Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
      actions: [...actions, const SizedBox(width: 8)],
    );
  }
}
