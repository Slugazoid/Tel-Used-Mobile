import 'package:flutter/foundation.dart';
import 'chat.dart';

class ChatListViewModel extends ChangeNotifier {
  final List<Conversation> _conversations = dummyConversations;
  String _search = '';

  List<Conversation> get hasil {
    final keyword = _search.toLowerCase();

    return _conversations.where((chat) {
      return chat.shopName.toLowerCase().contains(keyword);
    }).toList();
  }

  void cari(String value) {
    _search = value;
    notifyListeners();
  }
}