import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb

import 'package:minibank/pages/transaksi/isi_saldo_page.dart'; // Menu Isi Saldo
// import 'package:minibank/pages/fitur/riwayat_page.dart'; // HAPUS IMPORT INI
import 'package:minibank/pages/fitur/cicilan_page.dart'; // KEMBALIKAN IMPORT CICILAN
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
  late String _currentSaldo;
  double _income = 0;
  double _expense = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentSaldo = widget.saldo;
    _refreshData();
  }

  // FUNGSI TARIK DATA TERBARU (Saldo + Pemasukan/Pengeluaran)
  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await _fetchLatestSaldo();
    await _fetchDashboardStats();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _fetchLatestSaldo() async {
    // Logic fetch saldo simple (di real app pakai endpoint get_saldo)
  }

  Future<void> _fetchDashboardStats() async {
    String baseUrl = kIsWeb
        ? 'http://localhost/api/get_dashboard.php'
        : 'http://192.168.18.10/api/get_dashboard.php';

    try {
      final response = await http
          .post(Uri.parse(baseUrl), body: {'username': widget.username});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _income = double.parse(data['pemasukan'].toString());
            _expense = double.parse(data['pengeluaran'].toString());
          });
        }
      }
    } catch (e) {
      print("Error fetch dashboard: $e");
    }
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
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Biar bisa refresh walau konten sedikit
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

              // 3. PEMASUKAN & PENGELUARAN (REAL DATA)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ringkasan Keuangan",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 15),
                    _buildFinancialSummary(formatter),
                  ],
                ),
              ),

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
          // KEMBALIKAN KE CICILAN
          _buildMenuIcon(
              context,
              Icons.receipt_long, // ICON CICILAN
              "Cicilan", // LABEL CICILAN
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CicilanPage(
                          // NAVIGASI KE CICILAN
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
                          username: widget.username, nim: widget.nim ?? "-")))),
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

  // --- WIDGET BARU: PEMASUKAN DAN PENGELUARAN (DYNAMIC) ---
  Widget _buildFinancialSummary(NumberFormat formatter) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9), // Hijau Muda
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.arrow_downward, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text("Pemasukan",
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(formatter.format(_income), // REAL DATA
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE), // Merah Muda
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text("Pengeluaran",
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(formatter.format(_expense), // REAL DATA
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
