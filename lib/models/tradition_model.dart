class TraditionModel {
  final int id;
  final String nama;
  final String daerah;
  final String lokasiLengkap;
  final String kategori;
  final String deskripsiSingkat;
  final String waktuPelaksanaan;
  final String deskripsiWaktu;
  final String sejarah;
  final String makna;
  final List<String> gambaranProses;
  final String gambarUrl;
  final String? sumberLabel;
  final String? sumberUrl;
  bool isFavorite;

  TraditionModel({
    required this.id,
    required this.nama,
    required this.daerah,
    required this.lokasiLengkap,
    required this.kategori,
    required this.deskripsiSingkat,
    required this.waktuPelaksanaan,
    required this.deskripsiWaktu,
    required this.sejarah,
    required this.makna,
    required this.gambaranProses,
    required this.gambarUrl,
    this.sumberLabel,
    this.sumberUrl,
    this.isFavorite = false,
  });
}
