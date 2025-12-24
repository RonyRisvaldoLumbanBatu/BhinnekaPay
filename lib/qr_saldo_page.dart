import 'package:flutter/material.dart';
import 'main_page.dart'; 

class QrSaldoPage extends StatelessWidget {
  final String inputNominal;
  final String username; // <--- 1. TAMBAHKAN INI

  const QrSaldoPage({
    super.key,
    required this.inputNominal,
    required this.username, // <--- 2. WAJIBKAN DI SINI
  });

  String _formatRupiah(int number) {
    String price = number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return "Rp$price";
  }

  @override
  Widget build(BuildContext context) {
    int nominalInt = int.tryParse(inputNominal) ?? 0;
    int biayaAdmin = 1500;
    int totalBayar = nominalInt + biayaAdmin;

    return Scaffold(
      appBar: AppBar(title: const Text("Isi Saldo Bhinneka Pay")),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        const Text("Kamu akan membayar sebesar",
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        Text(
                          _formatRupiah(totalBayar),
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Biaya Admin: Rp1.500 + Isi saldo: ${_formatRupiah(nominalInt)}",
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text("Tunjukkan kode ini ke admin",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  Image.asset(
                    'assets/qr_code.png', 
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // PERBAIKAN: Kirim username ke MainPage
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage(username: username)), 
                          (route) => false, 
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Kembali ke Beranda"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}