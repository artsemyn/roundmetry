import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:roundmetry/core/models/materi_model.dart';
import 'package:roundmetry/main.dart';
import 'dart:convert';

class HalamanBelajarScreen extends StatefulWidget {
  final String babId;
  final int initialLangkahIndex;

  const HalamanBelajarScreen({
    super.key,
    required this.babId,
    this.initialLangkahIndex = 0,
  });

  @override
  State<HalamanBelajarScreen> createState() => _HalamanBelajarScreenState();
}

class _HalamanBelajarScreenState extends State<HalamanBelajarScreen> {
  late Bab bab;
  late int langkahSaatIniIndex;

  @override
  void initState() {
    super.initState();
    // Cari bab yang sesuai dari data dummy
    bab = semuaBab.firstWhere((b) => b.id == widget.babId);
    langkahSaatIniIndex = widget.initialLangkahIndex;
  }

  void _goToLangkah(int index) {
    if (index >= 0 && index < bab.langkah.length) {
      // Gunakan GoRouter untuk navigasi internal tanpa reload halaman penuh
      context.go('/belajar/${widget.babId}/$index');
      setState(() {
        langkahSaatIniIndex = index;
      });
    } else if (index >= bab.langkah.length) {
      // Jika sudah di langkah terakhir, kembali ke daftar materi
      context.go('/materi-list');
    }
  }

  @override
  Widget build(BuildContext context) {
    final langkah = bab.langkah[langkahSaatIniIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(bab.judulBab),
        // Progres bar sederhana
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (langkahSaatIniIndex + 1) / bab.langkah.length,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Area Model 3D
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Model3DViewer(modelFileName: langkah.model3D),
              ),
            ),
            const SizedBox(height: 24),

            // Area Konten
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    langkah.judul,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    langkah.teksKonten ?? '',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                ],
              ),
            ),
            
            // Tombol Navigasi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (langkahSaatIniIndex > 0)
                  OutlinedButton(
                    onPressed: () => _goToLangkah(langkahSaatIniIndex - 1),
                    child: const Text("Kembali"),
                  ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _goToLangkah(langkahSaatIniIndex + 1),
                  child: Text(langkahSaatIniIndex == bab.langkah.length - 1 ? "Selesai" : "Berikutnya"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget terpisah untuk memuat model 3D agar lebih rapi
class Model3DViewer extends StatelessWidget {
  final String modelFileName;
  const Model3DViewer({super.key, required this.modelFileName});

  @override
  Widget build(BuildContext context) {
    // Fungsi untuk mengunduh model dari Supabase
    Future<Uint8List> loadModel() {
      return supabase.storage.from('models').download(modelFileName);
    }

    return FutureBuilder<Uint8List>(
      future: loadModel(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Icon(Icons.error, color: Colors.red));
        }
        
        final dataUri = 'data:model/gltf-binary;base64,${base64Encode(snapshot.data!)}';
        
        return ModelViewer(
          src: dataUri,
          cameraControls: true,
          autoRotate: true,
        );
      },
    );
  }
}