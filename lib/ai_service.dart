import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  // Masukkan API Key Anda di sini atau gunakan dotenv
  static const String _apiKey = 'AIzaSyABTD5CSVOOYGiroxov2NBJNkmu-wNAzrw';

  static Future<Map<String, String>> generateSoal({
    required String topik,
    required String kelas,
    required String mapel,
    required String model,
    required String jumlah,
  }) async {
    try {
      // 1. Gunakan model yang teruji.
      // Penting: Jangan gunakan prefix 'models/' di sini.
      final modelAI = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey,
      );

      final prompt =
          '''
      Buatkan $jumlah soal untuk mapel $mapel, kelas $kelas, dengan topik $topik.
      Tipe soal: $model.
      
      PENTING - IKUTI FORMAT INI DENGAN KETAT:
      SOAL:
      [Tulis daftar soal dengan nomor urut di sini. Gunakan format LaTeX untuk matematika: \$contoh_rumus\$]
      
      KUNCI:
      [Tulis kunci jawaban atau pembahasan di sini]
      ''';

      final response = await modelAI.generateContent([Content.text(prompt)]);
      final text = response.text ?? "";

      // 2. Gunakan Regular Expression untuk hasil yang lebih tangguh (robust)
      // Ini mencari teks di antara "SOAL:" dan "KUNCI:" serta setelah "KUNCI:"
      final regExp = RegExp(r"SOAL:(.*)KUNCI:(.*)", dotAll: true);
      final match = regExp.firstMatch(text);

      if (match != null) {
        return {
          'soal': match.group(1)?.trim() ?? "Soal tidak ditemukan.",
          'kunci': match.group(2)?.trim() ?? "Kunci tidak ditemukan.",
        };
      } else {
        // Fallback jika AI tidak mengikuti format
        return {
          'soal': text,
          'kunci':
              'AI tidak mengikuti format penulisan, tapi ini respon mentahnya.',
        };
      }
    } catch (e) {
      // 3. Log error ke console untuk tracking di masa depan
      print("Error AI Service: $e");

      return {
        'soal': 'Terjadi kendala teknis saat menghubungi server AI.',
        'kunci':
            'Periksa koneksi internet atau sisa kuota API Key Anda. Error: ${e.toString()}',
      };
    }
  }
}
