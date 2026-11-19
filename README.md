# Ronce Tuban

Aplikasi Flutter untuk menjelajahi cerita budaya dan tradisi di Tuban.

## Lokasi tradisi

Setiap halaman detail tradisi menyediakan tombol **Lihat lokasi di Maps** yang mencari alamat daerah tradisi. Hasil peta menunjukkan area desa, bukan selalu titik acara yang persis; lokasi pelaksanaan dapat berubah atau berbeda di setiap keluarga.

## Kuis daerah

Kuis daerah tersedia untuk Palang (Dus-Dusan) dan Kerek (Tuntunan). Kuis Tuntunan menyampaikan informasi dengan konteks bahwa waktu dan praktik yang dirujuk dilaporkan dari Desa Gaji, dan dapat bervariasi di Desa Tengger maupun keluarga lainnya.

## Akun lokal

Aplikasi menyediakan pendaftaran, login, pemulihan sesi lokal, dan logout menggunakan penyimpanan SQLite di perangkat. Kata sandi disimpan sebagai hash PBKDF2-HMAC-SHA256 dengan salt acak, bukan teks biasa. Akun tidak disinkronkan atau dapat dipulihkan melalui server; menghapus data aplikasi dapat menghapus akun dan sesi.

## Kredit foto

Foto tradisi Dus-Dusan pada kartu beranda, halaman daerah, dan pengantar kuis:

- Sumber: [iNews](https://img.inews.co.id/media/600/files/networks/2024/04/18/8fe8a_vian.jpeg)
- Penggunaan foto ini di aplikasi berdasarkan konfirmasi pengguna bahwa mereka memiliki hak atau izin yang diperlukan.

Foto tradisi Tuntunan di Kerek pada kartu daerah dan halaman detail:

- Sumber: [tautan gambar yang diberikan pengguna](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTt2V37I8Rkn1ozerWKc-e7zK52a5PTE28-sejGTDc9HuZ8iU-ze7_4lW8T&s=10)

## Referensi Tradisi Tuntunan

Ringkasan Tuntunan di Kecamatan Kerek merujuk pada [liputan Tatkala.co tentang pelaksanaan di Desa Gaji](https://tatkala.co/2025/12/03/melihat-tradisi-tuntunan-di-desa-gaji-tuban-simbol-cinta-dan-status-sosial/). Liputan tersebut menyebut Tengger sebagai salah satu desa lain di Kecamatan Kerek yang menjalankan tradisi ini. Rincian waktu dan contoh bekal pada aplikasi berasal dari pelaksanaan di Desa Gaji, sehingga praktik di Tengger dapat memiliki variasi setempat.
