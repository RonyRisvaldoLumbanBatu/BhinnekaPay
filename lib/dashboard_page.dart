import 'package:flutter/material.dart';
import 'isi_saldo_page.dart';
import 'edit_profile_page.dart';
import 'cicilan_page.dart';
import 'kas_page.dart';
import 'notification_page.dart';
import 'split_bill_list_page.dart';

class DashboardPage extends StatelessWidget {
  // 1. Variabel untuk nama user (dinamis dari Login)
  final String username;

  // 2. Wajibkan parameter username di konstruktor
  const DashboardPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Background abu muda
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // --- BAGIAN 1: MENAMPILKAN NAMA & NIM DI APPBAR ---
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username, // Menggunakan variabel username
              style: const TextStyle(
                color: Color(0xFF1A237E), // Navy Blue
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Text(
              "NIM: 2403310133", // NIM hardcoded sementara
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),

        // --- BAGIAN 2: ICON & FOTO PROFIL ---
        actions: [
          IconButton(
            onPressed: () {
              // Navigasi ke Halaman Notifikasi
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationPage()),
              );
            },
            icon: const Icon(Icons.notifications_outlined, color: Colors.grey),
          ),

          // Foto Profil (Klik untuk Edit)
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfilePage()));
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/profile_placeholder.png'), // Ganti sesuai asetmu
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // 1. Menu Grid (Isi Saldo, Cicilan, Kas, Split Bill)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Keuangan & Transaksi",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const Divider(height: 24),
                      const Text("Rp 5.700.000",
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E))),
                      const Text("Saldo Aktif",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 24),

                      // Ikon Menu
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Agar teks sejajar atas
                        children: [
                          _buildMenuItem(context, Icons.account_balance_wallet,
                              "Isi Saldo", () {
                            // --- PERBAIKAN DI SINI: Kirim username ke IsiSaldoPage ---
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IsiSaldoPage(username: username)));
                          }),
                          _buildMenuItem(context, Icons.receipt_long, "Cicilan",
                              () {
                            Navigator.push(
                                context,
                                // Kirim username ke CicilanPage
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CicilanPage(username: username)));
                          }),
                          _buildMenuItem(
                              context, Icons.monetization_on, "Bayar Kas", () {
                            Navigator.push(
                                context,
                                // Kirim username ke KasPage
                                MaterialPageRoute(
                                    builder: (context) =>
                                        KasPage(username: username)));
                          }),
                          // Menu Split Bill
                          _buildMenuItem(
                              context, Icons.call_split, "Split Bill", () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SplitBillListPage()));
                          }),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 2. Financial Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Ringkasan Bulan Ini",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Icon(Icons.pie_chart_outline,
                              color: Colors.grey, size: 20),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: _buildFinanceStat(Icons.arrow_downward,
                                  "Pemasukan", "Rp 385.000", Colors.green)),
                          const SizedBox(width: 16),
                          Expanded(
                              child: _buildFinanceStat(Icons.arrow_upward,
                                  "Pengeluaran", "Rp 380.000", Colors.red)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 3. Announcements
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    const ListTile(
                      title: Text("Pengumuman",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 14, color: Colors.grey),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading:
                          const Icon(Icons.info_outline, color: Colors.blue),
                      title: Text("Selamat Datang $username!",
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: const Text(
                          "Jangan lupa cek tagihan kas mingguan.",
                          style: TextStyle(fontSize: 11)),
                    ),
                    const ListTile(
                      leading: Icon(Icons.event_note, color: Colors.orange),
                      title: Text("Jadwal Ujian Tengah Semester",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text("Dimulai tanggal 20 Desember 2025.",
                          style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Widget Helpers ---

  Widget _buildMenuItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAF6), // Biru sangat muda
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF1A237E), size: 28),
          ),
          const SizedBox(height: 8),
          Text(label,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildFinanceStat(
      IconData icon, String label, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              Text(amount,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          )
        ],
      ),
    );
  }
}
