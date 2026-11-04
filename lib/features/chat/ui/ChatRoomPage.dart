import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/widgets/Const/colors.dart';
import '../data/chat.dart';

class ChatRoomPage extends StatefulWidget {
  final String id;

  const ChatRoomPage({super.key, required this.id});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController controller = TextEditingController();

  // Salinan list supaya bisa ditambah saat user mengirim pesan.
  final List<ChatMessage> messages = List.of(initialMessages);

  late final ChatRoom room;

  @override
  void initState() {
    super.initState();
    // Cari ruang chat berdasarkan id; kalau tidak ketemu pakai yang pertama.
    room = chatRooms.firstWhere(
      (c) => c.id == widget.id,
      orElse: () => chatRooms[0],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add(ChatMessage(text: text, isMine: true));
    });
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              // reverse: true -> pesan terbaru selalu di bawah, dan list
              // tetap menempel di bawah saat keyboard muncul.
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, i) {
                  final m = messages[messages.length - 1 - i];
                  return _buildMessage(m);
                },
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(LucideIcons.chevronLeft, size: 24),
          ),
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/100?u=${room.name}'),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(room.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Text(
                'Aktif hari ini',
                style: TextStyle(fontSize: 11, color: kGreyColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Satu gelembung. Milik saya = merah di kanan, lawan bicara = putih di kiri.
  Widget _buildMessage(ChatMessage m) {
    final Widget content;
    if (m.imageUrl != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(m.imageUrl!, width: 120, height: 120, fit: BoxFit.cover),
      );
    } else {
      content = Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: m.isMine ? kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          m.text!,
          style: TextStyle(
            fontSize: 13,
            color: m.isMine ? Colors.white : Colors.black87,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: m.isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: content,
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          const Icon(LucideIcons.smile, size: 22, color: kGreyColor),
          const SizedBox(width: 12),
          const Icon(LucideIcons.image, size: 22, color: kGreyColor),
          const SizedBox(width: 12),
          const Icon(LucideIcons.camera, size: 22, color: kGreyColor),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: kSearchBarColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => sendMessage(),
                decoration: const InputDecoration(
                  hintText: 'Type messages....',
                  hintStyle: TextStyle(color: kGreyColor, fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: sendMessage,
            child: const Icon(LucideIcons.send, size: 22, color: kPrimaryColor),
          ),
        ],
      ),
    );
  }
}
