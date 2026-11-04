import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/widgets/Const/colors.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // Semua chip yang sedang dipilih (berdasarkan teksnya).
  final Set<String> selected = {};

  final TextEditingController dateMin = TextEditingController();
  final TextEditingController dateMax = TextEditingController();
  final TextEditingController priceMin = TextEditingController();
  final TextEditingController priceMax = TextEditingController();

  @override
  void dispose() {
    dateMin.dispose();
    dateMax.dispose();
    priceMin.dispose();
    priceMax.dispose();
    super.dispose();
  }

  void toggleChip(String label) {
    setState(() {
      if (selected.contains(label)) {
        selected.remove(label);
      } else {
        selected.add(label);
      }
    });
  }

  void reset() {
    setState(() {
      selected.clear();
      dateMin.clear();
      dateMax.clear();
      priceMin.clear();
      priceMax.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle('Kategori', seeMore: true),
                    _buildChips(['Sepatu heels', 'Sepatu sneaker', 'Sepatu running', 'Tas', 'Jaket']),
                    _buildTitle('Kata kunci', seeMore: true),
                    _buildChips(['#vintage', '#adidas', '#casual', '#hitam', '#unisex']),
                    _buildTitle('Tanggal unggah'),
                    _buildRange(dateMin, dateMax),
                    _buildChips(['1 minggu terakhir', '2 minggu terakhir', '1 bulan terakhir']),
                    _buildTitle('Lokasi', seeMore: true),
                    const Text('Cabang', style: TextStyle(fontSize: 12, color: kGreyColor)),
                    const SizedBox(height: 8),
                    _buildChips(['Bandung', 'Jakarta', 'Purwokerto', 'Surabaya']),
                    _buildTitle('Price range'),
                    _buildRange(priceMin, priceMax),
                    _buildChips(['0-50rb', '0-75rb', '35rb-75rb', '35rb-100rb']),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(LucideIcons.chevronLeft, size: 24),
          ),
          const Expanded(
            child: Text(
              'Filter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          GestureDetector(
            onTap: reset,
            child: const Text(
              'Reset',
              style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // Judul section, dengan "See more" di kanan kalau seeMore = true.
  Widget _buildTitle(String title, {bool seeMore = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          if (seeMore)
            const Text('See more', style: TextStyle(fontSize: 12, color: kGreyColor)),
        ],
      ),
    );
  }

  Widget _buildChips(List<String> labels) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final label in labels) _buildChip(label),
      ],
    );
  }

  Widget _buildChip(String label) {
    final isOn = selected.contains(label);
    return GestureDetector(
      onTap: () => toggleChip(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isOn ? const Color(0xFFFDECEC) : const Color(0xFFF0F2F7),
          border: Border.all(color: isOn ? kPrimaryColor : Colors.transparent),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isOn ? kPrimaryColor : kGreyColor,
          ),
        ),
      ),
    );
  }

  // Dua kotak Min - Max dengan garis di tengah.
  Widget _buildRange(TextEditingController min, TextEditingController max) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: _buildNumberBox('Min', min)),
          Container(
            width: 40,
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: kGreyColor,
          ),
          Expanded(child: _buildNumberBox('Max', max)),
        ],
      ),
    );
  }

  Widget _buildNumberBox(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: kGreyColor),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
      ),
    );
  }
}
