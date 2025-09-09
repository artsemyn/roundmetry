import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

class MaterialViewerScreen extends StatefulWidget {
  const MaterialViewerScreen({super.key});

  @override
  State<MaterialViewerScreen> createState() => _MaterialViewerScreenState();
}

class _MaterialViewerScreenState extends State<MaterialViewerScreen> {
  bool _isDownloading = false;
  // Ganti dengan URL publik file .glb Anda di Supabase Storage
  final String modelUrl = 'https://ekvxagheytrvjbsagjbi.supabase.co/storage/v1/object/sign/models/cylinder.glb?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV8xODEyYmMzNy00Y2ZjLTQ1NjQtYmNhOC0wYTdjMjNiYTM1NjIiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJtb2RlbHMvY3lsaW5kZXIuZ2xiIiwiaWF0IjoxNzU3Mzg1NTUzLCJleHAiOjE3ODg5MjE1NTN9.qzcON1xGKl5EUsHuEWNrTWGFkDagGuYSLvGsBrhSIbk';
  final String modelFileName = 'cylinder.glb';

  Future<void> _downloadModel() async {
    setState(() => _isDownloading = true);

    try {
      // 1. Unduh data file dari URL
      final response = await http.get(Uri.parse(modelUrl));
      if (response.statusCode == 200) {
        final Uint8List fileBytes = response.bodyBytes;
        
        // 2. Buat URL objek di browser
        final blob = html.Blob([fileBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        
        // 3. Buat anchor tag (<a>) untuk memicu unduhan
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = modelFileName; // Nama file saat diunduh

        // 4. Tambahkan ke body, klik, lalu hapus
        html.document.body!.children.add(anchor);
        anchor.click();
        html.document.body!.children.remove(anchor);
        html.Url.revokeObjectUrl(url);

      } else {
        throw Exception('Gagal mengunduh file');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }

    setState(() => _isDownloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Viewer Model 3D"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ModelViewer(
              src: modelUrl,
              alt: "Model 3D Interaktif",
              cameraControls: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text("Unduh Model GLB"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _isDownloading ? null : _downloadModel,
            ),
          )
        ],
      ),
    );
  }
}