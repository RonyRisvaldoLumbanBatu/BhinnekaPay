import 'package:flutter/material.dart';
import 'login_page.dart';
import 'notification_page.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna Utama (Navy Blue)
    const Color primaryColor = Color(0xFF1A237E); 

    return Scaffold(
      backgroundColor: primaryColor, // Background dasar biru
      
      // --- PERUBAHAN 1: MENAMBAHKAN APPBAR (TOMBOL BACK OTOMATIS) ---
      appBar: AppBar(
        title: const Text("Profil Saya"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white, // Warna teks & icon putih
        elevation: 0, // Menghilangkan bayangan agar menyatu dengan background
        actions: [
          IconButton(
              onPressed: () {
                // Navigasi ke Halaman Notifikasi
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationPage()),
                );
              },
              icon: const Icon(Icons.notifications_outlined, color: Colors.grey),
            ),
        ],
      ),

      // --- PERUBAHAN 2: MENGHAPUS BOTTOM NAVIGATION BAR ---
      // (Bagian bottomNavigationBar dihapus dari sini)

      body: Stack(
        children: [
          // --- LAPISAN 1: INFO USER (BIRU) ---
          Container(
            height: 160, // Tinggi area biru (dikurangi karena sudah ada AppBar)
            width: double.infinity,
            color: primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto Profil
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: const DecorationImage(
                      image: AssetImage('assets/profile_placeholder.png'), // Ganti gambar
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Nama & No HP
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Safa Jahra",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "085*******252",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- LAPISAN 2: MENU PUTIH ---
          Container(
            margin: const EdgeInsets.only(top: 100), // Posisi overlap dinaikkan sedikit
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  // --- LIST MENU ---
                  
                  // Menu Edit Profil (Navigasi ke EditProfilePage)
                  _buildMenuItem(Icons.person_outline, "Ubah Profil", () { }),
                  _buildDivider(),
                  
                  _buildMenuItem(Icons.shield_outlined, "Keamanan Akun", () {}),
                  _buildDivider(),
                  
                  _buildMenuItem(Icons.receipt_long, "e-Statement", () {}),
                  _buildDivider(),
                  
                  _buildMenuItem(Icons.credit_card, "Pengaturan Limit", () {}),
                  _buildDivider(),
                  
                  _buildMenuItem(Icons.settings_outlined, "Pengaturan Umum", () {}),
                  _buildDivider(),
                  
                  // Chat Admin
                  _buildMenuItem(Icons.chat_bubble_outline, "Chat dengan Admin", () {}),
                  _buildDivider(),

                  _buildMenuItem(Icons.location_on_outlined, "Lokasi Kantor", () {}),
                  _buildDivider(),
                  
                  _buildMenuItem(Icons.feedback_outlined, "Beri Masukan", () {}),
                  
                  const SizedBox(height: 30),

                  // --- TOMBOL LOGOUT ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // Navigasi ke Halaman Login dan Hapus semua tumpukan halaman (Stack)
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()), 
                            (route) => false, // return false artinya hapus semua history halaman sebelumnya
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          "Log Out",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper Menu Item
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      leading: Icon(icon, color: Colors.black87, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }

  // Widget Helper Garis
  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      indent: 64,
      color: Colors.grey,
    );
  }
}