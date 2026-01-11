import 'package:flutter/material.dart';

// --- IMPORT HALAMAN ---
import 'dashboard_page.dart';
import 'kas_page.dart';
import 'edit_profile_page.dart';
import 'cicilan_page.dart';

class MainPage extends StatefulWidget {
  final String username; // Nama User
  final String saldo; // Saldo
  final String email; // Email Kampus (Baru)
  final String? nim; // NIM (Baru)

  // Constructor Updated: Menerima Username, Saldo, Email, NIM
  // Tambahkan nilai default kosong untuk email/nim agar tidak error jika dari kode lama
  const MainPage(
      {super.key,
      required this.username,
      required this.saldo,
      this.email = "",
      this.nim});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List halaman untuk footer
    final List<Widget> pages = [
      // Index 0: Beranda
      DashboardPage(
          username: widget.username,
          saldo: widget.saldo,
          nim: widget.nim // FIX: Kirim NIM ke Dashboard
          ),

      // Index 1: Cicilan
      CicilanPage(username: widget.username),

      // Index 2: Bayar Kas
      KasPage(username: widget.username),

      // Index 3: Profile (DATA DINAMIS DIKIRIM KE SINI)
      EditProfilePage(
        username: widget.username,
        email: widget.email,
        nim: widget.nim,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],

      // FOOTER MENU STANDARD (Tanpa Container Aneh-aneh)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1A237E), // Navy Blue
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 8, // Elevation standar Flutter
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Cicilan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on), label: 'Kas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
