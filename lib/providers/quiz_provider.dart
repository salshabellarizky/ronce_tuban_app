import 'package:flutter/material.dart';
import 'package:ronce_tuban_app/models/quiz_model.dart';

class QuizProvider with ChangeNotifier {
  final Map<int, int> _jawabanPengguna = {};
  Map<int, int> get jawabanPengguna => _jawabanPengguna;

  int jumlahJawabanBenar(List<QuizQuestionModel> pertanyaan) {
    return _jawabanPengguna.entries.where((entry) {
      return entry.key < pertanyaan.length &&
          pertanyaan[entry.key].indeksJawabanBenar == entry.value;
    }).length;
  }

  void setJawaban(int indexPertanyaan, int indexPilihan) {
    _jawabanPengguna[indexPertanyaan] = indexPilihan;
    notifyListeners();
  }

  void resetKuis() {
    _jawabanPengguna.clear();
    notifyListeners();
  }
}