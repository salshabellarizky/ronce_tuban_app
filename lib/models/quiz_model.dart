class QuizQuestionModel {
  final String id;
  final String judulPertanyaan;
  final String pertanyaan;
  final List<String> pilihan;
  final int indeksJawabanBenar;

  QuizQuestionModel({
    required this.id,
    required this.judulPertanyaan,
    required this.pertanyaan,
    required this.pilihan,
    required this.indeksJawabanBenar,
  });
}