import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/widgets/Const/colors.dart';
import '../../../core/widgets/Widget/location_row.dart';
import '../../../core/widgets/Widget/product_grid.dart';
import '../../../core/widgets/Widget/search_box.dart';
import '../../../core/widgets/Widget/underline_tabs.dart';
import '../../home/data/home.dart';
import '../data/search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController controller = TextEditingController();

  List<String> suggestions = []; // Searching 2
  List<Product> results = []; // Searching 3
  bool showResults = false;
  bool isLoading = false;
  int selectedTab = 0; // 0 = Terkait, 1 = Terbaru

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Dipanggil setiap user mengetik.
  void onTextChanged(String text) async {
    setState(() {
      showResults = false;
    });

    if (text.trim().isEmpty) {
      setState(() {
        suggestions = [];
      });
      return;
    }

    try {
      final found = await searchProduct(text);
      // Kalau user sudah mengetik lagi, abaikan hasil lama ini.
      if (!mounted || text != controller.text) return;
      setState(() {
        suggestions = found.take(5).map((p) => p.title).toList();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        suggestions = [];
      });
    }
  }

  // Dipanggil saat user menekan Enter atau memilih saran.
  void submitSearch(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    controller.text = query;
    recentSearches.remove(query);
    recentSearches.insert(0, query);

    FocusScope.of(context).unfocus();
    setState(() {
      showResults = true;
      isLoading = true;
      selectedTab = 0;
    });

    try {
      final found = await searchProduct(query);
      if (!mounted) return;
      setState(() {
        results = found;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        results = [];
        isLoading = false;
      });
    }
  }

  // Tombol panah di samping saran: isi kolom tanpa mencari.
  void fillText(String text) {
    controller.text = text;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
    onTextChanged(text);
  }

  void clearText() {
    controller.clear();
    setState(() {
      suggestions = [];
      showResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(LucideIcons.chevronLeft, size: 24),
          ),
          Expanded(
            child: SearchBox(
              child: Row(
                children: [
                  const Icon(LucideIcons.search, size: 20, color: kGreyColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: onTextChanged,
                      onSubmitted: submitSearch,
                      decoration: const InputDecoration(
                        hintText: 'Search our catalog..',
                        hintStyle: TextStyle(color: kGreyColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: clearText,
                      child: const Icon(LucideIcons.circleX, size: 18, color: kGreyColor),
                    ),
                ],
              ),
            ),
          ),
          // Ikon filter hanya muncul di halaman hasil.
          if (showResults) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => context.push('/filter'),
              child: const Icon(LucideIcons.slidersHorizontal, size: 22, color: kPrimaryColor),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (showResults) return _buildResults();
    if (controller.text.trim().isEmpty) return _buildRecent();
    return _buildSuggestions();
  }

  // ---------- Searching 1: riwayat ----------
  Widget _buildRecent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent searches',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () => setState(() => recentSearches.clear()),
                child: const Icon(LucideIcons.circleX, size: 18, color: kGreyColor),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: recentSearches.length,
            itemBuilder: (context, i) => _buildSuggestionRow(recentSearches[i]),
          ),
        ),
      ],
    );
  }

  // ---------- Searching 2: saran saat mengetik ----------
  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: suggestions.length,
      itemBuilder: (context, i) => _buildSuggestionRow(suggestions[i]),
    );
  }

  // Satu baris (dipakai oleh riwayat dan saran).
  Widget _buildSuggestionRow(String text) {
    return InkWell(
      onTap: () => submitSearch(text),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(LucideIcons.search, size: 18, color: kGreyColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            InkWell(
              onTap: () => fillText(text),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(LucideIcons.arrowUpLeft, size: 18, color: kGreyColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Searching 3: hasil ----------
  Widget _buildResults() {
    // "Terbaru" dibuat dengan membalik urutan, karena dummyjson tidak punya tanggal.
    final shown = selectedTab == 0 ? results : results.reversed.toList();

    return Column(
      children: [
        UnderlineTabs(
          labels: const ['Terkait', 'Terbaru'],
          selectedIndex: selectedTab,
          onChanged: (i) => setState(() => selectedTab = i),
        ),
        _buildFilterChips(),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: LocationRow(),
        ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : shown.isEmpty
                  ? const Center(child: Text('Produk tidak ditemukan'))
                  : ProductGrid(products: shown),
        ),
      ],
    );
  }

  // Chip filter: tampilan saja dulu, belum berfungsi.
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          _buildChip('Harga', icon: LucideIcons.arrowUpDown),
          const SizedBox(width: 8),
          _buildChip('COD'),
          const SizedBox(width: 8),
          _buildChip('Gratis Ongkir'),
          const SizedBox(width: 8),
          _buildChip('100% Ori'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: kGreyColor)),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, size: 14, color: kGreyColor),
          ],
        ],
      ),
    );
  }
}
