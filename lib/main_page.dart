import 'package:flutter/material.dart';

// --- IMPORT HALAMAN ---
import 'dashboard_page.dart';
import 'kas_page.dart';
import 'edit_profile_page.dart';
import 'cicilan_page.dart';
import 'isi_saldo_page.dart';

class MainPage extends StatefulWidget {
  final String username; // Menerima data dari Login

  const MainPage({super.key, required this.username});

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
    // List 'pages' dipindahkan KE DALAM method build()
    // supaya bisa mengakses 'widget.username'
    final List<Widget> pages = [
      // Index 0: Beranda
      DashboardPage(username: widget.username), 
      
      // Index 1: Isi Saldo (HAPUS const, TAMBAHKAN username)
      IsiSaldoPage(username: widget.username), 
      
      // Index 2: Cicilan (HAPUS const, TAMBAHKAN username)
      CicilanPage(username: widget.username),  
      
      // Index 3: Bayar Kas (HAPUS const, TAMBAHKAN username)
      KasPage(username: widget.username), 
      
      // Index 4: Profile (EditProfilePage biasanya statis atau ambil data sendiri, jadi tetap const aman)
      const EditProfilePage(), 
    ];

    return Scaffold(
      // Body mengambil dari variabel lokal 'pages'
      body: pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 28,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Isi Saldo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Cicilan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Kas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}