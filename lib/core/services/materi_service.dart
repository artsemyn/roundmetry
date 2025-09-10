import 'package:roundmetry/core/models/materi_model.dart';
import 'package:roundmetry/main.dart';

class MateriService {
  Future<List<TopikBesar>> fetchSemuaTopik() async {
    final response = await supabase.from('topik').select('*, bab(id, judul_bab)');

    final List<TopikBesar> daftarTopik = [];
    for (var topikData in response) {
      final List<BabMateri> daftarBab = (topikData['bab'] as List)
          .map((babData) => BabMateri(
                id: babData['id'].toString(),
                judulBab: babData['judul_bab'],
                konten: [],
              ))
          .toList();

      daftarTopik.add(TopikBesar(
        id: topikData['id'].toString(),
        judul: topikData['judul'],
        deskripsi: topikData['deskripsi'] ?? '', // <-- Perbaikan di sini
        daftarBab: daftarBab,
      ));
    }
    return daftarTopik;
  }

  Future<Map<String, dynamic>> fetchBabDetail(String babId) async {
    final response = await supabase
        .from('bab')
        .select('*, konten(*, id, tipe, data), topik(*)') // urutkan konten berdasarkan kolom 'urutan'
        .eq('id', int.parse(babId))
        .single();

    final List<Konten> daftarKonten = (response['konten'] as List)
        .map((kontenData) => Konten(
              tipe: kontenData['tipe'],
              data: kontenData['data'],
            ))
        .toList();

    final babSaatIni = BabMateri(
      id: response['id'].toString(),
      judulBab: response['judul_bab'],
      konten: daftarKonten,
    );

    final topikInduk = TopikBesar(
      id: response['topik']['id'].toString(),
      judul: response['topik']['judul'],
      deskripsi: response['topik']['deskripsi'] ?? '', // <-- Perbaikan di sini
      daftarBab: await fetchDaftarBabDariTopik(response['topik']['id']),
    );
    
    return {'bab': babSaatIni, 'topik': topikInduk};
  }

  Future<List<BabMateri>> fetchDaftarBabDariTopik(int topikId) async {
     final response = await supabase.from('bab').select('id, judul_bab').eq('topik_id', topikId);
     return response.map((babData) => BabMateri(
        id: babData['id'].toString(),
        judulBab: babData['judul_bab'],
        konten: [],
     )).toList();
  }
}