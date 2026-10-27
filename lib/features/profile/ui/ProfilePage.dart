import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/widgets/Const/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _tabs = ['Semua Barang', 'Favorites', 'Reviews'];
  static const _grey = Color(0xFF8A8A8A);
  static const _border = Color(0xFFD9D9D9);

  // Sesuai Figma: tab Reviews yang sedang aktif.
  int _tabIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(LucideIcons.plus, size: 28),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildActions(),
            _buildTabs(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: kPrimaryColor,
                child: Icon(LucideIcons.user, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Arzu',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 2),
                    Text('@arz6uuu', style: TextStyle(color: _grey)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.push('/settings'),
                icon: const Icon(LucideIcons.menu, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 13),
              children: [
                TextSpan(
                  text: '0',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: ' Followers    '),
                TextSpan(
                  text: '8',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: ' Following'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          Expanded(
            child: _outlinedButton(LucideIcons.squarePen, 'Edit Profile'),
          ),
          const SizedBox(width: 12),
          Expanded(child: _outlinedButton(null, 'Bagi Toko')),
        ],
      ),
    );
  }

  Widget _outlinedButton(IconData? icon, String label) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: _grey,
        side: const BorderSide(color: _border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: 8),
          ],
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final selected = i == _tabIndex;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _tabIndex = i),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selected ? kPrimaryColor : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  _tabs[i],
                  style: TextStyle(
                    fontSize: 13,
                    color: selected ? kPrimaryColor : _grey,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContent() {
    // Semua tab masih kosong; backend belum ada.
    return Column(
      children: [
        if (_tabIndex == 0) _buildFilterRow(),
        const Expanded(child: _EmptyState()),
      ],
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          _chip(child: const Icon(LucideIcons.slidersHorizontal, size: 16)),
          const SizedBox(width: 8),
          _chip(
            child: const Text(
              'Sort by',
              style: TextStyle(fontSize: 13, color: _grey),
            ),
          ),
          const Spacer(),
          const Icon(LucideIcons.layoutGrid, size: 22, color: _grey),
        ],
      ),
    );
  }

  Widget _chip({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.send,
            size: 72,
            color: Color(0xFFF08A86),
          ),
          SizedBox(height: 24),
          Text(
            'Tidak ada apa-apa',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Masih kosong nih.',
            style: TextStyle(color: Color(0xFF8A8A8A)),
          ),
        ],
      ),
    );
  }
}
