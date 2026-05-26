import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, String> data;
  final bool showKey;

  const ResultScreen({super.key, required this.data, this.showKey = true});

  Widget _buildFormattedText(String text) {
    // FIX: Pastikan text tidak kosong sebelum diproses
    if (text.isEmpty) {
      return const Center(
        child: Text(
          "Data tidak tersedia",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return TeXView(
      child: TeXViewDocument(
        text.replaceAll(r'$', r'$$'), // Konversi ke blok matematika
        style: const TeXViewStyle(
          textAlign: TeXViewTextAlign.left,
          fontStyle: TeXViewFontStyle(fontSize: 16, fontFamily: 'Roboto'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String soal = data['soal'] ?? 'Data soal tidak ditemukan.';
    final String kunci =
        data['kunci'] ?? 'Kunci atau pembahasan tidak tersedia.';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0A1F), // Konsisten tema mewah
        appBar: AppBar(
          title: const Text("Hasil Generate Soal"),
          backgroundColor: const Color(0xFF1A1530),
          bottom: const TabBar(
            indicatorColor: Color(0xFFFFD700),
            tabs: [
              Tab(icon: Icon(Icons.quiz), text: "Soal"),
              Tab(icon: Icon(Icons.key), text: "Kunci"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildFormattedText(soal),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildFormattedText(
                showKey ? kunci : 'Kunci disembunyikan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
