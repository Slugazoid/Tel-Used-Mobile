class Conversation {
  final String id;
  final String shopName;
  final String? avatar;
  final String lastMessage;
  final String time;
  final int unread;
  final bool isOnline;
  final bool isTyping;
  final bool lastFromMe;

  const Conversation({
    required this.id,
    required this.shopName,
    this.avatar,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
    this.isOnline = false,
    this.isTyping = false,
    this.lastFromMe = false,
  });
}

const dummyConversations = [
  Conversation(
    id: '1',
    shopName: 'kopiaren92',
    avatar: 'lib/features/chat/data/avatar1.png',
    lastMessage:
        'Siang kak, aku suka sepatunya. Kalau aku tawar 175 ribu boleh nggak?',
    time: '12:00',
    isOnline: true,
    lastFromMe: true,
  ),
  Conversation(
    id: '2',
    shopName: 'thriftzonebdg',
    avatar: 'lib/features/chat/data/avatar2.png',
    lastMessage: 'Masih ada kak, nego dikit boleh kok',
    time: '11:42',
    unread: 2,
  ),
  Conversation(
    id: '3',
    shopName: 'gadgetsecond',
    lastMessage: 'Sedang mengetik...',
    time: '10:15',
    isOnline: true,
    isTyping: true,
  ),
  Conversation(
    id: '4',
    shopName: 'bukuloak',
    lastMessage: 'Makasih kak, barangnya udah sampai ^^',
    time: 'Kemarin',
    lastFromMe: true,
  ),
];
