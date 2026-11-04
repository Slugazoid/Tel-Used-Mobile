import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../Const/colors.dart';

// Baris "Location: Sukapura". Padding diatur oleh halaman yang memakainya.
class LocationRow extends StatelessWidget {
  const LocationRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(LucideIcons.mapPin, size: 22, color: kPrimaryColor),
        SizedBox(width: 8),
        Text('Location:  '),
        Text('Sukapura', style: TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
