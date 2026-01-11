import 'package:flutter/material.dart';

class RequestSaldoPage extends StatelessWidget {
  final String username;
  final String? nim;

  const RequestSaldoPage({super.key, required this.username, this.nim});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E), // Background Biru Navy
      appBar: AppBar(
        title: const Text("Kode QR Saya"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // FOTO PROFIL (Dummy)
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[200]!, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFE8EAF6),
                  child: Icon(Icons.person, size: 35, color: Color(0xFF1A237E)),
                ),
              ),
              const SizedBox(height: 15),

              Text(username,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              Text(nim ?? "Mahasiswa",
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),

              const SizedBox(height: 30),

              // QR CODE (MOCKUP GAMBAR)
              // Nanti diganti dengan QrImage asli dari package qr_flutter
              Container(
                width: 200,
                height: 200,
                color: Colors.grey[100],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_2, size: 150, color: Colors.black),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              const Text("Tunjukkan QR ini ke teman\nuntuk menerima saldo",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
