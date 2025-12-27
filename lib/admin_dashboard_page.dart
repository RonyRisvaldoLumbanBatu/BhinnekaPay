import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // BACK TO MODERN
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AdminDashboardPage extends StatefulWidget {
  final String adminName;
  const AdminDashboardPage({super.key, required this.adminName});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final _currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // --- FUNGSI PROSES TOP UP KE SERVER ---
  Future<void> _processTopUpToServer(String username, int amount) async {
    // Pastikan IP ini benar (IP Laptop Anda)
    String baseUrl = kIsWeb
        ? 'http://localhost/api/topup.php'
        : 'http://192.168.18.10/api/topup.php';

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'username': username,
          'amount': amount.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _showSuccessDialog("SUKSES! Saldo $username bertambah.");
        } else {
          _showErrorDialog("Gagal: ${data['message']}");
        }
      } else {
        _showErrorDialog("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _showErrorDialog("Koneksi Error. Pastikan HP & Server satu jaringan.");
    }
  }

  // Fungsi untuk Membuka Scanner
  void _openScanner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Scan QR Mahasiswa"),
            backgroundColor: const Color(0xFF1A237E),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  final String code = barcode.rawValue!;
                  Navigator.pop(context); // Tutup Kamera
                  _processQrCode(code); // Proses Data
                  break;
                }
              }
            },
          ),
        ),
      ),
    );
  }

  void _processQrCode(String qrData) {
    try {
      Map<String, dynamic> data = jsonDecode(qrData);

      if (data['action'] == 'topup') {
        String user = data['username'];
        int amount = data['amount'];

        _showConfirmationDialog(user, amount);
      } else {
        _showErrorDialog("Format QR Tidak Dikenali");
      }
    } catch (e) {
      _showErrorDialog("QR Code Invalid");
    }
  }

  void _showConfirmationDialog(String user, int amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Setor Tunai"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Terima uang tunai dari:",
                style: TextStyle(color: Colors.grey)),
            Text(user,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 15),
            const Text("Sebesar:", style: TextStyle(color: Colors.grey)),
            Text(
              _currencyFormatter.format(amount),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color(0xFF1A237E)),
            ),
            const SizedBox(height: 15),
            const Text("Pastikan uang fisik sudah diterima sebelum konfirmasi.",
                style: TextStyle(fontSize: 12, color: Colors.orange)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("BATAL", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _processTopUpToServer(user, amount);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E)),
            child: const Text("KONFIRMASI TERIMA",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.green));
  }

  void _showErrorDialog(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Biro Keuangan",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Menu Utama",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E))),
                  const SizedBox(height: 20),

                  // TOMBOL SCANNER BESAR
                  GestureDetector(
                    onTap: () => _openScanner(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF283593), Color(0xFF1A237E)]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF1A237E).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8))
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle),
                            child: const Icon(Icons.qr_code_scanner,
                                size: 50, color: Colors.white),
                          ),
                          const SizedBox(height: 15),
                          const Text("SCAN QR TOP UP",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1)),
                          const SizedBox(height: 5),
                          const Text("Scan QR dari HP Mahasiswa",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
