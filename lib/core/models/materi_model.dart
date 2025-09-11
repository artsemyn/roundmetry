// Definisikan tipe untuk setiap langkah pembelajaran
enum TipeLangkah {
  TEORI, // Untuk judul dan paragraf
  LATIHAN, // Untuk soal latihan
  HASIL, // Untuk halaman hasil/report
}

// Model untuk setiap langkah dalam sebuah bab
class LangkahPembelajaran {
  final String id;
  final String judul;
  final String? teksKonten; // Teks penjelasan
  final String model3D; // Nama file model 3D yang relevan
  final String? modelCommand; // Perintah untuk model (jika ada)
  final TipeLangkah tipe;

  LangkahPembelajaran({
    required this.id,
    required this.judul,
    this.teksKonten,
    required this.model3D,
    this.modelCommand,
    this.tipe = TipeLangkah.TEORI,
  });
}

// Model konten mentah dari tabel `konten` (hasil join Supabase)
class Konten {
  final String tipe; // contoh: 'judul', 'paragraf', 'latihan'
  final String data; // isi teks atau payload lain
  final String? modelCommand; // perintah untuk model 3D jika ada
  final int urutan; // posisi dalam satu bab

  Konten({
    required this.tipe,
    required this.data,
    this.modelCommand,
    this.urutan = 0,
  });
}

// Model untuk sebuah bab yang berisi banyak langkah
class Bab {
  final String id;
  final String judulBab;
  final List<LangkahPembelajaran> langkah;

  Bab({required this.id, required this.judulBab, required this.langkah});
}

// Model untuk Topik Besar yang mengelompokkan beberapa Bab
class TopikBesar {
  final String id;
  final String judul;
  final String deskripsi;
  final List<Bab> daftarBab;

  const TopikBesar({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.daftarBab,
  });
}

// --- DATA DUMMY BARU DENGAN STRUKTUR STEP-BY-STEP ---
final semuaBab = [
  Bab(
    id: "bab-tabung-1",
    judulBab: "Mengenal Unsur Tabung",
    langkah: [
      LangkahPembelajaran(
        id: "tabung-1-1",
        judul: "Apa itu Tabung?",
        teksKonten: "Tabung merupakan sebuah bangun ruang sisi lengkung yang dibentuk oleh dua lingkaran yang identik dan sejajar, serta sebuah persegi panjang yang mengelilingi kedua lingkaran tersebut.",
        model3D: "cylinder_plain.glb", // Model tabung polos
      ),
      LangkahPembelajaran(
        id: "tabung-1-2",
        judul: "Unsur: Jari-Jari (r)",
        teksKonten: "Jari-jari adalah jarak dari titik pusat lingkaran ke tepi lingkaran. Garis merah pada model menunjukkan jari-jari.",
        model3D: "interactive_cylinder.glb",
        modelCommand: "RadiusLine",
      ),
      LangkahPembelajaran(
        id: "tabung-1-3",
        judul: "Unsur: Tinggi (t)",
        teksKonten: "Tinggi tabung adalah jarak antara kedua lingkaran alas dan tutup. Garis biru pada model menunjukkan tinggi.",
        model3D: "interactive_cylinder.glb",
        modelCommand: "HeightLine",
      ),
      LangkahPembelajaran(
        id: "tabung-1-4",
        judul: "Latihan: Unsur Tabung",
        tipe: TipeLangkah.LATIHAN,
        teksKonten: "Sebutkan 2 unsur tabung yang telah kamu pelajari!",
        model3D: "cylinder_plain.glb",
      ),
      LangkahPembelajaran(
        id: "tabung-1-hasil",
        judul: "Laporan Bab 1",
        tipe: TipeLangkah.HASIL,
        teksKonten: "Kerja bagus! Anda telah menyelesaikan bab tentang unsur-unsur tabung.",
        model3D: "cylinder_plain.glb",
      ),
    ],
  )
];