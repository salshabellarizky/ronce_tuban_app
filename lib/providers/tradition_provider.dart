import 'package:flutter/material.dart';
import 'package:ronce_tuban_app/helpers/db_helper.dart';
import 'package:ronce_tuban_app/models/region_model.dart';
import 'package:ronce_tuban_app/models/tradition_model.dart';
import 'package:ronce_tuban_app/models/quiz_model.dart';

class TraditionProvider with ChangeNotifier {
  bool _isDisposed = false;
  static const _fotoDusDusan =
      'https://img.inews.co.id/media/600/files/networks/2024/04/18/8fe8a_vian.jpeg';
  static const _fotoTuntunan =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTt2V37I8Rkn1ozerWKc-e7zK52a5PTE28-sejGTDc9HuZ8iU-ze7_4lW8T&s=10';

  final RegionModel _regionPalang = RegionModel(
    nama: 'Palang',
    deskripsi:
        'Di pesisir Palang, kehidupan masyarakat dekat dengan laut. Tradisi menjadi ruang untuk bersyukur, berdoa, dan menjaga hubungan antarwarga.',
    gambarUrl: _fotoDusDusan,
    tradisiList: [
      TraditionModel(
        id: 1,
        nama: 'Dus-Dusan',
        daerah: 'Palang',
        lokasiLengkap: 'Gesikharjo, Palang - Tuban',
        kategori: 'Tradisi pesisir',
        deskripsiSingkat:
            'Merawat rasa syukur sekaligus mempererat kebersamaan warga pesisir.',
        waktuPelaksanaan: 'Mengikuti agenda setempat',
        deskripsiWaktu:
            'Digelar setiap tahun, tepatnya satu minggu setelah Hari Raya Idul Fitri atau usai perayaan Lebaran Ketupat.',
        sejarah:
            'Secara historis, awal mula Tradisi Dus-Dusan berakar dari corak kehidupan masyarakat Desa Gesikharjo, Kecamatan Palang, Tuban yang sejak masa lampau didominasi oleh profesi nelayan. Istilah "Dus-Dusan" sendiri berasal dari bahasa Jawa lokal (adus-adusan) yang berarti pesta mandi bersama.',
        makna:
            'Mandi laut bersama ini diyakini sebagai ritual tolak bala untuk menghanyutkan nasib sial, melerung kesalahan masa lalu, serta memohon kesembuhan penyakit fisik. Di balik riuh tawa warga, Dus-Dusan adalah wujud syukur paling nyata atas berkah laut yang melimpah sekaligus momentum sakral yang meruntuhkan sekat sosial demi mempererat silaturahmi antarwarga.',
        gambaranProses: [
          'Selamatan Ketupat: Warga berkumpul di masjid membawa ketupat untuk didoakan bersama, lalu dimakan bersama sebagai wujud syukur.',
          'Bergerak ke Pantai: Tanpa komando, seluruh warga—dari balita hingga lansia—serentak berjalan memadati kawasan pantai Desa Gesikharjo.',
          'Mandi Laut Massal: Warga langsung menceburkan diri dan berendam bersama di laut saat kondisi air sedang pasang pagi hari.',
          'Selesai: Menjelang siang, warga menyudahi ritual mandi laut, pulang ke rumah untuk bilas air tawar.',
        ],
        gambarUrl: _fotoDusDusan,
      ),
    ],
    kuisList: [
      QuizQuestionModel(
        id: '01',
        judulPertanyaan: 'Daerah tradisi',
        pertanyaan: 'Di mana lokasi Tradisi Dus-Dusan dilaksanakan?',
        pilihan: [
          'Palang, Kabupaten Tuban',
          'Merakurak, Tuban',
          'Jenu, Tuban',
          'Semanding, Tuban'
        ],
        indeksJawabanBenar: 0,
      ),
      QuizQuestionModel(
        id: '02',
        judulPertanyaan: 'Waktu Dus-Dusan',
        pertanyaan: 'Kapan Tradisi Dus-Dusan biasanya dilaksanakan?',
        pilihan: [
          'Pilihanmu: selalu sama di setiap desa.',
          'Mengikuti agenda setempat',
          'Setiap malam bulan purnama',
          'Saat terjadi gelombang tinggi'
        ],
        indeksJawabanBenar: 1,
      ),
      QuizQuestionModel(
        id: '03',
        judulPertanyaan: 'Makna Dus-Dusan',
        pertanyaan: 'Apa makna utama tradisi Sedekah Laut bagi warga pesisir?',
        pilihan: [
          'Menentukan batas wilayah laut',
          'Ritual tolak bala',
          'Memilih pemimpin desa',
          'Mewajibkan semua warga melaut'
        ],
        indeksJawabanBenar: 1,
      ),
      QuizQuestionModel(
        id: '04',
        judulPertanyaan: 'Rangkaian kedua',
        pertanyaan: 'Apa tahapan kedua dalam gambaran prosesi Dus-Dusan?',
        pilihan: [
          'Selamatan Ketupat',
          'Bergerak ke Pantai',
          'Mandi Laut Massal',
          'Selesai'
        ],
        indeksJawabanBenar: 1,
      ),
      QuizQuestionModel(
        id: '05',
        judulPertanyaan: 'Etika saat berkunjung',
        pertanyaan: 'Sikap etika apa yang harus dijaga wisatawan?',
        pilihan: [
          'Meminta izin sebelum memotret',
          'Mengabaikan aturan warga',
          'Membuang sampah di laut',
          'Merusak peralatan nelayan'
        ],
        indeksJawabanBenar: 0,
      ),
    ],
  );

