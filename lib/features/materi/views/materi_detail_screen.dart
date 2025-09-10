import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:roundmetry/core/models/materi_model.dart';
import 'package:roundmetry/core/services/materi_service.dart';
import 'package:roundmetry/main.dart';
import 'package:universal_html/js.dart' as js;
import 'package:visibility_detector/visibility_detector.dart';

// Mendefinisikan jembatan ke fungsi JavaScript di level window
@JS('window')
@staticInterop
class _Window {}

extension _WindowExtension on _Window {
  // Deklarasi fungsi 'toggleVariant' yang ada di JavaScript
  @JS('toggleVariant')
  external void toggleVariant(JSString name);
}

class MateriDetailScreen extends StatefulWidget {
  final String babId;
  const MateriDetailScreen({super.key, required this.babId});

  @override
  State<MateriDetailScreen> createState() => _MateriDetailScreenState();
}

class _MateriDetailScreenState extends State<MateriDetailScreen> {
  final MateriService _materiService = MateriService();
  late Future<Map<String, dynamic>> _materiFuture;
  String _currentNodeName = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant MateriDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.babId != oldWidget.babId) {
      _loadData();
    }
  }

  void _loadData() {
    _materiFuture = _materiService.fetchBabDetail(widget.babId);
  }

  // Fungsi untuk memanggil JavaScript dari Dart
  void _setModelVariant(String nodeName) {
    if (_currentNodeName == nodeName) return;

    try {
      // Method 1: Using js_interop (preferred)
      if (js.context.hasProperty('toggleVariant')) {
        final window = js.context as _Window;
        window.toggleVariant(nodeName.toJS);
      }
      // Method 2: Fallback using universal_html
      else if (js.context['toggleVariant'] != null) {
        js.context.callMethod('toggleVariant', [nodeName]);
      }
      else {
        print('toggleVariant function not found in JavaScript context');
      }
      
      _currentNodeName = nodeName;
    } catch (e) {
      print('Error calling toggleVariant: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _materiFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Materi tidak ditemukan."));
          }

          final babSaatIni = snapshot.data!['bab'] as BabMateri;
          final topikInduk = snapshot.data!['topik'] as TopikBesar;

          return Scaffold(
            appBar: AppBar(title: Text(topikInduk.judul)),
            body: Row(
              children: [
                LeftPanelWithModel(
                  topik: topikInduk,
                  selectedBabId: babSaatIni.id,
                  onBabSelected: (String newBabId) {
                    setState(() {
                      _materiFuture = _materiService.fetchBabDetail(newBabId);
                    });
                  },
                ),
                const VerticalDivider(width: 1),
                _buildRightPanel(babSaatIni),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRightPanel(BabMateri bab) {
    return Expanded(
      child: Container(
        color: const Color(0xFFF8F9FA),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0),
          itemCount: bab.konten.length,
          itemBuilder: (context, index) {
            final konten = bab.konten[index];
            return VisibilityDetector(
              key: Key('${bab.id}-$index'),
              onVisibilityChanged: (visibilityInfo) {
                if (visibilityInfo.visibleFraction > 0.5) {
                  _setModelVariant(konten.modelCommand ?? "reset");
                }
              },
              child: _buildKontenItem(konten),
            );
          },
        ),
      ),
    );
  }

  Widget _buildKontenItem(Konten konten) {
    switch (konten.tipe) {
      case 'judul':
        return Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
          child:
              Text(konten.data, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        );
      case 'paragraf':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(konten.data, style: const TextStyle(fontSize: 16, height: 1.6)),
        );
      case 'latihan':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          color: Colors.blue.shade50,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue.shade100),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("📝 Soal Latihan",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 8),
                Text(konten.data),
              ],
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class LeftPanelWithModel extends StatefulWidget {
  final TopikBesar topik;
  final String selectedBabId;
  final Function(String) onBabSelected;

  const LeftPanelWithModel({
    super.key,
    required this.topik,
    required this.selectedBabId,
    required this.onBabSelected,
  });

  @override
  State<LeftPanelWithModel> createState() => _LeftPanelWithModelState();
}

class _LeftPanelWithModelState extends State<LeftPanelWithModel> {
  Future<Uint8List>? _modelFuture;
  final String _modelViewerId = 'interactive-model-viewer'; // ID unik untuk model viewer

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  void _loadModel() {
    const modelFileName = 'interactive_cylinder.glb';
    _modelFuture = supabase.storage.from('models').download(modelFileName);
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = widget.topik.daftarBab.indexWhere((b) => b.id == widget.selectedBabId);

    final String jsScript = """
      // Wait for model viewer to be ready
      function initializeModelViewer() {
        const modelViewer = document.getElementById('$_modelViewerId');
        if (!modelViewer) {
          console.log('Model viewer not found, retrying...');
          setTimeout(initializeModelViewer, 100);
          return;
        }
        
        const variantNames = ['RadiusLine', 'HeightLine', 'DiameterLine'];
        
        function hideAll() {
          if (!modelViewer.model) return;
          variantNames.forEach(name => {
            const material = modelViewer.model.materials.find(m => m.name === name);
            if (material && material.pbrMetallicRoughness) {
              material.pbrMetallicRoughness.setBaseColorFactor([1, 1, 1, 0]);
            }
          });
        }

        // Jadikan fungsi ini global agar bisa diakses dari Dart
        window.toggleVariant = function(name) {
          console.log('toggleVariant called with:', name);
          try {
            hideAll();
            if (name === 'reset' || !variantNames.includes(name)) return;
            
            if (!modelViewer.model) {
              console.log('Model not loaded yet');
              return;
            }
            
            const material = modelViewer.model.materials.find(m => m.name === name);
            if (material && material.pbrMetallicRoughness) {
              let color = [1, 1, 1, 1];
              if (name === 'RadiusLine') color = [1, 0, 0, 1];
              if (name === 'HeightLine') color = [0, 0, 1, 1];
              if (name === 'DiameterLine') color = [0, 1, 0, 1];
              material.pbrMetallicRoughness.setBaseColorFactor(color);
            } else {
              console.log('Material not found:', name);
            }
          } catch (error) {
            console.error('Error in toggleVariant:', error);
          }
        }

        modelViewer.addEventListener('load', () => {
          console.log('Model loaded');
          hideAll();
        });
        
        // Also listen for model-visibility event in case load event is missed
        modelViewer.addEventListener('model-visibility', () => {
          console.log('Model visibility changed');
          hideAll();
        });
        
        console.log('Model viewer initialized');
      }
      
      // Start initialization
      if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeModelViewer);
      } else {
        initializeModelViewer();
      }
    """;

    return Container(
      width: 350,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 250,
            color: Colors.grey[200],
            child: FutureBuilder<Uint8List>(
              future: _modelFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text('Gagal memuat model 3D'));
                }
                final dataUri = 'data:model/gltf-binary;base64,${base64Encode(snapshot.data!)}';      
                return ModelViewer(
                    id: _modelViewerId,
                    src: dataUri,
                    cameraControls: true,
                    relatedJs: jsScript,
                  );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: widget.topik.daftarBab.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final bab = widget.topik.daftarBab[index];
                final isSelected = index == selectedIndex;
                return ListTile(
                  title: Text(bab.judulBab, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  selected: isSelected,
                  selectedTileColor: Colors.green.shade50,
                  onTap: () => widget.onBabSelected(bab.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}