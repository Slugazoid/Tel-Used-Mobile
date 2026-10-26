import 'package:flutter/foundation.dart';

/// Jumlah notifikasi yang belum dibaca.
///
/// Sementara pakai ValueNotifier supaya badge di bottom bar langsung
/// update. Nilai awal 3 hanya untuk demo. Nanti ganti dengan data asli
/// dari API/Firebase, misalnya: unreadNotifications.value = hasilDariServer;
final ValueNotifier<int> unreadNotifications = ValueNotifier<int>(3);