  final RegionModel _regionKerek = RegionModel(
    nama: 'Kerek',
    deskripsi:
        'Di Kecamatan Kerek, tradisi Tuntunan menjadi bagian dari rangkaian perkawinan di sejumlah desa, termasuk Tengger. Bentuk dan kelengkapannya dapat berbeda sesuai kesepakatan keluarga.',
    gambarUrl: _fotoTuntunan,
    tradisiList: [
      TraditionModel(
        id: 2,
        nama: 'Tuntunan',
        daerah: 'Kerek',
        lokasiLengkap: 'Desa Tengger, Kecamatan Kerek - Tuban',
        kategori: 'Tradisi perkawinan',
        deskripsiSingkat:
            'Tradisi keluarga calon pengantin pria mengantarkan bekal perkawinan kepada keluarga calon pengantin perempuan.',
        waktuPelaksanaan: 'Sekitar 5–7 hari sebelum akad',
        deskripsiWaktu:
            'Liputan warga di Desa Gaji menyebut Tuntunan biasanya dilakukan sekitar lima atau tujuh hari sebelum akad. Waktu pelaksanaan di tiap keluarga dapat berbeda.',
        sejarah:
            'Tuntunan merupakan tradisi perkawinan yang dijalankan di sejumlah desa di Kecamatan Kerek, termasuk Desa Tengger. Tidak ada catatan pasti tentang awal tradisi ini; pengetahuan dan praktiknya diwariskan di lingkungan masyarakat setempat.',
        makna:
            'Bekal yang diantarkan dipahami sebagai bentuk dukungan dan tanggung jawab keluarga untuk membantu calon pengantin memulai kehidupan rumah tangga. Praktik ini bukan mahar maupun syarat agama, dan pelaksanaannya bergantung pada kemampuan serta kesepakatan keluarga.',
        gambaranProses: [
          'Keluarga menyepakati pelaksanaan dan bekal yang akan diantarkan sesuai kemampuan.',
          'Menjelang akad, keluarga calon pengantin pria bersama kerabat mengantarkan bekal ke keluarga calon pengantin perempuan.',
          'Bekal dapat berupa kebutuhan pangan dan perlengkapan rumah tangga. Isi maupun jumlahnya tidak selalu sama pada setiap keluarga.',
        ],
        gambarUrl: _fotoTuntunan,
        sumberLabel: 'Tatkala.co — liputan Tuntunan di Desa Gaji, Kerek',
        sumberUrl:
            'https://tatkala.co/2025/12/03/melihat-tradisi-tuntunan-di-desa-gaji-tuban-simbol-cinta-dan-status-sosial/',
      ),
    ],
    kuisList: [
      QuizQuestionModel(
        id: '01',
        judulPertanyaan: 'Makna Tuntunan',
        pertanyaan:
            'Apa yang dilakukan keluarga calon pengantin pria dalam tradisi Tuntunan?',
        pilihan: [
          'Mengantarkan bekal kepada keluarga calon pengantin perempuan',
          'Mengadakan perlombaan antarwarga',
          'Menentukan tanggal panen bersama',
          'Mengadakan perjalanan ke pantai',
        ],
        indeksJawabanBenar: 0,
      ),
      QuizQuestionModel(
        id: '02',
        judulPertanyaan: 'Waktu pelaksanaan',
        pertanyaan:
            'Menurut liputan pelaksanaan di Desa Gaji, kapan Tuntunan biasanya dilakukan?',
        pilihan: [
          'Sehari setelah akad',
          'Sekitar lima atau tujuh hari sebelum akad',
          'Saat Lebaran Ketupat',
          'Setiap malam bulan purnama',
        ],
        indeksJawabanBenar: 1,
      ),
      QuizQuestionModel(
        id: '03',
        judulPertanyaan: 'Bekal keluarga',
        pertanyaan:
            'Apa contoh bekal yang dapat diantarkan dalam tradisi Tuntunan?',
        pilihan: [
          'Kebutuhan pangan dan perlengkapan rumah tangga',
          'Alat untuk menangkap ikan',
          'Perlengkapan upacara panen',
          'Piala perlombaan desa',
        ],
        indeksJawabanBenar: 0,
      ),
      QuizQuestionModel(
        id: '04',
        judulPertanyaan: 'Kesepakatan keluarga',
        pertanyaan: 'Apa yang menentukan isi dan jumlah bekal dalam Tuntunan?',
        pilihan: [
          'Harus sama untuk semua keluarga',
          'Ditentukan oleh kemampuan dan kesepakatan keluarga',
          'Ditentukan oleh panitia kecamatan',
          'Wajib mengikuti jumlah tertentu',
        ],
        indeksJawabanBenar: 1,
      ),
      QuizQuestionModel(
        id: '05',
        judulPertanyaan: 'Memahami tradisi',
        pertanyaan: 'Manakah pernyataan yang tepat tentang Tuntunan?',
        pilihan: [
          'Tuntunan adalah mahar wajib dalam perkawinan',
          'Tuntunan merupakan syarat agama yang harus dilakukan',
          'Tuntunan adalah tradisi keluarga dan bukan mahar atau syarat agama',
          'Tuntunan selalu memiliki bentuk yang sama di setiap desa',
        ],
        indeksJawabanBenar: 2,
      ),
    ],
  );

  RegionModel get regionPalang => _regionPalang;
  RegionModel get regionKerek => _regionKerek;
  List<RegionModel> get regions => [_regionPalang, _regionKerek];
  List<TraditionModel> get semuaTradisi =>
      regions.expand((region) => region.tradisiList).toList();

  List<TraditionModel> _favoritList = [];
  List<TraditionModel> get favoritList => _favoritList;

  // Mengambil data favorit dari SQLite
  Future<void> loadFavorit() async {
    _favoritList = await DBHelper.instance.getFavorit();
    for (final item in semuaTradisi) {
      item.isFavorite = _favoritList.any((fav) => fav.id == item.id);
    }
    if (!_isDisposed) notifyListeners();
  }

  // Menambah atau menghapus dari SQLite
  Future<void> toggleFavorit(TraditionModel tradisi) async {
    final isExist = _favoritList.any((element) => element.id == tradisi.id);
    if (isExist) {
      await DBHelper.instance.deleteFavorit(tradisi.id);
      tradisi.isFavorite = false;
    } else {
      await DBHelper.instance.insertFavorit(tradisi);
      tradisi.isFavorite = true;
    }
    await loadFavorit();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
