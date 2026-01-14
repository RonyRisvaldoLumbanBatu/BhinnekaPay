import 'package:flutter/material.dart';

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tentang Aplikasi",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png",
                width: 100,
                errorBuilder: (c, e, s) => const Icon(Icons.wallet,
                    size: 80, color: Color(0xFF1A237E))),
            const SizedBox(height: 20),
            const Text("Bhinneka Pay",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E))),
            const Text("Versi 1.0.0 (Beta)",
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Aplikasi E-Wallet resmi Universitas Satya Terra Bhinneka untuk memudahkan transaksi mahasiswa, pembayaran kas, dan tagihan lainnya.",
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.5, color: Colors.black54),
              ),
            ),
            const Spacer(),
            const Text("© 2025 Univ. Satya Terra Bhinneka",
                style: TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
