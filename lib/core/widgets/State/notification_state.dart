import 'package:flutter/foundation.dart';

/// Jumlah notifikasi yang belum dibaca.
/// Sementara pakai ValueNotifier supaya badge di bottom bar langsung
final ValueNotifier<int> unreadNotifications = ValueNotifier<int>(3);
