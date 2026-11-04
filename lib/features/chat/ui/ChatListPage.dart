import 'package:flutter/material.dart';
import '../data/chat.dart';
import '../data/chatlist_viewmodel.dart';
import 'ChatRoomPage.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController searchController = TextEditingController();
  final ChatListViewModel viewModel = ChatListViewModel();

  @override
  void dispose() {
    searchController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        centerTitle: true,
        title: const Text('Chat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                viewModel.cari(value);
              },
              decoration: InputDecoration(
                hintText: 'Cari nama',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFECEFF8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                List<Conversation> daftarChat = viewModel.hasil;
                if (daftarChat.isEmpty) {
                  return const Center(child: Text('Chat tidak ditemukan'));
                }
                return ListView.builder(
                  itemCount: daftarChat.length,
                  itemBuilder: (context, index) {
                    return tampilkanChat(daftarChat[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget tampilkanChat(Conversation chat) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),

      leading: tampilkanAvatar(chat),

      title: Text(chat.shopName, maxLines: 1, overflow: TextOverflow.ellipsis),

      subtitle: Text(
        chat.isTyping
            ? 'Sedang mengetik...'
            : chat.lastFromMe
            ? 'You: ${chat.lastMessage}'
            : chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: chat.unread > 0 || chat.isTyping
              ? Colors.black87
              : Colors.grey,
        ),
      ),

      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chat.time,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 5),
          if (chat.unread > 0)
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${chat.unread}',
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatRoomPage(chat: chat)),
        );
      },
    );
  }

  Widget tampilkanAvatar(Conversation chat) {
    final punyaFoto = chat.avatar != null;
    return Stack(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFFE53935),
          backgroundImage: punyaFoto ? AssetImage(chat.avatar!) : null,
          child: punyaFoto
              ? null
              : Text(
                  chat.shopName[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: chat.isOnline
                  ? const Color(0xFF8BE05A)
                  : const Color(0xFFB8B8BE),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}