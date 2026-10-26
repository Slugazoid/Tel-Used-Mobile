import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../Const/colors.dart';
import '../State/notification_state.dart';

class NavItem {
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final bool showBadge;

  const NavItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    this.showBadge = false,
  });
}

/// Urutan item HARUS sama dengan urutan branch di lib/app/router.dart.
/// Cek nama ikon lewat autocomplete (ketik `LucideIcons.`) kalau ada yang merah.
const List<NavItem> navItems = [
  NavItem(
    title: 'Home',
    icon: LucideIcons.house,
    activeIcon: LucideIcons.house,
  ),
  NavItem(
    title: 'Timeline',
    icon: LucideIcons.history,
    activeIcon: LucideIcons.history,
  ),
  NavItem(
    title: 'Notification',
    icon: LucideIcons.bell,
    activeIcon: LucideIcons.bell,
    showBadge: true, // badge unread count tampil di tab ini
  ),
  NavItem(
    title: 'Profile',
    icon: LucideIcons.user,
    activeIcon: LucideIcons.user,
  ),
];

/// Kerangka halaman yang punya bottom bar.
/// Tab aktif ditentukan oleh route (navigationShell.currentIndex),
/// bukan lagi oleh variabel setState.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomBar(
        items: navItems,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          // Tap tab yang sedang aktif -> kembali ke halaman awal tab itu.
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      // SafeArea menjaga bar tetap di bawah tanpa menutupi gesture bar HP.
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final selected = i == currentIndex;
              final color = selected ? kPrimaryColor : Colors.grey;

              Widget icon = Icon(
                selected ? item.activeIcon : item.icon,
                color: color,
                size: 24,
              );
              if (item.showBadge) {
                icon = _UnreadBadge(child: icon);
              }

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    children: [
                      // Garis indikator di atas, hanya melebar saat dipilih.
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 4,
                        width: selected ? 40 : 0,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            icon,
                            const SizedBox(height: 4),
                            Text(
                              item.title,
                              style: TextStyle(fontSize: 11, color: color),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// Membungkus ikon dengan badge angka unread di pojok kanan atas.
class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: unreadNotifications,
      child: child,
      builder: (context, count, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            child!,
            if (count > 0)
              Positioned(
                right: -10,
                top: -6,
                child: _BadgeCount(count: count),
              ),
          ],
        );
      },
    );
  }
}

class _BadgeCount extends StatelessWidget {
  const _BadgeCount({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    );
  }
}
