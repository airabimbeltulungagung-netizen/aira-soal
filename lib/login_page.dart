import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Jika user menekan tombol kembali/batal, stop proses
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Proses Login ke Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Tidak perlu Navigator, main.dart akan otomatis mengarahkan ke GeneratorScreen
    } catch (e) {
      debugPrint("Login Error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal Login: ${e.toString()}"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2D0B43), Color(0xFF4A148C), Color(0xFF7B1FA2)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 40),
            const Text(
              "Aira Soal",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const Text(
              "Eksklusif AI Learning Partner",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 60),

            _isLoading
                ? const CircularProgressIndicator(color: Colors.amber)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black87,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(Icons.login),
                      label: const Text(
                        "MASUK DENGAN GOOGLE",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => _signInWithGoogle(context),
                    ),
                  ),
            const SizedBox(height: 20),
            const Text(
              "Dengan melanjutkan, Anda setuju dengan ketentuan Aira",
              style: TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
