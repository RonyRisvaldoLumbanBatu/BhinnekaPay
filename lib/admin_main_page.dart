import 'package:flutter/material.dart';
import 'admin_dashboard_page.dart';
// Nanti kita buat halaman dummy untuk menu lain biar tidak error
// import 'admin_history_page.dart';
// import 'admin_users_page.dart';

class AdminMainPage extends StatefulWidget {
  final String adminName;

  const AdminMainPage({super.key, required this.adminName});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List halaman Admin
    final List<Widget> pages = [
      // Index 0: Dashboard (Yang sudah kita buat)
      AdminDashboardPage(adminName: widget.adminName),

      // Index 1: Riwayat (Placeholder dulu)
      _buildPlaceholderPage("Riwayat Transaksi", Icons.history),

      // Index 2: Kelola User (Placeholder dulu)
      _buildPlaceholderPage("Data Mahasiswa", Icons.people_outline),

      // Index 3: Profil Admin (Placeholder dulu)
      _buildPlaceholderPage("Profil Petugas", Icons.person_outline),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      // FOOTER FULL-WIDTH (MODERN CLASSIC)
      extendBody: false,
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
            selectedItemColor: const Color(0xFF1A237E),
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
                icon: Icon(Icons.dashboard_rounded),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_rounded),
                label: 'Riwayat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.groups_rounded),
                label: 'Mahasiswa',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Halaman Sementara (Placeholder)
  Widget _buildPlaceholderPage(String title, IconData icon) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A237E),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "Fitur $title Segera Hadir",
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
