import 'package:flutter/material.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  bool _notifEnabled = true;
  bool _biometricEnabled = false;
  bool _promoEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Latar abu
      appBar: AppBar(
        title: const Text("Pengaturan Aplikasi",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection("Umum"),
          _buildSwitch(
              "Notifikasi Transaksi",
              "Dapatkan notifikasi saat ada transaksi.",
              _notifEnabled,
              (v) => setState(() => _notifEnabled = v)),
          _buildSwitch(
              "Info Promo & Diskon",
              "Berita terbaru seputar promo kampus.",
              _promoEnabled,
              (v) => setState(() => _promoEnabled = v)),
          const SizedBox(height: 20),
          _buildSection("Keamanan"),
          _buildSwitch(
              "Login dengan Biometrik",
              "Gunakan sidik jari/wajah untuk login.",
              _biometricEnabled,
              (v) => setState(() => _biometricEnabled = v)),
          const SizedBox(height: 20),
          _buildSection("Lainnya"),
          _buildMenu("Bahasa / Language", "Bahasa Indonesia"),
          _buildMenu("Hapus Cache", "24 MB"),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E))),
    );
  }

  Widget _buildSwitch(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: SwitchListTile(
          title: Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          subtitle: Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          value: value,
          activeColor: const Color(0xFF1A237E),
          onChanged: onChanged),
    );
  }

  Widget _buildMenu(String title, String trailing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        trailing: Text(trailing,
            style: const TextStyle(color: Colors.grey, fontSize: 13)),
        onTap: () {},
      ),
    );
  }
}
