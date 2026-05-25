import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'result_screen.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Soal"),
        backgroundColor: const Color(0xFF1A1530),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Mengambil data dari koleksi riwayat milik user yang sedang login
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('riwayat')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFD700)),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada riwayat soal",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return Card(
                color: Colors.white10,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(
                    doc['topik'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Dibuat: ${doc['timestamp']?.toDate().toString().substring(0, 16)}",
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white70,
                  ),
                  onTap: () {
                    // Navigasi ke hasil soal yang tersimpan
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultScreen(data: doc['data']),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
