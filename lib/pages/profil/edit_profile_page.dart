import 'package:flutter/material.dart';
import 'package:minibank/pages/auth/login_page.dart';
// IMPORT HALAMAN BARU
import 'package:minibank/pages/transaksi/riwayat_page.dart';
import 'package:minibank/pages/profil/ubah_profil_page.dart';
import 'package:minibank/pages/profil/keamanan_page.dart';
import 'package:minibank/pages/fitur/limit_page.dart';
import 'package:minibank/pages/profil/pengaturan_page.dart';
import 'package:minibank/pages/profil/bantuan_page.dart';
import 'package:minibank/pages/profil/tentang_page.dart';
import 'package:minibank/pages/home/notification_page.dart';

class EditProfilePage extends StatelessWidget {
  final String username;
  final String email;
  final String? nim;
  final String kelas; // <-- TAMBAH FIELD KELAS

  const EditProfilePage({
    super.key,
    required this.username,
    required this.email,
    this.nim,
    this.kelas = "-",
  });

  @override
  Widget build(BuildContext context) {
    // LOGIKA NIM
    String displaySubtext = email;
    if (nim != null && nim != "null" && nim!.isNotEmpty) {
      displaySubtext = nim!;
    } else {
      if (email.contains("@")) {
        try {
          String possibleNim = email.split("@")[0];
          if (RegExp(r'^[0-9]+$').hasMatch(possibleNim)) {
            displaySubtext = possibleNim;
          }
        } catch (_) {}
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Background Abu Muda
      appBar: AppBar(
        title: const Text("Profil Mahasiswa"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A237E),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const NotificationPage()),
              );
            },
            icon: const Icon(Icons.notifications_outlined, color: Colors.grey),
          ),
        ],
      ),
      body: ListView(
        // Gunakan ListView agar scroll lebih mulus
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 20),

          // --- KARTU KTM DIGITAL (Fixed Design + Nama Naik) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 200,
              width: double.infinity,
              clipBehavior: Clip.hardEdge, // PENTING: Agar dekorasi tidak bocor
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1A237E),
                    Color(0xFF283593),
                    Color(0xFF3949AB),
                  ],
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
              child: Stack(
                children: [
                  // Dekorasi
                  Positioned(
                    top: -20,
                    right: -20,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    left: -20,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white.withOpacity(0.05),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.nfc, color: Colors.white54),
                            const SizedBox(width: 8),
                            Text(
                              "KTM DIGITAL",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                letterSpacing: 2,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            // Logo Placeholder (Text)
                            const Text(
                              "BhinnekaPay",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // User Info
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.indigo.shade100,
                                child: Text(
                                  username.isNotEmpty
                                      ? username[0].toUpperCase()
                                      : "U",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A237E),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'Courier',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    displaySubtext,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontFamily: 'Courier',
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // BADGE STATUS (Student & Kelas)
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: const Text(
                                          "Student",
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // MENAMPILKAN KELAS JIKA ADA
                                      if (kelas != "-" && kelas.isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            "Kelas $kelas",
                                            style: const TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // FIXED: Tambahkan jarak 20px biar nama "Naik" ke atas
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // --- MENU GROUP 1: AKUN ---
          _buildMenuHeader("Akun Saya"),
          _buildMenuSection([
            _buildMenuItem(
              context,
              Icons.person_outline,
              "Ubah Data Diri",
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => UbahProfilPage(
                    username: username,
                    email: email,
                    nim: nim ?? "-",
                    kelas: kelas,
                  ),
                ),
              ),
            ), // <-- PASS KELAS
            _buildDivider(),
            _buildMenuItem(
              context,
              Icons.shield_outlined,
              "Keamanan & Password",
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const KeamananPage()),
              ),
            ),
            _buildDivider(),
            _buildMenuItem(
              context,
              Icons.history_edu,
              "Riwayat Transaksi",
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const RiwayatPage()),
              ),
            ),
            _buildDivider(),
            _buildMenuItem(
              context,
              Icons.credit_card,
              "Limit Hari Ini",
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const LimitPage()),
              ),
            ),
          ]),

          const SizedBox(height: 20),

          // --- MENU GROUP 2: INFO ---
          _buildMenuHeader("Info & Bantuan"),
          _buildMenuSection([
            _buildMenuItem(
              context,
              Icons.settings_outlined,
              "Pengaturan Aplikasi",
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const PengaturanPage()),
              ),
            ),
            _buildDivider(),
            _buildMenuItem(
              context,
              Icons.headset_mic_outlined,
              "Pusat Bantuan",
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const BantuanPage()),
              ),
            ),
            _buildDivider(),
            _buildMenuItem(
              context,
              Icons.info_outline,
              "Tentang Bhinneka Pay",
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const TentangPage()),
              ),
            ),
          ]),

          const SizedBox(height: 30),

          // --- LOGOUT ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () => _showLogoutConfirm(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEBEE),
                foregroundColor: Colors.red,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Log Out",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildMenuHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildMenuSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: children,
      ), // Menggunakan Column biasa di dalam Container putih
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    // USE MATERIAL TRANSPARAN AGAR RIPPLE EFFECT JALAN DI ATAS CONTAINER PUTIH
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(0), // Radius 0 karena di dalam list
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF1A237E), size: 20),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      indent: 64,
      endIndent: 20,
      color: Colors.black12,
    );
  }

  void _showLogoutConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Keluar Akun?"),
        content: const Text("Anda harus login ulang untuk mengakses saldo."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text(
              "Ya, Keluar",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
