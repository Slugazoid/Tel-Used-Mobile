import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../features/home/data/home.dart';
import '../Const/colors.dart';

// Kartu produk. Dipakai di Home (list horizontal), Search dan Timeline (grid).
// Lebar & tinggi kartu mengikuti parent-nya (SizedBox / grid).
//
// sellerName dan uploadedText bersifat opsional: hanya Timeline yang mengisinya.
class ProductCard extends StatelessWidget {
  final Product product;
  final double imageHeight;
  final String? sellerName;
  final String? uploadedText;

  const ProductCard({
    super.key,
    required this.product,
    this.imageHeight = 150,
    this.sellerName,
    this.uploadedText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/home/product/${product.id}'),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kBorderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sellerName != null) ...[
              Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/40?u=$sellerName',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    sellerName!,
                    style: const TextStyle(fontSize: 12, color: kGreyColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Container(
              height: imageHeight,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Image.network(product.thumbnail, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Text(
              product.category,
              style: const TextStyle(fontSize: 12, color: kGreyColor),
            ),
            const SizedBox(height: 4),
            Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(
              '\$${product.price}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Row(
              children: [
                Icon(LucideIcons.mapPin, size: 16, color: kPrimaryColor),
                SizedBox(width: 6),
                Text(
                  '1,2 meters away',
                  style: TextStyle(fontSize: 12, color: kGreyColor),
                ),
              ],
            ),
            if (uploadedText != null) ...[
              const SizedBox(height: 8),
              Text(
                uploadedText!,
                style: const TextStyle(fontSize: 12, color: kGreyColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
