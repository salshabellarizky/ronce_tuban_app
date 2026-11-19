import 'package:ronce_tuban_app/models/tradition_model.dart';
import 'package:ronce_tuban_app/models/quiz_model.dart';

class RegionModel {
  final String nama;
  final String deskripsi;
  final String gambarUrl;
  final List<TraditionModel> tradisiList;
  final List<QuizQuestionModel> kuisList;

  RegionModel({
    required this.nama,
    required this.deskripsi,
    required this.gambarUrl,
    required this.tradisiList,
    required this.kuisList,
  });
}