import 'package:flutter/foundation.dart';
import 'chat.dart';
import 'message.dart';

class ChatRoomViewModel extends ChangeNotifier {
  final Conversation chat;
  final List<Message> _messages;

  ChatRoomViewModel(this.chat)
    : _messages = List<Message>.of(dummyMessages[chat.id] ?? []);

  bool get kosong => _messages.isEmpty;

  List<Message> get terbaruDulu => _messages.reversed.toList();

  String get status {
    if (chat.isTyping) {
      return 'Sedang mengetik...';
    }
    if (chat.isOnline) {
      return 'Aktif sekarang';
    }
    return 'Aktif hari ini';
  }

  void kirim(String teks) {
    final isi = teks.trim();
    if (isi.isEmpty) {
      return;
    }

    _messages.add(
      Message(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: isi,
        time: _jamSekarang(),
        isMine: true,
      ),
    );
    notifyListeners();
  }

  String _jamSekarang() {
    final sekarang = DateTime.now();
    final jam = sekarang.hour.toString().padLeft(2, '0');
    final menit = sekarang.minute.toString().padLeft(2, '0');
    return '$jam:$menit';
  }
}
