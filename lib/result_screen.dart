import 'package:flutter/material.dart';
import 'package:tex_text/tex_text.dart';

class ResultScreen extends StatelessWidget {
  // Jika data berupa String (bukan Map), kita tetap bisa menanganinya
  final dynamic data;

  const ResultScreen({super.key, required this.data});

  // Fungsi untuk mendapatkan teks dari data, baik itu Map atau String
  String _getSoal() {
    if (data is Map) return data['soal'] ?? "Soal tidak tersedia.";
    return data.toString();
  }

  String _getKunci() {
    if (data is Map) return data['kunci'] ?? "Pembahasan tidak tersedia.";
    return "Pembahasan tidak tersedia.";
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white10),
          ),
          child: Builder(
            builder: (context) {
              try {
                return TexText(
                  content.isEmpty ? "Tidak ada konten." : content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                );
              } catch (e) {
                // Fallback jika LaTeX gagal dirender
                return Text(
                  content,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0A1F),
      appBar: AppBar(
        title: const Text("Hasil Generate"),
        backgroundColor: const Color(0xFF1A1530),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSection("SOAL:", _getSoal()),
            const SizedBox(height: 25),
            _buildSection("PEMBAHASAN:", _getKunci()),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("KEMBALI KE BERANDA"),
            ),
          ],
        ),
      ),
    );
  }
}
