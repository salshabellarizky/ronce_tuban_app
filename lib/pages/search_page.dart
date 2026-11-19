import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ronce_tuban_app/models/tradition_model.dart';
import 'package:ronce_tuban_app/pages/tradition_detail_page.dart';
import 'package:ronce_tuban_app/providers/tradition_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TraditionModel> _filteredTraditions(TraditionProvider provider) {
    final traditions = provider.semuaTradisi;
    final query = _searchController.text.trim().toLowerCase();

    return traditions.where((tradition) {
      final matchesFilter = switch (_selectedFilter) {
        'Favorit' => tradition.isFavorite,
        'Pesisir' => tradition.kategori.toLowerCase().contains('pesisir'),
        _ => true,
      };
      final searchableText = [
        tradition.nama,
        tradition.daerah,
        tradition.lokasiLengkap,
        tradition.kategori,
        tradition.deskripsiSingkat,
      ].join(' ').toLowerCase();

      return matchesFilter && (query.isEmpty || searchableText.contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TraditionProvider>();
    final traditions = _filteredTraditions(provider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3A4C)),
        ),
        title: const Text(
          'Cari cerita',
          style: TextStyle(
            color: Color(0xFF1E3A4C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Nama tradisi, daerah, atau lokasi',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF247BA0),
                  ),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Hapus pencarian',
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0xFFD8E5EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0xFFD8E5EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Color(0xFF247BA0),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Semua', 'Pesisir', 'Favorit'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (_) => setState(() {
                          _selectedFilter = filter;
                        }),
                        selectedColor: const Color(0xFFE5F3FB),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF247BA0)
                              : const Color(0xFFD8E5EB),
                        ),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? const Color(0xFF247BA0)
                              : const Color(0xFF6B7A8D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${traditions.length} cerita ditemukan',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7A8D),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: traditions.isEmpty
                    ? _EmptySearchState(
                        onReset: () {
                          _searchController.clear();
                          setState(() => _selectedFilter = 'Semua');
                        },
                      )
                    : ListView.separated(
                        itemCount: traditions.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final tradition = traditions[index];
                          return _TraditionSearchCard(
                            tradition: tradition,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TraditionDetailPage(tradisi: tradition),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TraditionSearchCard extends StatelessWidget {
  final TraditionModel tradition;
  final VoidCallback onTap;

  const _TraditionSearchCard({
    required this.tradition,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE3E8EE)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  tradition.gambarUrl,
                  width: 86,
                  height: 86,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 86,
                    height: 86,
                    color: const Color(0xFFE5F3FB),
                    child: const Icon(
                      Icons.waves_rounded,
                      color: Color(0xFF247BA0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tradition.kategori.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF247BA0),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      tradition.nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A4C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tradition.lokasiLengkap,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7A8D),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF247BA0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  final VoidCallback onReset;

  const _EmptySearchState({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFE5F3FB),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                color: Color(0xFF247BA0),
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Cerita belum ditemukan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A4C),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Coba kata kunci lain atau ubah filter pencarian.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7A8D),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onReset,
              child: const Text('Atur ulang pencarian'),
            ),
          ],
        ),
      ),
    );
  }
}
