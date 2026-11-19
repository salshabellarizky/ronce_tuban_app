import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ronce_tuban_app/models/tradition_model.dart';
import 'package:ronce_tuban_app/providers/tradition_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TraditionDetailPage extends StatelessWidget {
  final TraditionModel tradisi;

  const TraditionDetailPage({super.key, required this.tradisi});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TraditionProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F1),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: const Color(0xFFF7F5F1),
            foregroundColor: const Color(0xFF1E3A4C),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    tradisi.gambarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFE5F3FB),
                      child: const Icon(
                        Icons.waves_rounded,
                        color: Color(0xFF247BA0),
                        size: 56,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x001E3A4C),
                          Color(0x4D1E3A4C),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10, top: 8),
                decoration: const BoxDecoration(
                  color: Color(0xCCFFFFFF),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  tooltip: tradisi.isFavorite
                      ? 'Hapus dari favorit'
                      : 'Simpan ke favorit',
                  onPressed: () => provider.toggleFavorit(tradisi),
                  icon: Icon(
                    tradisi.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: tradisi.isFavorite
                        ? const Color(0xFFEF6B5B)
                        : const Color(0xFF1E3A4C),
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F3FB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tradisi.kategori.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: Color(0xFF247BA0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    tradisi.nama,
                    style: const TextStyle(
                      fontSize: 30,
                      height: 1.15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A4C),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE3E8EE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 17,
                          color: Color(0xFF247BA0),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tradisi.lokasiLengkap,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7A8D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _openMaps(context, tradisi.lokasiLengkap),
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Lihat lokasi di Maps'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF247BA0),
                        side: const BorderSide(color: Color(0xFFB8D6E5)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Maps menunjukkan area desa; titik pelaksanaan dapat berbeda.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF82939A),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    tradisi.deskripsiSingkat,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF455B68),
                    ),
                  ),
                  const SizedBox(height: 26),
                  _section('Cerita dan sejarah', tradisi.sejarah),
                  const SizedBox(height: 22),
                  _section('Makna tradisi', tradisi.makna),
                  const SizedBox(height: 22),
                  _section('Waktu pelaksanaan', tradisi.deskripsiWaktu),
                  const SizedBox(height: 22),
                  const Text(
                    'Gambaran prosesi',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A4C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...tradisi.gambaranProses.asMap().entries.map((entry) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE3E8EE)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: const Color(0xFFE5F3FB),
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF247BA0),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: Color(0xFF455B68),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (tradisi.sumberLabel != null) ...[
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFFE3E8EE)),
                    const SizedBox(height: 8),
                    const Text(
                      'Sumber bacaan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A4C),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      tradisi.sumberLabel!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7A8D),
                      ),
                    ),
                    if (tradisi.sumberUrl != null)
                      SelectableText(
                        tradisi.sumberUrl!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF247BA0),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    const SizedBox(height: 8),
                    const Text(
                      'Rincian waktu dan praktik dalam sumber ini dilaporkan dari Desa Gaji; praktik di Tengger dapat memiliki variasi setempat.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: Color(0xFF82939A),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openMaps(BuildContext context, String mapsQuery) async {
    final uri = Uri.https(
      'www.google.com',
      '/maps/search/',
      {'api': '1', 'query': mapsQuery},
    );

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka aplikasi Maps.')),
        );
      }
    } on PlatformException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka aplikasi Maps.')),
        );
      }
    }
  }

  Widget _section(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A4C),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: const TextStyle(
            fontSize: 13,
            height: 1.55,
            color: Color(0xFF6B7A8D),
          ),
        ),
      ],
    );
  }
}
