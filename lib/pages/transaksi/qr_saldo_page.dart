import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async'; // Untuk Timer
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // kIsWeb

class QrSaldoPage extends StatefulWidget {
  final int nominal;
  final String username;

  const QrSaldoPage({super.key, required this.nominal, required this.username});

  @override
  State<QrSaldoPage> createState() => _QrSaldoPageState();
}

class _QrSaldoPageState extends State<QrSaldoPage> {
  Timer? _timer;
  int _initialSaldo = 0; // Saldo awal saat generate QR

  @override
  void initState() {
    super.initState();
    _getFirstSaldo(); // Ambil saldo awal dulu
  }

  @override
  void dispose() {
    _timer?.cancel(); // Matikan timer kalau keluar halaman
    super.dispose();
  }

  // 1. Cek Saldo Awal (Snapshot)
  Future<void> _getFirstSaldo() async {
    int saldo = await _fetchCurrentSaldo();
    if (mounted) {
      setState(() {
        _initialSaldo = saldo;
      });
      // Setelah dapat saldo awal, baru mulai pemantauan berkala
      _startMonitoring();
    }
  }

  // 2. Mulai Memantau Perubahan (Long Polling tiap 3 detik)
  void _startMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      int currentSaldo = await _fetchCurrentSaldo();

      // LOGIKA UTAMA: JIKA SALDO LEBIH BESAR DARI SALDO AWAL
      if (currentSaldo > _initialSaldo) {
        _timer?.cancel(); // Stop monitoring
        if (mounted) {
          _showSuccessAnimation(); // Tampilkan animasi sukses
        }
      }
    });
  }

  // 3. Fungsi Logika API Get Saldo
  Future<int> _fetchCurrentSaldo() async {
    String baseUrl = kIsWeb
        ? 'http://localhost/api/get_saldo.php'
        : 'http://192.168.18.10/api/get_saldo.php';

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {'username': widget.username},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          double rawSaldo = double.tryParse(data['saldo'].toString()) ?? 0.0;
          return rawSaldo.toInt();
        }
      }
    } catch (e) {
      print("Check Saldo Error: $e");
    }
    return _initialSaldo; // Kalau error, anggap saldo tetap
  }

  // 4. Tampilkan Layar Sukses (Real-Time Effect!)
  void _showSuccessAnimation() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessPage(nominal: widget.nominal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final String nominalFormatted = currencyFormatter.format(widget.nominal);
    final String qrData =
        '{"action":"topup","username":"${widget.username}","amount":${widget.nominal}}';

    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      appBar: AppBar(
        title: const Text("Menunggu Pembayaran...",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Loading Indicator Kecil biar user tau sedang menunggu
              const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2)),
              const SizedBox(height: 10),

              const Text(
                "Tunjukkan ke Admin Biro",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // KARTU QR CODE
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10))
                  ],
                ),
                child: Column(
                  children: [
                    QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 240.0,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    const Text("Total Setor Tunai",
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 5),
                    Text(
                      nominalFormatted,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              const Text("Otomatis terupdate setelah scan berhasil",
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

// --- HALAMAN SUKSES KEREN ---
class SuccessPage extends StatelessWidget {
  final int nominal;
  const SuccessPage({super.key, required this.nominal});

  @override
  Widget build(BuildContext context) {
    // Delay 2 detik lalu balik ke Dashboard
    Future.delayed(const Duration(seconds: 2), () {
      // Pop sampai ke Dashboard (Halaman Pertama)
      Navigator.popUntil(context, (route) => route.isFirst);
    });

    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.green, // Layar Hijau Full
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded,
                  color: Colors.green, size: 50),
            ),
            const SizedBox(height: 30),
            const Text("Top Up Berhasil!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(currencyFormatter.format(nominal),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
