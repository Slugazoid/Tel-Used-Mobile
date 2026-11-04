import 'package:flutter/material.dart';

import '../../../core/widgets/Widget/add_fab.dart';
import '../../../core/widgets/Widget/product_grid.dart';
import '../../../core/widgets/Widget/underline_tabs.dart';
import '../../home/data/home.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  int selectedTab = 0; // 0 = Following, 1 = For you
  List<Product> following = [];
  List<Product> forYou = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    try {
      final a = await fetchProduct();
      //mulai dari produk ke-10.
      final b = await fetchProduct(skip: 10);
      if (!mounted) return;
      setState(() {
        forYou = a;
        following = b;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final shown = selectedTab == 0 ? following : forYou;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      floatingActionButton: const AddFab(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: UnderlineTabs(
                labels: const ['Following', 'For you'],
                selectedIndex: selectedTab,
                onChanged: (i) => setState(() => selectedTab = i),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : shown.isEmpty
                      ? const Center(child: Text('Belum ada postingan'))
                      : ProductGrid(products: shown, showSeller: true),
            ),
          ],
        ),
      ),
    );
  }
}
