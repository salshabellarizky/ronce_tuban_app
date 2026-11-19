import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ronce_tuban_app/pages/tradition_detail_page.dart';
import 'package:ronce_tuban_app/providers/tradition_provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TraditionProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3A4C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Favorit',
          style: TextStyle(
            color: Color(0xFF1E3A4C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cerita yang ingin\nkamu ingat.',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A4C),
                height: 1.2,
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Simpan tradisi yang menarik hatimu.',
              style: TextStyle(color: Color(0xFF6B7A8D), fontSize: 13),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1E6),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(Icons.favorite_rounded, size: 16, color: Color(0xFFEF6B5B)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${provider.favoritList.length} tradisi tersimpan',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A4C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: provider.favoritList.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada tradisi tersimpan.',
                        style: TextStyle(color: Color(0xFF6B7A8D)),
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.favoritList.length,
                      itemBuilder: (context, index) {
                        final tradisi = provider.favoritList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TraditionDetailPage(tradisi: tradisi),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE3E8EE)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0F1E3A4C),
                                  blurRadius: 12,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  child: Image.network(
                                    tradisi.gambarUrl,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Tradisi',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xFF2B6B8D),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              tradisi.nama,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1E3A4C),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              tradisi.lokasiLengkap,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.favorite,
                                          color: Color(0xFFEF6B5B),
                                        ),
                                        onPressed: () => provider.toggleFavorit(tradisi),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0EC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.favorite_border, size: 14, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ketuk ikon hati pada tradisi untuk menambah atau menghapus favorit.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6B7A8D)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}