// Definisikan kelas-kelas model
class TopikBesar {
  final String id;
  final String judul;
  final String deskripsi;
  final List<BabMateri> daftarBab;

  TopikBesar({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.daftarBab,
  });
}

class BabMateri {
  final String id;
  final String judulBab;
  final List<Konten> konten;

  BabMateri({required this.id, required this.judulBab, required this.konten});
}

class Konten {
  final String tipe; // 'judul', 'paragraf', 'latihan'
  final String data;
  // TAMBAHKAN KOLOM BARU INI
  final String?
  modelCommand; // Akan berisi nama node yang ingin ditampilkan, cth: "RadiusLine"

  Konten({
    required this.tipe,
    required this.data,
    this.modelCommand, // Jadikan opsional
  });
}

// --- DATA DUMMY BARU --- //
final semuaTopik = [
  TopikBesar(
    id: "topik-tabung",
    judul: "Bangun Ruang – Tabung",
    deskripsi:
        "Pelajari semua tentang definisi, jaring-jaring, hingga volume tabung.",
    daftarBab: [
      BabMateri(
        id: "bab-tabung-1",
        judulBab: "Bab 1: Definisi dan Unsur Tabung",
        konten: [
          Konten(tipe: 'judul', data: 'Definisi Tabung'),
          Konten(
            tipe: 'paragraf',
            data: 'Tabung merupakan sebuah bangun ruang sisi lengkung...',
          ),
          Konten(
            tipe: 'latihan',
            data: 'Jelaskan pengertian tabung menurut pemahamanmu...',
          ),
        ],
      ),
      BabMateri(
        id: "bab-tabung-2",
        judulBab: "Bab 2: Jaring-Jaring, Luas & Volume",
        konten: [
          Konten(tipe: 'judul', data: 'Jaring-Jaring Tabung'),
          Konten(
            tipe: 'paragraf',
            data: 'Jaring−jaring tabung terdiri dari...',
          ),
        ],
      ),
    ],
  ),
  TopikBesar(
    id: "topik-kerucut",
    judul: "Bangun Ruang – Kerucut",
    deskripsi:
        "Dari tumpeng hingga topi ulang tahun, mari kita bedah bangun kerucut.",
    daftarBab: [
      // (Nanti bisa ditambahkan bab untuk kerucut)
    ],
  ),
];
