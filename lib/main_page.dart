import 'package:flutter/material.dart';

// --- IMPORT HALAMAN ---
import 'dashboard_page.dart';
import 'kas_page.dart';
import 'edit_profile_page.dart';
import 'cicilan_page.dart';
// Note: isi_saldo_page.dart tidak lagi diimport untuk footer, tapi tetap ada di dashboard

class MainPage extends StatefulWidget {
  final String username; // Menerima data dari Login
  final String saldo; // Menerima data saldo

  const MainPage({super.key, required this.username, required this.saldo});

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
      DashboardPage(username: widget.username, saldo: widget.saldo),

      // Index 1: Cicilan (Naik menggantikan Isi Saldo)
      CicilanPage(username: widget.username),

      // Index 2: Bayar Kas
      KasPage(username: widget.username),

      // Index 3: Profile
      const EditProfilePage(),
    ];

    return Scaffold(
      // Body mengambil dari variabel lokal 'pages'
      body: pages[_selectedIndex],

      // FOOTER FULL-WIDTH (MODERN CLASSIC) - Updated 4 Items
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF1A237E), // Navy Blue
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            iconSize: 26,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Beranda',
              ),
              // Isi Saldo DIHAPUS dari sini
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long), // Ikon Cicilan
                label: 'Cicilan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on), // Ikon Kas
                label: 'Kas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
