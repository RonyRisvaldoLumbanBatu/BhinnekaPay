import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna tema Bhinneka Pay
    const Color primaryColor = Color(0xFF1A237E); 

    return DefaultTabController(
      length: 2, // Jumlah Tab (Notifikasi & Promo)
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Pesan",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          // --- MEMBUAT TAB BAR SEPERTI GAMBAR ---
          bottom: const TabBar(
            indicatorColor: primaryColor, // Garis bawah biru
            indicatorWeight: 3,
            labelColor: primaryColor, // Warna teks aktif
            unselectedLabelColor: Colors.grey, // Warna teks tidak aktif
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: [
              Tab(text: "Notifikasi"),
              Tab(text: "Promo"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- TAB 1: NOTIFIKASI ---
            _buildNotificationList(primaryColor),

            // --- TAB 2: PROMO (Placeholder) ---
            _buildPromoList(primaryColor),
          ],
        ),
      ),
    );
  }

  // Widget untuk Daftar Notifikasi
  Widget _buildNotificationList(Color color) {
    return ListView(
      children: [
        _buildItem(
          title: "Topup e-wallet",
          desc: "Kamu berhasil melakukan Top Up e-Wallet senilai Rp37.000 ke DANA. Ref: 20251210...",
          date: "09 Des 2025, 15:19",
          icon: Icons.sync,
        ),
        const Divider(height: 1), // Garis pemisah tipis
        
        _buildItem(
          title: "Pembayaran Berhasil",
          desc: "Pembayaran ShopeePay kamu sebesar Rp15.000 berhasil. Hubungi CS jika ada kendala.",
          date: "07 Des 2025, 19:39",
          icon: Icons.check_circle_outline, // Ikon centang
        ),
        const Divider(height: 1),

        _buildItem(
          title: "Pembayaran QRIS Berhasil",
          desc: "Pembayaran QRIS untuk Kantin Teknik sebesar Rp12.000 telah berhasil.",
          date: "07 Des 2025, 12:10",
          icon: Icons.qr_code_scanner,
        ),
        const Divider(height: 1),

        _buildItem(
          title: "Transfer Masuk",
          desc: "Kamu menerima transfer saldo senilai Rp210.000 dari Budi Santoso.",
          date: "05 Des 2025, 10:25",
          icon: Icons.input, // Ikon masuk
        ),
        const Divider(height: 1),
        
        _buildItem(
          title: "Topup e-wallet",
          desc: "Kamu berhasil melakukan Top Up e-Wallet senilai Rp50.000 ke OVO.",
          date: "04 Des 2025, 09:00",
          icon: Icons.sync,
        ),
      ],
    );
  }

  // Widget untuk Daftar Promo (Halaman kosong dulu)
  Widget _buildPromoList(Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.discount_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("Belum ada promo saat ini", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // --- ITEM NOTIFIKASI YANG MIRIP GAMBAR ---
  Widget _buildItem({
    required String title,
    required String desc,
    required String date,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.white, // Background putih bersih
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Ikon Bulat di Kiri
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300), // Garis pinggir abu
            ),
            child: Icon(icon, color: Colors.grey[600], size: 20),
          ),
          
          const SizedBox(width: 16),

          // 2. Teks (Judul, Deskripsi, Tanggal)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700], // Abu-abu agak gelap
                    height: 1.4, // Spasi antar baris
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500], // Abu-abu terang untuk tanggal
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}