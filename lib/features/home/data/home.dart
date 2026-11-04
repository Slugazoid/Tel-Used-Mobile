import 'dart:convert';
import 'package:http/http.dart' as http;

class Product{
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.thumbnail,
    required this.images
  });

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json['id'], 
      title: json['title'], 
      description: json['description'],
      category: json['category'], 
      price: (json['price'] as num).toDouble(), 
      thumbnail: json['thumbnail'],
      images: List<String>.from(json['images'])
      ); 
  } 
}

// skip = lewati N produk pertama (dipakai Timeline tab "Following").
Future<List<Product>> fetchProduct({int skip = 0}) async{
  final res = await http.get(Uri.parse('https://dummyjson.com/products?limit=10&skip=$skip'));

  if(res.statusCode != 200){
    throw Exception("Failed to load Products!");
  }

  final data = jsonDecode(res.body);
  final List list = data['products'];
  return list.map((item) => Product.fromJson(item)).toList();
}

Future<Product> fetchProductById(int id) async {
  final res = await http.get(Uri.parse('https://dummyjson.com/products/$id'));

  if(res.statusCode != 200){
    throw Exception("Failed to load a product");
  }

  return Product.fromJson(jsonDecode(res.body));
}