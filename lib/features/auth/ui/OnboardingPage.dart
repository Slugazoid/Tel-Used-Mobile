import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/Const/colors.dart';

/// Data satu halaman onboarding
class _Slide {
  final String image;
  final String title;
  final String description;
  final bool textOnTop; // true = teks di atas gambar (halaman 2)

  const _Slide({
    required this.image,
    required this.title,
    required this.description,
    this.textOnTop = false,
  });
}

/// Onboarding 3 halaman setelah Splash
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _page = 0;

  final _slides = const [
    _Slide(
      image: 'assets/images/onboarding_1.png',
      title: 'Selamat datang di TelUsed',
      description:
          'Temukan fashion, gadget, dan barang unik dari pengguna lain. '
          'Siapa tahu, harta karun impianmu ada di sini!',
    ),
    _Slide(
      image: 'assets/images/onboarding_2.png',
      title: 'Jual Barangmu dengan Mudah',
      description: 'Foto, unggah, jual. Gitu aja. '
          'Ubah barang tak terpakai jadi penghasilan instan.',
      textOnTop: true,
    ),
    _Slide(
      image: 'assets/images/onboarding_3.png',
      title: 'Fast Delivery',
      description: 'Barang sampai lebih cepat, belanja jadi makin nyaman! '
          'Pilih opsi pengiriman cepat dan nikmati pengalaman belanja tanpa lama.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goLogin() => context.go('/login');

  void _next() {
    if (_page < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goLogin(); // halaman terakhir -> Login
    }
  }

  void _back() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Tombol Skip
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _goLogin,
                child: const Text(
                  'Skip',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ),

            // Isi halaman (bisa digeser)
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _page = index),
                children: _slides.map(_buildSlide).toList(),
              ),
            ),

            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(_Slide slide) {
    final text = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            slide.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            slide.description,
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              color: Color(0xFF6B6B6B),
            ),
          ),
        ],
      ),
    );

    final image = Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Image.asset(slide.image, fit: BoxFit.contain),
      ),
    );

    return Column(
      children: slide.textOnTop ? [text, image] : [image, text],
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tombol Back hanya di halaman ke-2 (sesuai desain)
          if (_page == 1)
            ElevatedButton(
              onPressed: _back,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEDEEF5),
                foregroundColor: const Color(0xFF444444),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: const StadiumBorder(),
              ),
              child: const Text('Back'),
            ),

          // Titik indikator halaman
          Row(
            children: List.generate(_slides.length, (index) {
              final active = index == _page;
              return Container(
                margin: const EdgeInsets.only(right: 6),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? kPrimaryColor : const Color(0xFFF7C5C5),
                ),
              );
            }),
          ),

          // Tombol Next
          ElevatedButton(
            onPressed: _next,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: const StadiumBorder(),
            ),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}