import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ai_service.dart';
import 'result_screen.dart';
import 'apk_aira_page.dart';
import 'history_page.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Column(
        children: [
          // Header Premium
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3D2678), Color(0xFF1A1530)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    "Halo, ${user?.displayName?.split(' ')[0] ?? 'Siswa'}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ],
            ),
          ),

          // Form Input
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildTextField("Topik / Materi", _topikController),
                  _buildTextField("Kelas", _kelasController),
                  _buildTextField("Mata Pelajaran", _mapelController),
                  _buildTextField("Model Soal", _modelSoalController),
                  _buildTextField("Jumlah Soal", _jumlahSoalController),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                        );
                        try {
                          // Sekarang memanggil fungsi yang mengembalikan Map<String, String>
                          final Map<String, String> data =
                              await AiService.generateSoal(
                                topik: _topikController.text,
                                kelas: _kelasController.text,
                                mapel: _mapelController.text,
                                model: _modelSoalController.text,
                                jumlah: _jumlahSoalController.text,
                              );

                          if (!mounted) return;
                          Navigator.pop(context); // Tutup loading
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultScreen(data: data),
                            ),
                          );
                        } catch (e) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "GENERATE SOAL",
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
        ],
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
          if (index == 2)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ApkAiraPage()),
            );
          if (index == 3) launchUrl(Uri.parse("https://wa.me/6285704351856"));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Buat"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: "APK"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Bantuan"),
        ],
      ),
    );
  }
}
