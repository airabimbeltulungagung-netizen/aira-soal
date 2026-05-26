import 'package:flutter/material.dart';
import 'package:tex_text/tex_text.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, String> data;

  const ResultScreen({super.key, required this.data});

  Widget _buildFormattedText(String text) {
    if (text.isEmpty) {
      return const Text("Data kosong", style: TextStyle(color: Colors.white));
    }

    // Kita bersihkan teks terlebih dahulu
    final cleanText = text.trim();

    // Widget TexText tidak punya parameter 'onError',
    // jadi kita langsung pasang widget-nya.
    // TexText sudah didesain cukup tangguh untuk merender LaTeX standar.
    return TexText(
      cleanText,
      style: const TextStyle(color: Colors.white, fontSize: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0A1F),
      appBar: AppBar(
        title: const Text("Hasil Soal"),
        backgroundColor: const Color(0xFF1A1530),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Soal:", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            _buildFormattedText(data['soal'] ?? ""),

            const SizedBox(height: 30),
            const Divider(color: Colors.white24),
            const SizedBox(height: 20),

            const Text("Pembahasan:", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            _buildFormattedText(data['kunci'] ?? ""),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
