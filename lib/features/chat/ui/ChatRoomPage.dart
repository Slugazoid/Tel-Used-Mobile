import 'package:flutter/material.dart';
import '../data/chat.dart';
import '../data/chatroom_viewmodel.dart';
import '../data/message.dart';

class ChatRoomPage extends StatefulWidget {
  final Conversation chat;
  const ChatRoomPage({super.key, required this.chat});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController inputController = TextEditingController();
  late final ChatRoomViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ChatRoomViewModel(widget.chat);
  }

  @override
  void dispose() {
    inputController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  void kirimPesan() {
    viewModel.kirim(inputController.text);
    inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: tampilkanHeader(),
      body: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                if (viewModel.kosong) {
                  return tampilkanChatKosong();
                }

                final daftarPesan = viewModel.terbaruDulu;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: daftarPesan.length,
                  itemBuilder: (context, index) {
                    return tampilkanPesan(daftarPesan[index]);
                  },
                );
              },
            ),
          ),
          tampilkanChatBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget tampilkanHeader() {
    return AppBar(
      backgroundColor: const Color(0xFFFAFAFA),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
      title: Row(
        children: [
          tampilkanAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chat.shopName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      viewModel.status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.chat.isOnline
                            ? const Color(0xFF4CAF50)
                            : Colors.grey,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget tampilkanAvatar() {
    final punyaFoto = widget.chat.avatar != null;

    return CircleAvatar(
      radius: 20,
      backgroundColor: const Color(0xFFE53935),
      backgroundImage: punyaFoto ? AssetImage(widget.chat.avatar!) : null,
      child: punyaFoto
          ? null
          : Text(
              widget.chat.shopName[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
    );
  }

  Widget tampilkanPesan(Message pesan) {
    final milikku = pesan.isMine;
    final lebarMaks = MediaQuery.of(context).size.width * 0.75;

    return Align(
      alignment: milikku ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: lebarMaks),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: milikku
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: milikku ? const Color(0xFFE53935) : Colors.white,
                border: milikku
                    ? null
                    : Border.all(color: const Color(0xFFE6E6EA)),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(milikku ? 16 : 4),
                  topRight: Radius.circular(milikku ? 4 : 16),
                  bottomLeft: const Radius.circular(16),
                  bottomRight: const Radius.circular(16),
                ),
              ),
              child: Text(
                pesan.text,
                style: TextStyle(
                  fontSize: 14,
                  color: milikku ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              pesan.time,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget tampilkanChatKosong() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: 56,
              color: Color(0xFFB8B8BE),
            ),
            const SizedBox(height: 12),
            const Text('Belum ada pesan', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              'Mulai percakapan dengan ${widget.chat.shopName}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget tampilkanChatBar() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: inputController,
                  minLines: 1,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Type messages....',
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFF1F4F8),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: inputController,
                builder: (context, value, child) {
                  final bisaKirim = value.text.trim().isNotEmpty;

                  return IconButton(
                    icon: const Icon(Icons.send),
                    color: const Color(0xFFE53935),
                    disabledColor: const Color(0xFFB8B8BE),
                    onPressed: bisaKirim ? kirimPesan : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
