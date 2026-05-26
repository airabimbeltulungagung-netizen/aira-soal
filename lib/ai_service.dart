import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  // GANTI INI DENGAN API KEY ANDA YANG VALID
  static const String _apiKey = 'AIzaSyABTD5CSVOOYGiroxov2NBJNkmu-wNAzrw';

  static Future<Map<String, String>> generateSoal({
    required String topik,
    required String kelas,
    required String mapel,
    required String model,
    required String jumlah,
  }) async {
    // Validasi API Key sebelum melakukan request
    if (_apiKey.isEmpty || _apiKey == 'ISI_API_KEY_ANDA_DI_SINI') {
      throw Exception("API Key belum diatur!");
    }

    try {
      final modelAI = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey,
      );

      // Kita buat prompt yang meminta format spesifik agar mudah dipisahkan
      final prompt =
          '''
        Buatkan $jumlah soal $model untuk materi $topik, kelas $kelas, mata pelajaran $mapel.
        
        Format output:
        [SOAL]
        (Tuliskan soal-soal di sini)
        [PEMBAHASAN]
        (Tuliskan kunci jawaban dan pembahasan di sini)
      ''';

      final response = await modelAI.generateContent([Content.text(prompt)]);

      if (response.text != null) {
        // Logika untuk memisahkan Soal dan Pembahasan
        String fullText = response.text!;
        String soal = "";
        String kunci = "";

        if (fullText.contains("[SOAL]") && fullText.contains("[PEMBAHASAN]")) {
          soal = fullText.split("[SOAL]")[1].split("[PEMBAHASAN]")[0].trim();
          kunci = fullText.split("[PEMBAHASAN]")[1].trim();
        } else {
          soal = fullText;
          kunci = "Pembahasan tidak ditemukan dalam format terstruktur.";
        }

        return {'soal': soal, 'kunci': kunci};
      } else {
        throw Exception("AI tidak merespon.");
      }
    } catch (e) {
      throw Exception("Gagal terhubung ke AI: ${e.toString()}");
    }
  }
}
