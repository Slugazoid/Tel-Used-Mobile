// Data chat sementara; backend belum ada.

// Satu baris di daftar chat.
class ChatRoom {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unread;

  const ChatRoom({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
  });
}

// Satu gelembung pesan di dalam ruang chat.
class ChatMessage {
  final String? text; // diisi kalau pesan teks
  final String? imageUrl; // diisi kalau pesan gambar
  final bool isMine;

  const ChatMessage({this.text, this.imageUrl, required this.isMine});
}

// id '1' = penjual di halaman detail produk.
const List<ChatRoom> chatRooms = [
  ChatRoom(
    id: '1',
    name: 'kopiaren22',
    lastMessage: 'You: Selamat siang kak! Aku suka banget sama sepatunya',
    time: '12:00',
  ),
  ChatRoom(
    id: '2',
    name: 'Dr. Marcie Addams',
    lastMessage: 'You: thank you so much ^^',
    time: '12:00',
  ),
  ChatRoom(
    id: '3',
    name: 'amangcecep',
    lastMessage: '??? why would you do..',
    time: '12:00',
    unread: 2,
  ),
];

// Isi awal ruang chat (sama untuk semua ruang, karena masih mock).
const List<ChatMessage> initialMessages = [
  ChatMessage(imageUrl: 'https://picsum.photos/300/300?random=40', isMine: true),
  ChatMessage(
    text:
        'Selamat siang kak! Aku suka banget sama sepatunya, kira kira klo aku tawar 175.000 dapet ga ya?',
    isMine: true,
  ),
];
