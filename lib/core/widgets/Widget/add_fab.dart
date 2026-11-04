import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../Const/colors.dart';

// Tombol "+" merah. Dipakai di Home, Timeline, dan Notification.
class AddFab extends StatelessWidget {
  const AddFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      shape: const CircleBorder(),
      child: const Icon(LucideIcons.plus, size: 28),
    );
  }
}
