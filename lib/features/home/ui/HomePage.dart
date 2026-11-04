import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tel_used_mobile/features/home/data/home.dart';

import '../../../core/widgets/Const/colors.dart';
import '../../../core/widgets/Widget/add_fab.dart';
import '../../../core/widgets/Widget/location_row.dart';
import '../../../core/widgets/Widget/product_card.dart';
import '../../../core/widgets/Widget/search_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static const _categories = [
    _Category('Elektronik &\nGadget', LucideIcons.headphones),
    _Category('Peralatan Praktikum &\nAkademik', LucideIcons.calculator),
    _Category('Aksesoris &\nMultimedia', LucideIcons.camera),
  ];

  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  void loadProduct() async {
    final result = await fetchProduct();
    setState(() {
      products = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      floatingActionButton: const AddFab(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchRow(),
              _buildLocation(),
              _buildBanner(),
              _buildSectionTitle('For You'),
              _buildProductList(context),
              _buildSectionTitle('Category'),
              _buildCategoryList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            // Cuma tampilan; ketuk untuk pindah ke halaman search.
            child: GestureDetector(
              onTap: () => context.push('/search'),
              child: const SearchBox(
                child: Row(
                  children: [
                    Icon(LucideIcons.search, size: 20, color: kGreyColor),
                    SizedBox(width: 12),
                    Text('Search our catalog..', style: TextStyle(color: kGreyColor)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Ikon keranjang dengan titik merah di pojok kanan atas.
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(LucideIcons.shoppingCart, size: 26),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () => context.push('/chat'),
            child: const Icon(LucideIcons.messageSquareMore, size: 26),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: LocationRow(),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 186,
          width: double.infinity,
          color: kPrimaryColor,
          child: Stack(
            children: [
              // Lingkaran dekorasi.
              Positioned(
                right: 20,
                top: -70,
                child: _circle(150, Colors.black.withValues(alpha: 0.25)),
              ),
              Positioned(
                right: 80,
                bottom: -50,
                child: _circle(90, Colors.black.withValues(alpha: 0.25)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'lagi nyari apa nih?',
                            style: TextStyle(color: Colors.white, fontSize: 9),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Laptop, Kamera,Alat Praktikum – Semua Ada!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Harga Miring, Barang Kece!',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Image.asset('assets/images/laptop_telused.png'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Icon(LucideIcons.chevronRight, size: 22),
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    if(isLoading) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) => SizedBox(
          width: 190,
          child: ProductCard(product: products[i], imageHeight: 180),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final c = _categories[i];
          return SizedBox(
            width: 150,
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F0F2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(c.icon, size: 40, color: kPrimaryColor),
                ),
                const SizedBox(height: 8),
                Text(c.name, textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Product {
  final String category;
  final String name;
  final String price;
  final String distance;

  const _Product(this.category, this.name, this.price, this.distance);
}

class _Category {
  final String name;
  final IconData icon;

  const _Category(this.name, this.icon);
}
