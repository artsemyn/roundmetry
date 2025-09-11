import 'package:roundmetry/core/models/materi_model.dart';
import 'package:roundmetry/main.dart'; // Untuk akses supabase client

class MateriService {
  // Mengambil semua bab beserta kontennya dari Supabase
  // Ini lebih efisien karena hanya butuh satu kali panggilan data saat aplikasi dimulai.
  Future<List<Bab>> fetchSemuaBabDanKonten() async {
    // Ambil data bab, lalu joinkan dengan data konten dan data topik induknya
    final response = await supabase
        .from('bab')
        .select('*, topik(*), konten(*)')
        .order('urutan', ascending: true); // Urutkan bab berdasarkan kolom 'urutan'

    // Proses dan ubah data JSON dari Supabase menjadi List<Bab>
    return response.map((babData) {
      // Ubah list konten dari JSON menjadi List<Konten>
      final rawKonten = (babData['konten'] as List?) ?? const [];
      final List<Konten> daftarKonten = rawKonten
          .map((kontenData) => Konten(
                tipe: kontenData['tipe']?.toString() ?? '',
                data: kontenData['data']?.toString() ?? '',
                modelCommand: kontenData['model_command']?.toString(),
                urutan: int.tryParse(kontenData['urutan']?.toString() ?? '0') ?? 0,
              ))
          .toList();

      // Urutkan konten di dalam bab berdasarkan kolom 'urutan'
      daftarKonten.sort((a, b) => a.urutan.compareTo(b.urutan));

      // Buat objek Bab
      return Bab(
        id: babData['id'].toString(),
        judulBab: babData['judul_bab'],
        langkah: daftarKonten.map((konten) {
          // Setiap konten sekarang dianggap sebagai satu "LangkahPembelajaran"
          return LangkahPembelajaran(
            id: 'langkah-${konten.tipe}-${daftarKonten.indexOf(konten)}',
            judul: konten.tipe == 'judul' ? konten.data : babData['judul_bab'],
            teksKonten: konten.tipe == 'paragraf' ? konten.data : (konten.tipe == 'latihan' ? konten.data : null),
            // Asumsi nama model 3D berdasarkan perintah, jika tidak ada, gunakan model polos
            model3D: _getModelNameFromCommand(konten.modelCommand),
            modelCommand: konten.modelCommand,
            tipe: konten.tipe == 'latihan' ? TipeLangkah.LATIHAN : TipeLangkah.TEORI,
          );
        }).toList(),
      );
    }).toList();
  }

  // Fungsi helper sederhana untuk menentukan file model 3D mana yang akan ditampilkan
  String _getModelNameFromCommand(String? command) {
    switch (command) {
      case 'RadiusLine':
        return 'cylinder_radius.glb';
      case 'HeightLine':
        return 'cylinder_height.glb';
      case 'DiameterLine':
        return 'cylinder_diameter.glb';
      default:
        return 'cylinder_plain.glb';
    }
  }
}