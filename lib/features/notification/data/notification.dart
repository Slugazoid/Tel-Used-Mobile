import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppNotification {
  // Teks di antara ** ** akan ditampilkan tebal.
  final String message;
  final String time;
  final String imageUrl;
  final IconData? badge; // ikon kecil merah di pojok foto
  final String? buttonLabel; // null = tanpa tombol
  final bool roundImage;

  const AppNotification({
    required this.message,
    required this.time,
    required this.imageUrl,
    this.badge,
    this.buttonLabel,
    this.roundImage = false,
  });
}

// Data sementara; backend belum ada.
const List<AppNotification> notifications = [
  AppNotification(
    message: '**Selamat!** Barang anda terjual oleh **cimol_bojot**',
    time: '10 MENIT YANG LALU',
    imageUrl: 'https://picsum.photos/100/100?random=31',
    badge: LucideIcons.shoppingBag,
  ),
  AppNotification(
    message: '**amangcecep** menyukai barang Anda',
    time: '10 MENIT YANG LALU',
    imageUrl: 'https://picsum.photos/100/100?random=32',
    badge: LucideIcons.heart,
    buttonLabel: 'Kirim Tawaran',
  ),
  AppNotification(
    message: '**cimol_bojot** menyukai barang Anda',
    time: '10 MENIT YANG LALU',
    imageUrl: 'https://picsum.photos/100/100?random=33',
    badge: LucideIcons.heart,
    buttonLabel: 'Kirim Tawaran',
  ),
  AppNotification(
    message:
        'Seseorang memasukkan barang Anda ke keranjang tetapi belum melakukan pembayaran',
    time: '1 JAM YANG LALU',
    imageUrl: 'https://picsum.photos/100/100?random=34',
    badge: LucideIcons.heart,
    buttonLabel: 'Kirim Tawaran',
  ),
  AppNotification(
    message:
        'Baru dari **@bunthrift.** Jadilah yang pertama berbelanja produk terbaru mereka,',
    time: '1 JAM YANG LALU',
    imageUrl: 'https://picsum.photos/100/100?random=35',
    buttonLabel: 'Belanja',
    roundImage: true,
  ),
];
