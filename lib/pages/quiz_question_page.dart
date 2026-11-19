import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ronce_tuban_app/models/region_model.dart';
import 'package:ronce_tuban_app/pages/quiz_result_page.dart';
import 'package:ronce_tuban_app/providers/quiz_provider.dart';

class QuizQuestionPage extends StatefulWidget {
  final RegionModel region;

  const QuizQuestionPage({super.key, required this.region});

  @override
  State<QuizQuestionPage> createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  int _currentIndex = 0;

  void _continueQuiz(QuizProvider quizProvider, int questionCount) {
    if (!quizProvider.jawabanPengguna.containsKey(_currentIndex)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih satu jawaban terlebih dahulu.')),
      );
      return;
    }

    if (_currentIndex == questionCount - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultPage(region: widget.region),
        ),
      );
      return;
    }

    setState(() => _currentIndex++);
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final region = widget.region;
    final kuisList = region.kuisList;
    final pertanyaan = kuisList[_currentIndex];
    final tradition = region.tradisiList.first;
    final selectedAnswer = quizProvider.jawabanPengguna[_currentIndex];
    final progress = ((_currentIndex + 1) * 100 / kuisList.length).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3A4C)),
          onPressed: () {
            if (_currentIndex > 0) {
              setState(() => _currentIndex--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Kuis ${region.nama}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A4C),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.close, color: Color(0xFF1E3A4C)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pertanyaan ${_currentIndex + 1} dari ${kuisList.length}',
                    style: const TextStyle(
                      color: Color(0xFF1682BD),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '$progress%',
                    style:
                        const TextStyle(color: Color(0xFF6B8798), fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: List.generate(kuisList.length, (index) {
                  return Expanded(
                    child: Container(
                      height: 5,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: index <= _currentIndex
                            ? const Color(0xFF247BA0)
                            : const Color(0xFFDCE8ED),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F3FB),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        tradition.gambarUrl,
                        width: 92,
                        height: 74,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 92,
                          height: 74,
                          color: const Color(0xFFDCE8ED),
                          child:
                              const Icon(Icons.waves, color: Color(0xFF247BA0)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TRADISI',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1682BD),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tradition.nama,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A4C),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${region.nama} · Tuban',
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF6B8798)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                pertanyaan.pertanyaan,
                style: const TextStyle(
                  fontSize: 23,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A4C),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: pertanyaan.pilihan.asMap().entries.map((entry) {
                      final isSelected = selectedAnswer == entry.key;
                      final label = String.fromCharCode(65 + entry.key);

                      return GestureDetector(
                        onTap: () =>
                            quizProvider.setJawaban(_currentIndex, entry.key),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFE5F3FB)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF1682BD)
                                  : const Color(0xFFD8E5EB),
                              width: isSelected ? 1.5 : 1,
                            ),
                            boxShadow: isSelected
                                ? const [
                                    BoxShadow(
                                      color: Color(0x1A247BA0),
                                      blurRadius: 14,
                                      offset: Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: isSelected
                                    ? const Color(0xFF247BA0)
                                    : const Color(0xFFF1F6F8),
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF6B8798),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: const Color(0xFF1E3A4C),
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Color(0xFF1682BD),
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      selectedAnswer == null
                          ? Icons.radio_button_unchecked
                          : Icons.check_circle_outline,
                      color: const Color(0xFF1682BD),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      selectedAnswer == null
                          ? 'Pilih satu jawaban'
                          : '1 jawaban dipilih',
                      style: const TextStyle(
                        color: Color(0xFF1682BD),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _continueQuiz(quizProvider, kuisList.length),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentIndex == kuisList.length - 1
                            ? 'Lihat hasil kuis'
                            : 'Konfirmasi jawaban',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 2),
              const Center(
                child: Text(
                  'Pembahasan tersedia setelah kuis selesai.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF6B8798)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
