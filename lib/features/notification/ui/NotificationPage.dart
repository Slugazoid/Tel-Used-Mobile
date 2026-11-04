import 'package:flutter/material.dart';

import '../../../core/widgets/Const/colors.dart';
import '../../../core/widgets/Widget/add_fab.dart';
import '../data/notification.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      floatingActionButton: const AddFab(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 56,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: kBorderColor)),
              ),
              child: const Text(
                'Notifikasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, i) => _buildItem(notifications[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(AppNotification n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: Row(
        children: [
          _buildImage(n),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMessage(n.message),
                const SizedBox(height: 6),
                Text(
                  n.time,
                  style: const TextStyle(fontSize: 11, color: kGreyColor),
                ),
              ],
            ),
          ),
          if (n.buttonLabel != null) ...[
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(n.buttonLabel!, style: const TextStyle(fontSize: 11)),
            ),
          ],
        ],
      ),
    );
  }

  // Foto 60x60, dengan ikon merah kecil di pojok kanan atas (kalau ada).
  Widget _buildImage(AppNotification n) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(n.roundImage ? 30 : 8),
          child: Image.network(n.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
        ),
        if (n.badge != null)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Icon(n.badge, size: 11, color: Colors.white),
            ),
          ),
      ],
    );
  }

  // Memecah teks di tanda ** : bagian ganjil ditampilkan tebal.
  Widget _buildMessage(String message) {
    final parts = message.split('**');
    final spans = <TextSpan>[];
    for (int i = 0; i < parts.length; i++) {
      spans.add(
        TextSpan(
          text: parts[i],
          style: TextStyle(
            fontWeight: i.isOdd ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      );
    }
    return Text.rich(
      TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        children: spans,
      ),
    );
  }
}
