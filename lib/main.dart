import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'apk_aira_page.dart';
import 'result_screen.dart';
import 'ai_service.dart';
import 'login_page.dart';
import 'history_page.dart';

// 1. JARING PENANGKAP ERROR (Agar tidak langsung keluar/mental)
void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(const AiraBimbelApp());
    },
    (error, stackTrace) {
      debugPrint("FATAL ERROR: $error");
      runApp(ErrorWidgetApp(error: error.toString()));
    },
  );
}

// 2. TAMPILAN JIKA APLIKASI MENTAL (Layar Merah)
class ErrorWidgetApp extends StatelessWidget {
  final String error;
  const ErrorWidgetApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red[900],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bug_report, color: Colors.white, size: 60),
                const SizedBox(height: 20),
                const Text(
                  "APLIKASI MENTAL!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  error,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AiraBimbelApp extends StatelessWidget {
  const AiraBimbelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0A1F),
      ),
      home: const GeneratorScreen(),
    );
  }
}

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final TextEditingController _topikController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _mapelController = TextEditingController();
  final TextEditingController _modelSoalController = TextEditingController();
  final TextEditingController _jumlahSoalController = TextEditingController();

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aira Soal"),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Aira Soal",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                "Generator Soal AI",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              _buildTextField("Topik / Materi Soal", _topikController),
              _buildTextField("Kelas (Contoh: 12 IPA)", _kelasController),
              _buildTextField("Mata Pelajaran", _mapelController),
              _buildTextField(
                "Model Soal (PG, Essay, dll)",
                _modelSoalController,
              ),
              _buildTextField(
                "Jumlah Soal",
                _jumlahSoalController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                    );
                    try {
                      final data = await AiService.generateSoal(
                        topik: _topikController.text,
                        kelas: _kelasController.text,
                        mapel: _mapelController.text,
                        model: _modelSoalController.text,
                        jumlah: _jumlahSoalController.text,
                      );
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(data: data),
                        ),
                      );
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error AI: $e")));
                    }
                  },
                  child: const Text(
                    "Generate & Download",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1530),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryPage()),
            );
          else if (index == 2)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ApkAiraPage()),
            );
          else if (index == 3)
            _launchURL("https://wa.me/6285704351856");
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Buat Soal"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: "APK Aira",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Bantuan"),
        ],
      ),
    );
  }
}
