import 'package:flutter/material.dart';

import '../../../features/home/data/home.dart';
import 'product_card.dart';

// Grid 2 kolom berisi ProductCard. Dipakai di Search dan Timeline.
// showSeller = true -> kartu menampilkan nama penjual & waktu unggah (Timeline).
class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final bool showSeller;

  const ProductGrid({
    super.key,
    required this.products,
    this.showSeller = false,
  });

  // Nama penjual sementara (dummyjson tidak punya data penjual).
  static const _sellers = ['bunthrift', 'amangcecep', 'cimol_bojot'];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: showSeller ? 330 : 270,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) => ProductCard(
        product: products[i],
        sellerName: showSeller ? _sellers[i % _sellers.length] : null,
        uploadedText: showSeller ? 'Diunggah ${i + 1} jam lalu' : null,
      ),
    );
  }
}
