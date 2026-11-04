import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../home/data/home.dart';

// Riwayat pencarian. Disimpan di memori saja,
// jadi hilang kalau aplikasi ditutup.
List<String> recentSearches = ['rice cooker', 'hoodie', 'mouse wireless'];

// Cari produk di dummyjson: /products/search?q=kata
Future<List<Product>> searchProduct(String query) async {
  final q = Uri.encodeQueryComponent(query);
  final res = await http.get(
    Uri.parse('https://dummyjson.com/products/search?q=$q&limit=20'),
  );

  if (res.statusCode != 200) {
    throw Exception('Failed to search products!');
  }

  final data = jsonDecode(res.body);
  final List list = data['products'];
  return list.map((item) => Product.fromJson(item)).toList();
}
