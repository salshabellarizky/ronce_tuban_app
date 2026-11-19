import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ronce_tuban_app/models/region_model.dart';
import 'package:ronce_tuban_app/models/tradition_model.dart';
import 'package:ronce_tuban_app/pages/quiz_intro_page.dart';
import 'package:ronce_tuban_app/pages/tradition_detail_page.dart';
import 'package:ronce_tuban_app/providers/tradition_provider.dart';

class RegionDetailPage extends StatelessWidget {
  final RegionModel? region;

  const RegionDetailPage({super.key, this.region});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TraditionProvider>();
    final selectedRegion = region ?? provider.regionPalang;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFEFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3A4C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kenali daerah',
          style: TextStyle(
            color: Color(0xFF1E3A4C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                selectedRegion.gambarUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  width: double.infinity,
                  color: const Color(0xFFE5F3FB),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF247BA0),
                    size: 48,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'ⓘ Foto ilustratif untuk mengenalkan suasana tradisi.',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              selectedRegion.nama,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A4C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              selectedRegion.deskripsi,
              style: const TextStyle(
                color: Color(0xFF6B7A8D),
                height: 1.4,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _RegionStat(
                    icon: Icons.menu_book,
                    label:
                        '${selectedRegion.tradisiList.length} tradisi pilihan',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _RegionStat(
                    icon: Icons.stars_outlined,
                    label: '${selectedRegion.kuisList.length} kuis daerah',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Tradisi di ${selectedRegion.nama}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A4C),
              ),
            ),
            const SizedBox(height: 12),
            ...selectedRegion.tradisiList.map(
              (tradition) => _TraditionCard(
                tradition: tradition,
                onOpen: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TraditionDetailPage(tradisi: tradition),
                    ),
                  );
                },
                onFavorite: () => provider.toggleFavorit(tradition),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nama dan bentuk kegiatan dapat berbeda di tiap desa. Koleksi ini adalah pintu awal untuk mengenalnya.',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            if (selectedRegion.kuisList.isNotEmpty) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F3FB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✦ KUIS DAERAH · ${selectedRegion.nama.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B6B8D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sudah kenal tradisinya?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A4C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rangkai pengetahuanmu lewat ${selectedRegion.kuisList.length} pertanyaan singkat tentang tradisi ${selectedRegion.nama}.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7A8D),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF247BA0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  QuizIntroPage(region: selectedRegion),
                            ),
                          );
                        },
                        child: Text(
                          'Coba kuis ${selectedRegion.nama} →',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RegionStat extends StatelessWidget {
  final IconData icon;
  final String label;

  const _RegionStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF2B6B8D), size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A4C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TraditionCard extends StatelessWidget {
  final TraditionModel tradition;
  final VoidCallback onOpen;
  final VoidCallback onFavorite;

  const _TraditionCard({
    required this.tradition,
    required this.onOpen,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                tradition.gambarUrl,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 88,
                  height: 88,
                  color: const Color(0xFFE5F3FB),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
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
                  const Text(
                    'Tradisi',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF2B6B8D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    tradition.nama,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A4C),
                    ),
                  ),
                  Text(
                    tradition.lokasiLengkap,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: tradition.isFavorite
                  ? 'Hapus dari favorit'
                  : 'Simpan ke favorit',
              icon: Icon(
                tradition.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: const Color(0xFFEF6B5B),
              ),
              onPressed: onFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
