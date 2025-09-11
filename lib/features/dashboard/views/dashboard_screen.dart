import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roundmetry/core/models/materi_model.dart'; // Pastikan path ini benar

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil semua bab dari data dummy untuk ditampilkan di beranda
    final semuaBabUntukBeranda = semuaBab;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Beranda', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text('Lanjutkan Belajar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // Tampilkan setiap bab sebagai kartu
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: semuaBabUntukBeranda.length,
            itemBuilder: (context, index) {
              final bab = semuaBabUntukBeranda[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  leading: const Icon(Icons.book_online, color: Colors.green, size: 32),
                  title: Text(
                    bab.judulBab,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle: Text('${bab.langkah.length} langkah pembelajaran'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigasi ke bab yang dipilih, mulai dari langkah pertama (indeks 0)
                    context.go('/belajar/${bab.id}/0');
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}