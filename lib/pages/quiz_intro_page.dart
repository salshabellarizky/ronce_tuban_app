import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ronce_tuban_app/models/region_model.dart';
import 'package:ronce_tuban_app/pages/quiz_question_page.dart';
import 'package:ronce_tuban_app/providers/quiz_provider.dart';

class QuizIntroPage extends StatelessWidget {
  final RegionModel region;

  const QuizIntroPage({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    final tradition = region.tradisiList.first;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFEFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3A4C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Kuis daerah',
            style: TextStyle(
                color: Color(0xFF1E3A4C), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    tradition.gambarUrl,
                    height: 166,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 166,
                      width: double.infinity,
                      color: const Color(0xFFE5F3FB),
                      child: const Icon(
                        Icons.waves_rounded,
                        color: Color(0xFF247BA0),
                        size: 48,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  right: 12,
                  bottom: 12,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFEAF4FA),
                    child: Icon(Icons.auto_awesome, color: Color(0xFF2B6B8D)),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('Kuis ${region.nama}',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B6B8D))),
            ),
            const SizedBox(height: 8),
            Text('Seberapa kenal kamu\ndengan ${region.nama}?',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A4C))),
            const SizedBox(height: 6),
            Text(
                'Dari ${tradition.nama}, rangkai kembali cerita yang baru kamu kenali.',
                style: const TextStyle(color: Color(0xFF6B7A8D), fontSize: 13)),
            if (region.nama == 'Kerek') ...[
              const SizedBox(height: 6),
              const Text(
                'Kuis ini merujuk pada ringkasan Tuntunan; praktik dapat berbeda di tiap keluarga dan desa.',
                style: TextStyle(
                  color: Color(0xFF82939A),
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFE5F3FB),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBadge(Icons.layers_outlined, '5 pertanyaan'),
                  _buildBadge(Icons.access_time, '± 3 menit'),
                  _buildBadge(
                    Icons.sentiment_satisfied_alt,
                    'Tanpa batas waktu',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Cara bermain',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A4C))),
            const SizedBox(height: 8),
            _buildBullet('Pilih satu jawaban di setiap pertanyaan.'),
            _buildBullet('Lihat skor dan pembahasan setelah selesai.'),
            _buildBullet('Boleh ulangi kuis sambil belajar lagi.'),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF247BA0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  context.read<QuizProvider>().resetKuis();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizQuestionPage(region: region),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Mulai kuis ${region.nama}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15)),
                    const SizedBox(width: 8),
                    const Icon(Icons.play_arrow, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text('Baca tradisi ${region.nama} dulu',
                    style: const TextStyle(
                        color: Color(0xFF247BA0),
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF2B6B8D), size: 20),
          const SizedBox(height: 4),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A4C))),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
                color: Colors.orangeAccent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF6B7A8D)))),
        ],
      ),
    );
  }
}
