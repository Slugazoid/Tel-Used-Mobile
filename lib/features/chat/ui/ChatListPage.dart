import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/widgets/Const/colors.dart';
import '../../../core/widgets/Widget/search_box.dart';
import '../data/chat.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    // Saring daftar chat berdasarkan nama yang diketik.
    final shown = chatRooms
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SearchBox(
                child: Row(
                  children: [
                    const Icon(LucideIcons.search, size: 20, color: kGreyColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: (text) => setState(() => query = text),
                        decoration: const InputDecoration(
                          hintText: 'Cari nama',
                          hintStyle: TextStyle(color: kGreyColor),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: shown.length,
                itemBuilder: (context, i) => _buildRow(shown[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(LucideIcons.chevronLeft, size: 24),
          ),
          const Expanded(
            child: Text(
              'Chat',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          // Penyeimbang lebar tombol back supaya judul tepat di tengah.
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildRow(ChatRoom c) {
    return InkWell(
      onTap: () => context.push('/chat/${c.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage('https://i.pravatar.cc/100?u=${c.name}'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(
                    c.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: kGreyColor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(c.time, style: const TextStyle(fontSize: 11, color: kGreyColor)),
                if (c.unread > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${c.unread}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
