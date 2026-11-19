import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ronce_tuban_app/models/region_model.dart';
import 'package:ronce_tuban_app/providers/quiz_provider.dart';

class QuizResultPage extends StatelessWidget {
  final RegionModel region;

  const QuizResultPage({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    final questions = region.kuisList;
    final answers = context.watch<QuizProvider>().jawabanPengguna;
    final correctCount =
        context.read<QuizProvider>().jumlahJawabanBenar(questions);
    final score =
        questions.isEmpty ? 0 : (correctCount * 100 / questions.length).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3A4C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Hasil kuis ${region.nama}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A4C),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE5F3FB),
                      Color(0xFFF8F3EE),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFE3E8EE)),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.workspace_premium_outlined,
                        color: Color(0xFF1682BD),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'PERANGKAI CERITA ${region.nama.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1682BD),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Makin dekat dengan\nbudaya!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A4C),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$score',
                          style: const TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF247BA0),
                          ),
                        ),
                        const Text(
                          ' / 100',
                          style: TextStyle(
                            color: Color(0xFF6B8798),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      children: List.generate(questions.length, (index) {
                        final isCorrect = answers[index] ==
                            questions[index].indeksJawabanBenar;
                        return CircleAvatar(
                          radius: 12,
                          backgroundColor: isCorrect
                              ? const Color(0xFF247BA0)
                              : const Color(0xFFEF7B6C),
                          child: Icon(
                            isCorrect ? Icons.check : Icons.close,
                            size: 15,
                            color: Colors.white,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$correctCount jawaban benar dari ${questions.length} pertanyaan',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A4C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Satu cerita lagi untuk dipahami. Yuk, lihat pembahasannya!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B8798)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'Rangkai pemahamanmu',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A4C),
                ),
              ),
              const SizedBox(height: 14),
              ...questions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                final chosenIndex = answers[index];
                final isCorrect = chosenIndex == question.indeksJawabanBenar;
                final chosenText = chosenIndex == null
                    ? 'Belum ada jawaban dipilih.'
                    : question.pilihan[chosenIndex];

                return _ReviewCard(
                  label: 'PERTANYAAN ${question.id}',
                  title: question.judulPertanyaan,
                  answer: chosenText,
                  isCorrect: isCorrect,
                  correctAnswer: isCorrect
                      ? null
                      : 'Jawaban tepat: ${question.pilihan[question.indeksJawabanBenar]}',
                );
              }),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<QuizProvider>().resetKuis();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Kembali ke halaman awal',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.refresh, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String label;
  final String title;
  final String answer;
  final bool isCorrect;
  final String? correctAnswer;

  const _ReviewCard({
    required this.label,
    required this.title,
    required this.answer,
    required this.isCorrect,
    required this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor =
        isCorrect ? const Color(0xFF31866D) : const Color(0xFFEF6B5B);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD8E5EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B8798),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    isCorrect
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    color: statusColor,
                    size: 15,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isCorrect ? 'Benar' : 'Belum tepat',
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A4C),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            answer,
            style: const TextStyle(fontSize: 12, color: Color(0xFF1682BD)),
          ),
          if (correctAnswer != null) ...[
            const SizedBox(height: 7),
            Text(
              correctAnswer!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1682BD),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
