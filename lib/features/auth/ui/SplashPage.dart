import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/Const/colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isLight = false;

  @override
  void initState() {
    super.initState();

    // Setelah 1,2 detik: animasi berubah warna
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isLight = true);
    });

    // Setelah 2,4 detik: pindah ke Login
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 600);
    const lightBg = Color(0xFFF9F9F9);

    return Scaffold(
      body: AnimatedContainer(
        duration: duration,
        color: _isLight ? lightBg : kPrimaryColor,
        child: Center(
          child: AnimatedContainer(
            duration: duration,
            width: 100,
            height: 100,
            padding: const EdgeInsets.only(left: 14),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: _isLight ? kPrimaryColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedDefaultTextStyle(
              duration: duration,
              style: TextStyle(
                fontSize: 24,
                height: 1.05,
                fontWeight: FontWeight.w900,
                color: _isLight ? Colors.white : kPrimaryColor,
              ),
              child: const Text('Tel-\nUsed'),
            ),
          ),
        ),
      ),
    );
  }
}