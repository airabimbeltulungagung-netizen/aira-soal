import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  // SEGERA GANTI API KEY ANDA DI GOOGLE AI STUDIO SETELAH INI
  static const String _apiKey = 'AIzaSyCdO1J8aiG0hIo-fvWlHu86iEujrrlwYwc';

  // Menggunakan 'gemini-pro' atau 'gemini-1.5-flash'
  static final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey,
  );

  static Future<Map<String, String>> generateSoal({
    required String topik,
    required String kelas,
    required String mapel,
    required String model,
    required String jumlah,
  }) async {
    // String prompt menggunakan \ agar simbol $ tidak dibaca sebagai variabel oleh Dart
    final prompt =
        '''
    Buatkan $jumlah soal model $model untuk mata pelajaran $mapel, kelas $kelas, dengan topik $topik.
    Berikan kunci jawaban dan pembahasannya di bagian terpisah.
    
    ATURAN FORMAT WAJIB:
    1. Jika soal membutuhkan rumus matematika/sains, WAJIB gunakan LaTeX dan bungkus dengan tanda dollar (\$...\$). Contoh: \$E=mc^2\$.
    2. Jika soal adalah mapel non-matematika (Bahasa, Sejarah, dll), tulis secara natural tanpa tanda dollar agar rapi.
    3. Format output harus tepat seperti ini:
    
    SOAL:
    (Daftar soal di sini)
    
    KUNCI:
    (Daftar kunci dan pembahasan di sini)
    ''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      String text = response.text ?? "";

      // Memecah hasil berdasarkan keyword KUNCI:
      List<String> parts = text.split("KUNCI:");

      return {
        'soal': parts[0].replaceAll("SOAL:", "").trim(),
        'kunci': parts.length > 1
            ? parts[1].trim()
            : "Kunci jawaban tidak ditemukan.",
      };
    } catch (e) {
      return {
        'soal': 'Error saat generate: $e',
        'kunci': 'Gagal mengambil data dari AI.',
      };
    }
  }
}
