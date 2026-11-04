import 'package:flutter/material.dart';

import '../Const/colors.dart';

// Kotak abu-abu membulat untuk search.
// Home mengisinya dengan Text, halaman Search mengisinya dengan TextField.
class SearchBox extends StatelessWidget {
  final Widget child;

  const SearchBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: kSearchBarColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}
