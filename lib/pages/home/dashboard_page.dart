import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb

import 'package:minibank/pages/transaksi/isi_saldo_page.dart'; // Menu Isi Saldo
import 'package:minibank/pages/fitur/cicilan_page.dart'; // Menu Cicilan
import 'package:minibank/pages/fitur/kas_page.dart'; // Menu Kas
import 'package:minibank/pages/fitur/split_bill_list_page.dart'; // Menu Split Bill (List)

// UBAH JADI STATEFUL WIDGET AGAR SALDO BISA BERUBAH
class DashboardPage extends StatefulWidget {
  final String username;
  final String saldo;
  final String? nim;
  final String kelas;
  final String roleKelas;

  const DashboardPage(
      {super.key,
      required this.username,
      required this.saldo,
      this.nim,
      this.kelas = "-",
      this.roleKelas = "anggota"});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late String _currentSaldo; // Variabel saldo yang bisa berubah
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentSaldo = widget.saldo; // Inisialisasi awal
    _fetchLatestSaldo(); // Ambil saldo terbaru dari API
  }

  // FUNGSI TARIK SALDO TERBARU
  Future<void> _fetchLatestSaldo() async {
    setState(() => _isLoading = true);
    // ... (Login saldo tidak berubah)

    // UPDATE: Kita tidak benar-benar fetch saldo disini untuk mempersingkat,
    // tapi kalau mau, pakai endpoint get_saldo.php
    // Disini saya hanya simulasi agar UI safe.
    // Jika ingin real, copas logika fetch saldo dari login_page.dart

    // Anggap saldo sudah paling update dari Login
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Format Rupiah
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    // ignore: unused_local_variable
    String displaySaldo = formatter.format(double.tryParse(_currentSaldo) ?? 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Background Abu Muda
      body: RefreshIndicator(
        onRefresh: _fetchLatestSaldo,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. HEADER (Sapaan & Saldo) - STYLE BARU
              _buildHeader(context, formatter),

              const SizedBox(height: 20),

              // 2. MENU UTAMA (Grid)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Layanan Mahasiswa",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 15),
                    _buildMainMenu(context),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 3. BANNER PROMO (Carousel)
              _buildPromoBanner(),

              const SizedBox(height: 25),

              // 4. BERITA KAMPUS (Vertical List)
              _buildNewsSection(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NumberFormat formatter) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E), // Navy Blue
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Baris Atas (Profil & Notif)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Selamat Pagi,",
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(widget.username,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle),
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications, color: Colors.white)),
              )
            ],
          ),
          const SizedBox(height: 25),

          // Kartu Saldo Utama
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Saldo Aktif",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 5),
                    Text(
                      formatter.format(double.tryParse(_currentSaldo) ?? 0),
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E)),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // KE HALAMAN ISI SALDO
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) =>
                                IsiSaldoPage(username: widget.username)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    minimumSize: const Size(0, 36), // Tombol agak kecil
                  ),
                  child:
                      const Text("+ Isi Saldo", style: TextStyle(fontSize: 12)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMainMenu(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMenuIcon(
              context,
              Icons.receipt_long,
              "Cicilan",
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CicilanPage(
                          username: widget.username,
                          saldo: _currentSaldo,
                          nim: widget.nim)))),
          _buildMenuIcon(
              context,
              Icons.monetization_on_outlined,
              "Bayar Kas",
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KasPage(
                          username: widget.username,
                          kelas: widget.kelas,
                          roleKelas: widget.roleKelas,
                          nim: widget.nim ?? "-")))),
          _buildMenuIcon(
              context,
              Icons.call_split,
              "Split Bill",
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SplitBillListPage(
                          // <--- PASSING PARAMETERS HERE
                          username: widget.username,
                          nim: widget.nim ?? "-")))),
        ],
      ),
    );
  }

  Widget _buildMenuIcon(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFFE8EAF6),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFF1A237E), size: 26),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return SizedBox(
      height: 140,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        children: [
          _buildPromoCard(
              Colors.orange, "Diskon Kantin 50%", "Berlaku hari ini"),
          _buildPromoCard(
              Colors.blue, "Bebas Denda", "Bayar Cicilan Tepat Waktu"),
          _buildPromoCard(Colors.green, "Cashback TopUp", "Via Bank Mini"),
        ],
      ),
    );
  }

  Widget _buildPromoCard(Color color, String title, String subtitle) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [color, color.withOpacity(0.7)])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4)),
              child: const Text("PROMO",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold))),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          Text(subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildNewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Berita Kampus",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 15),
          _buildNewsItem("Jadwal UAS Semester Genap", "Akademik • 2 Jam lalu"),
          _buildNewsItem(
              "Pendaftaran Beasiswa 2024", "Kemahasiswaan • 5 Jam lalu"),
          _buildNewsItem(
              "Workshop Flutter untuk Pemula", "UKM IT • 1 Hari lalu"),
        ],
      ),
    );
  }

  Widget _buildNewsItem(String title, String meta) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)
          ]),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.article, color: Colors.grey[400]),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(meta,
                    style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
