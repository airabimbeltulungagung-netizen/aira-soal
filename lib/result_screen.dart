import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, String> data;
  final bool showKey;

  const ResultScreen({super.key, required this.data, this.showKey = true});

  Widget _buildFormattedText(String text) {
    return TeXView(
      child: TeXViewDocument(
        text.replaceAll(r'$', r'$$'),
        // Menggunakan constructor kosong untuk menghindari error 'undefined'
        style: const TeXViewStyle(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- MASTER SYNC LOGIC ---
    final String soal = data['soal'] ?? 'Data soal tidak ditemukan.';
    final String kunci =
        data['kunci'] ?? 'Kunci atau pembahasan tidak tersedia.';
    // -------------------------

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Hasil Generate Soal"),
          backgroundColor: const Color(0xFF1A1530),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Soal"),
              Tab(text: "Kunci & Pembahasan"),
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
