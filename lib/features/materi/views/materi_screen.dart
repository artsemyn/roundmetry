import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roundmetry/core/models/materi_model.dart'; // Pastikan path ini benar

class MateriScreen extends StatelessWidget {
  const MateriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Di aplikasi nyata, Anda akan mengambil data ini dari Supabase.
    // Untuk sekarang kita gunakan data dummy 'semuaBab' dari materi_model.dart.
    // Kita buat daftar Topik Besar dari 'semuaBab'.
    final semuaTopikBesar = [
      TopikBesar(
        id: "topik-tabung",
        judul: "Bangun Ruang – Tabung",
        deskripsi: "Pelajari semua tentang definisi, jaring-jaring, hingga volume tabung.",
        daftarBab: semuaBab.where((bab) => bab.id.contains("tabung")).toList(),
      ),
      // Anda bisa menambahkan TopikBesar untuk Kerucut dan Bola di sini
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Semua Materi'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: semuaTopikBesar.length,
        itemBuilder: (context, index) {
          final topik = semuaTopikBesar[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // Jika topik memiliki bab, navigasi ke langkah pertama (indeks 0) dari bab pertama.
                if (topik.daftarBab.isNotEmpty) {
                  context.go('/belajar/${topik.daftarBab.first.id}/0');
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topik.judul, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(topik.deskripsi, style: TextStyle(color: Colors.grey.shade700)),
                    const SizedBox(height: 8),
                    Text('${topik.daftarBab.length} Bab', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}