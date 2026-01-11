import 'package:flutter/material.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pusat Bantuan",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // SEARCH BAR
            TextField(
              decoration: InputDecoration(
                  hintText: "Cari kendala kamu...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none)),
            ),
            const SizedBox(height: 20),

            // FAQ LIST
            _buildFAQ("Bagaimana cara isi saldo?",
                "Kamu bisa meminta Admin Keuangan Kampus untuk melakukan Top Up dengan scan QR Code kamu."),
            _buildFAQ("Apakah bisa transfer ke bank lain?",
                "Saat ini Bhinneka Pay hanya mendukung transfer sesama mahasiswa."),
            _buildFAQ("Kenapa saldo tidak bertambah?",
                "Coba refresh halaman dashboard atau logout dan login kembali."),
            _buildFAQ("Lupa password akun?",
                "Silakan hubungi admin IT kampus dengan membawa KTM fisik."),

            const SizedBox(height: 30),

            // CONTACT US (FIX: Ganti Icons.whatsapp jadi Icons.chat)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const Icon(Icons.chat, color: Colors.green, size: 40),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Butuh bantuan lebih?",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Chat Admin Support (08:00 - 16:00)",
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFAQ(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(question,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer,
                style: const TextStyle(color: Colors.grey, height: 1.5)),
          )
        ],
      ),
    );
  }
}
