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

  // GANTI INI dengan Web Client ID dari Google Cloud Console
  // Ditemukan di: Google Cloud Console -> Credentials -> Web Client (OAuth 2.0)
  final String _webClientId =
      "82126319889-jplq2j99v5p5bvn47ja9lqnd3c9atpit.apps.googleusercontent.com";

  Future<void> _signInWithGoogle(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: _webClientId, // Kunci utama agar tidak minta SHA-1
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
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

      await FirebaseAuth.instance.signInWithCredential(credential);
      // Sukses! Navigator akan otomatis diarahkan oleh AuthStateChanges di main.dart
    } catch (e) {
      debugPrint("Login Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2D0B43), Color(0xFF4A148C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.amber)
              : ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  icon: const Icon(Icons.login, color: Colors.black),
                  label: const Text(
                    "MASUK DENGAN GOOGLE",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () => _signInWithGoogle(context),
                ),
        ),
      ),
    );
  }
}
