import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentImageIndex = 0;
  bool _isWishlisted = false;
  final PageController _pageController = PageController();

  // Mock Data presisi sesuai screenshot Figma
  final Map<String, dynamic> productData = {
    "images": [
      "https://picsum.photos/400/400?random=10",
      "https://picsum.photos/400/400?random=11",
      "https://picsum.photos/400/400?random=12",
    ],
    "title": "Sepatu putih platform shoes",
    "size": "Ukuran 41",
    "condition": "Kondisi sempurna",
    "price": 200000,
    "inCartCount": 3,
    "bidCount": 3,
    "description": "Nike putih. Cuman pernah dipake 3 kali dan masih bersih.",
    "hashtags": ["#sneakers"],
    "colorName": "Putih",
    "uploadedTime": "DI UNGGAH 3 HARI YANG LALU",
    "seller": {
      "username": "kopiaren22",
      "avatarUrl": "https://i.pravatar.cc/150?img=68",
      "activeStatus": "Aktif hari ini",
    },
    "recommendations": [
      {
        "title": "Sepatu heels wedge kulit leather hitam",
        "category": "Sepatu",
        "imageUrl": "https://picsum.photos/200/200?random=20",
      },
      {
        "title": "Sepatu adidas putih handball 40",
        "category": "Sepatu",
        "imageUrl": "https://picsum.photos/200/200?random=21",
      },
      {
        "title": "Adidas Originals unisex",
        "category": "Sepatu",
        "imageUrl": "https://picsum.photos/200/200?random=22",
      },
    ]
  };

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Content Area
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(primaryRed),
                _buildActivityBadges(),
                _buildProductHeader(primaryRed),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                ),
                _buildProtectionAndShipping(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                ),
                _buildDescriptionSection(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                ),
                _buildSellerSection(context, primaryRed),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                ),
                _buildRecommendationsSection(),
                const SizedBox(height: 110), // Spacing untuk Bottom Action Bar
              ],
            ),
          ),

          // Top Floating Header Icons (Back, Share, Cart, Menu)
          _buildFloatingHeader(context),

          // Bottom Action Bar (Sticky)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomActionBar(context, primaryRed),
          ),
        ],
      ),
    );
  }

  // Header Navigasi Transparan Melayang
  Widget _buildFloatingHeader(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCircleIconButton(
              icon: Icons.chevron_left,
              onPressed: () => Navigator.maybePop(context),
            ),
            Row(
              children: [
                _buildCircleIconButton(
                  icon: Icons.shortcut_outlined,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                _buildCircleIconButton(
                  icon: Icons.shopping_cart_outlined,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                _buildCircleIconButton(
                  icon: Icons.menu,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87, size: 20),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  // Carousel Foto Produk & Indikator Titik
  Widget _buildImageCarousel(Color primaryRed) {
    final List<String> images = List<String>.from(productData["images"]);

    return Stack(
      children: [
        SizedBox(
          height: 360,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentImageIndex = idx),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Image.network(
                images[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 60, color: Colors.grey),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index
                      ? primaryRed
                      : Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Badges Aktivitas (Di keranjang N orang & Ditawar N orang)
  Widget _buildActivityBadges() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 6),
      child: Row(
        children: [
          _buildBadgeItem(
            icon: Icons.shopping_bag_outlined,
            label: "Di dalam keranjang ${productData['inCartCount']} orang",
          ),
          const SizedBox(width: 8),
          _buildBadgeItem(
            icon: Icons.chat_bubble_outline,
            label: "Ditawar ${productData['bidCount']} orang",
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2), // Merah soft
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFFEF4444)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  // Header Produk (Judul, Wishlist, Ukuran/Kondisi, Harga)
  Widget _buildProductHeader(Color primaryRed) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  productData["title"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _isWishlisted = !_isWishlisted),
                child: Icon(
                  _isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: _isWishlisted ? primaryRed : Colors.black87,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "${productData['size']}  •  ${productData['condition']}",
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          Text(
            "Rp${productData['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryRed,
            ),
          ),
        ],
      ),
    );
  }

  // Section Perlindungan Pembeli & Kecepatan Pengiriman
  Widget _buildProtectionAndShipping() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.shield_outlined, size: 22, color: Colors.black87),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Semua pembelian melalui TelUsed dilindungi oleh Perlindungan Pembeli.",
                      style: TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.3),
                    ),
                    const SizedBox(height: 2),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Lebih lanjut",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.local_shipping_outlined, size: 22, color: Colors.black87),
              const SizedBox(width: 14),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.3),
                    children: const [
                      TextSpan(text: "Penjual ini sering mengirimkan dalam:\n"),
                      TextSpan(
                        text: "3 hari",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section Deskripsi, Hashtag, Warna & Upload Time
  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productData["description"],
            style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Text(
            productData["hashtags"].join(" "),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                productData["colorName"],
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            productData["uploadedTime"],
            style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Section Kartu Penjual (Kunjungi Toko & Chat Penjual)
  Widget _buildSellerSection(BuildContext context, Color primaryRed) {
    final seller = productData["seller"];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(seller["avatarUrl"]),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    seller["username"],
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    seller["activeStatus"],
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    "Kunjungi Toko",
                    style: TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Routing ke T-10 (Chat Penjual)
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    "Chat Penjual",
                    style: TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section "Anda mungkin menyukai" (Horizontal Card List)
  Widget _buildRecommendationsSection() {
    final recs = productData["recommendations"] as List;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Anda mungkin menyukai",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: recs.length,
              itemBuilder: (context, index) {
                final item = recs[index];
                return Container(
                  width: 140,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item["imageUrl"],
                          height: 130,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item["category"],
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item["title"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87, height: 1.2),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Action Bar Menempel di Bawah (Keranjang, Beri Tawaran, Beli Sekarang)
  Widget _buildBottomActionBar(BuildContext context, Color primaryRed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Icon Keranjang Kotak
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFEF4444)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFFEF4444), size: 20),
                onPressed: () {},
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(width: 8),

            // Tombol "Beri Tawaran"
            Expanded(
              child: SizedBox(
                height: 42,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Beri Tawaran",
                    style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Tombol "Beli Sekarang"
            Expanded(
              child: SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Beli Sekarang",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}