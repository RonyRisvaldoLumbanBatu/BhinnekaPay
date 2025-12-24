import 'package:flutter/material.dart';
import 'package:minibank/main_page.dart';
import 'dart:io'; 

class BuktiKasPage extends StatelessWidget {
  final int totalBayar;
  final int jumlahMinggu;
  final String imagePath; // Path gambar bukti transfer
  final String username;  // <--- 1. ADDED: Username parameter to maintain state
  
  final DateTime transactionTime = DateTime.now();

  BuktiKasPage({
    super.key,
    required this.totalBayar,
    required this.jumlahMinggu,
    required this.imagePath,
    required this.username, // <--- 2. ADDED: Require username in constructor
  });

  // Helper Format Rupiah
  String _formatRupiah(int number) {
    return "Rp${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  // Format Tanggal
  String _formatDate(DateTime time) {
    return "${time.day}/${time.month}/${time.year}, ${time.hour}:${time.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Invoice Kas Kelas"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER SUKSES ---
            Center(
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 60),
                  const SizedBox(height: 10),
                  const Text("Pembayaran Berhasil Dikirim",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 5),
                  Text(_formatDate(transactionTime),
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 1),
            const SizedBox(height: 20),

            // --- DETAIL TRANSAKSI ---
            const Text("Detail Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            
            _buildRow("Jenis Pembayaran", "Uang Kas Kelas"),
            _buildRow("Periode", "$jumlahMinggu Minggu"),
            _buildRow("Harga per Minggu", "Rp10.000"),
            const Divider(),
            _buildRow("Total Bayar", _formatRupiah(totalBayar), isBold: true, color: const Color(0xFF1A237E)),
            
            const SizedBox(height: 20),

            // --- FOTO BUKTI ---
            const Text("Bukti Foto:", style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- FOOTER NOTE ---
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Text(
                "Data pembayaran dan bukti foto telah dikirim ke bendahara untuk verifikasi. Simpan bukti ini.",
                style: TextStyle(fontSize: 12, color: Colors.brown),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),

            // --- TOMBOL KEMBALI ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.pushAndRemoveUntil(
                    context,
                    // <--- 3. FIX: Pass the username back to MainPage
                    MaterialPageRoute(builder: (context) => MainPage(username: username)), 
                    (route) => false, 
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Kembali ke Beranda", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}