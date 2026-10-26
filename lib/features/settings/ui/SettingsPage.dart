import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/widgets/Const/colors.dart';
import '../../../core/widgets/Widget/app_top_bar.dart';

class _SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SettingItem(this.icon, this.title, this.subtitle);
}

const _items = [
  _SettingItem(
    LucideIcons.user,
    'Akun Saya',
    'Lihat informasi tentang akun Anda, arsip data Anda, atau pelajari tentang opsi penonaktifan akun Anda.',
  ),
  _SettingItem(
    LucideIcons.clipboard,
    'Draft Penjualan',
    'Kelola drafmu yang belum selesai dan laporan keuangan dari penjualan Anda.',
  ),
  _SettingItem(
    LucideIcons.chartColumn,
    'Laporan Keuangan',
    'Kelola drafmu yang belum selesai dan laporan keuangan dari penjualan Anda.',
  ),
  _SettingItem(
    LucideIcons.receipt,
    'Kuitansi',
    'Kelola drafmu yang belum selesai dan laporan keuangan dari penjualan Anda.',
  ),
  _SettingItem(
    LucideIcons.lock,
    'Keamanan dan Akses Akun',
    'Kelola keamanan akun Anda dan lacak penggunaan akun Anda.',
  ),
  _SettingItem(
    LucideIcons.truck,
    'Lacak Pengiriman',
    'Lihat informasi tentang lokasi paket Anda.',
  ),
  _SettingItem(
    LucideIcons.shield,
    'Privasi dan Keamanan',
    'Kelola informasi yang Anda lihat dan bagikan di Pengo.',
  ),
  _SettingItem(
    LucideIcons.bell,
    'Notifikasi',
    'Pilih jenis notifikasi yang akan Anda terima tentang berita, minat Anda, dll.',
  ),
  _SettingItem(
    LucideIcons.wandSparkles,
    'Aksesibilitas, tampilan, dan bahasa',
    'Kelola aspek pengalaman TelUsed Anda seperti membatasi kontras warna, mengubah warna, ukuran font, latar belakang, dan gerakan.',
  ),
];

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const AppTopBar.withBack(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          for (final item in _items) _SettingTile(item: item),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              foregroundColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Log out'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.item});

  final _SettingItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(item.icon, size: 18, color: Colors.black87),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B6B6B),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: Color(0xFF8A8A8A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
