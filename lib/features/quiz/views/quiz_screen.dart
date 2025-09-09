import 'package:flutter/material.dart';
import 'package:roundmetry/main.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _answerController = TextEditingController();
  bool _isLoading = false;
  String? _feedback;


Future<void> _submitAnswer() async {
  setState(() {
    _isLoading = true;
    _feedback = null;
  });

  try {
    final response = await supabase.functions.invoke(
      'ai-evaluator',
      body: {'studentAnswer': _answerController.text},
    );

    // --- PERBAIKAN DIMULAI DI SINI ---
    // Logika parsing yang lebih aman
    final feedbackData = response.data as Map<String, dynamic>?;

    if (feedbackData != null) {
      // Gunakan default value '??' jika data tidak ada untuk menghindari null error
      final feedbackText = feedbackData['umpan_balik'] as String? ?? "AI tidak memberikan umpan balik berupa teks.";
      
      // Cek 'skor' dan berikan default list jika tidak ada
      final skorList = feedbackData['skor'] as List<dynamic>?;
      final skorArray = skorList?.cast<int>() ?? [0, 0, 0];
      
      final formattedFeedback =
          'Skor (Rumus, Substitusi, Perhitungan): $skorArray\n\n$feedbackText';

      setState(() {
        _feedback = formattedFeedback;
      });
    } else {
      throw Exception("Respons dari AI kosong atau tidak valid.");
    }
    // --- AKHIR DARI PERBAIKAN ---

  } catch (e) {
    setState(() {
      _feedback = "Terjadi error saat menghubungi AI: ${e.toString()}";
    });
  }

  setState(() {
    _isLoading = false;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuis Interaktif'),
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kartu Soal
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Soal: Volume Tabung',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sebuah kaleng susu berbentuk tabung memiliki jari-jari alas 7 cm dan tinggi 10 cm. Hitunglah volume kaleng tersebut! Tuliskan langkah-langkah pengerjaanmu.',
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Gunakan nilai π = 22/7',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Kolom Jawaban
                const Text(
                  'Jawaban Anda:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _answerController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    hintText:
                        'Tuliskan rumus dan langkah pengerjaanmu di sini...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitAnswer,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 48),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Kirim Jawaban'),
                ),
                const SizedBox(height: 24),

                // Area Umpan Balik AI
                if (_feedback != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Feedback AI:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(_feedback!),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
