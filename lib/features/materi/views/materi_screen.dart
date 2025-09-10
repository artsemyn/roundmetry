import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roundmetry/core/models/materi_model.dart';
import 'package:roundmetry/core/services/materi_service.dart';

class MateriScreen extends StatelessWidget {
  const MateriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final materiService = MateriService();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Semua Materi'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: FutureBuilder<List<TopikBesar>>(
        future: materiService.fetchSemuaTopik(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada materi.'));
          }

          final semuaTopik = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: semuaTopik.length,
            itemBuilder: (context, index) {
              final topik = semuaTopik[index];
              // --- UI KARTU YANG HILANG DITAMBAHKAN DI SINI ---
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    if (topik.daftarBab.isNotEmpty) {
                      context.go('/materi/${topik.daftarBab.first.id}');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(topik.judul, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(topik.deskripsi ?? '', style: TextStyle(color: Colors.grey.shade700)),
                        const SizedBox(height: 8),
                        Text('${topik.daftarBab.length} Bab', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              );
              // --- AKHIR DARI UI KARTU ---
            },
          );
        },
      ),
    );
  }
}