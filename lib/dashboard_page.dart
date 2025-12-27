import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb

import 'isi_saldo_page.dart'; // Menu Isi Saldo
import 'cicilan_page.dart'; // Menu Cicilan
import 'kas_page.dart'; // Menu Kas
import 'split_bill_list_page.dart'; // Menu Split Bill (List)

// UBAH JADI STATEFUL WIDGET AGAR SALDO BISA BERUBAH
class DashboardPage extends StatefulWidget {
  final String username;
  final String saldo; // Saldo awal dari Login

  const DashboardPage({super.key, required this.username, required this.saldo});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late String _currentSaldo; // Variabel saldo yang bisa berubah
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentSaldo = widget.saldo; // Set awal
    _refreshSaldo(); // Auto refresh saat dibuka pertama kali
  }

  // FUNGSI TARIK DATA TERBARU DARI SERVER
  Future<void> _refreshSaldo() async {
    setState(() => _isLoading = true);

    // IP Laptop Anda (Sesuaikan!)
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
          setState(() {
            double rawSaldo = double.tryParse(data['saldo'].toString()) ?? 0.0;
            _currentSaldo = rawSaldo.toInt().toString();
          });
        }
      }
    } catch (e) {
      // Silent error: gagal refresh saldo tidak perlu mengganggu user
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format Rupiah
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Background Light Grey
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        // FITUR TARIK UNTUK REFRESH
        onRefresh: _refreshSaldo,
        color: const Color(0xFF1A237E),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 1. KARTU SALDO UTAMA
              _buildSaldoCard(currencyFormatter),

              const SizedBox(height: 25),

              // 2. MENU FITUR UTAMA
              _buildMainMenu(context),

              const SizedBox(height: 30),

              // 3. WIDGET RINGKASAN KEUANGAN
              const Text(
                "Ringkasan Keuangan",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E)),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                      child: _buildSummaryCard(Icons.arrow_downward,
                          "Pemasukan", "Rp 385.000", Colors.green)),
                  const SizedBox(width: 15),
                  Expanded(
                      child: _buildSummaryCard(Icons.arrow_upward,
                          "Pengeluaran", "Rp 380.000", Colors.redAccent)),
                ],
              ),

              const SizedBox(height: 30),

              // 4. WIDGET INFO KAMPUS
              const Text(
                "Info Terbaru",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E)),
              ),
              const SizedBox(height: 15),
              _buildInfoCard(Icons.calendar_today,
                  "Jadwal Ujian Tengah Semester", "20 Des 2025", Colors.orange),
              const SizedBox(height: 10),
              _buildInfoCard(Icons.notifications_active, "Pembayaran Kas Kelas",
                  "Jumat Depan", Colors.blue),

              const SizedBox(height: 50), // Spasi bawah agar tidak mentok
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1A237E),
      elevation: 0,
      toolbarHeight: 80,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                  'assets/profile_placeholder.png'), // Ganti dengan foto user jika ada
              backgroundColor: Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Halo, ${widget.username}!",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(width: 5),
                  const Text("👋", style: TextStyle(fontSize: 16)),
                ],
              ),
              const Text("NIM: 2403310133",
                  style: TextStyle(fontSize: 12, color: Colors.white70)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _refreshSaldo, // Tombol Refresh Manual
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : const Icon(Icons.refresh, color: Colors.white),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildSaldoCard(NumberFormat formatter) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF283593)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.account_balance_wallet, color: Colors.white70),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: const Text("BHINNEKA PAY",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10)),
              )
            ],
          ),
          const SizedBox(height: 20), // Spasi agak besar
          const Text("Saldo Aktif",
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 5),
          Text(
            formatter.format(
                double.tryParse(_currentSaldo) ?? 0), // TAMPILKAN SALDO DINAMIS
            style: const TextStyle(
              fontSize: 32, // Lebih besar
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenu(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMenuIcon(
            context,
            Icons.add_circle_outline,
            "Isi Saldo",
            () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            IsiSaldoPage(username: widget.username)))
                .then((_) => _refreshSaldo()) // REFRESH SAAT KEMBALI
            ),
        _buildMenuIcon(
            context,
            Icons.receipt_long,
            "Cicilan",
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CicilanPage(username: widget.username)))),
        _buildMenuIcon(
            context,
            Icons.monetization_on_outlined,
            "Bayar Kas",
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => KasPage(username: widget.username)))),
        _buildMenuIcon(
            context,
            Icons.call_split,
            "Split Bill",
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SplitBillListPage()))),
      ],
    );
  }

  Widget _buildMenuIcon(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5))
              ],
            ),
            child: Icon(icon, color: const Color(0xFF1A237E), size: 28),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 28),
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
                Text(subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
