import 'package:flutter/material.dart';

// --- IMPORT HALAMAN ---
import 'dashboard_page.dart';
import 'kas_page.dart';
import 'edit_profile_page.dart';
import 'cicilan_page.dart';
import 'qr_scan_page.dart';
import 'input_nim_page.dart';
import 'request_saldo_page.dart';

class MainPage extends StatefulWidget {
  final String username;
  final String saldo;
  final String email;
  final String? nim;

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

  // --- MENU MODAL "ULTRA PREMIUM" (REVISI FINAL) ---
  void _showTransactionMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        // State Lokal Modal
        bool isKirimMode = false;

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setSheetState) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 400, // Tinggi aman
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 25),

                // HEADER NAVIGASI
                Row(
                  children: [
                    if (isKirimMode) ...[
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () {
                          // KEMBALI KE MENU AWAL
                          setSheetState(() {
                            isKirimMode = false;
                          });
                        },
                        color: Colors.black87,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 10),
                    ],
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        isKirimMode ? "Metode Kirim" : "Mau Transaksi Apa?",
                        key: ValueKey(isKirimMode),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A237E)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  isKirimMode
                      ? "Pilih cara mengirim saldo ke teman"
                      : "Silakan pilih layanan di bawah",
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 25),

                // LOGIKA TAMPILAN (LANGSUNG DISINI AGAR VARIABEL TERBACA)
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: isKirimMode
                        ?
                        // === TAMPILAN 2: PILIHAN METODE KIRIM ===
                        Row(
                            key: const ValueKey("MenuKirim"),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildVerticalCard(
                                  icon: Icons.qr_code_scanner_rounded,
                                  title: "Scan QR",
                                  color: Colors.orange,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) =>
                                                const QrScanPage()));
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildVerticalCard(
                                  icon: Icons.edit_note_rounded,
                                  title: "Input NIM",
                                  color: Colors.blueAccent,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => InputNimPage(
                                                username: widget.username)));
                                  },
                                ),
                              ),
                            ],
                          )
                        :
                        // === TAMPILAN 1: MENU UTAMA (KIRIM & MINTA) ===
                        Column(
                            key: const ValueKey("MenuUtama"),
                            children: [
                              // TOMBOL 1: KIRIM SALDO
                              _buildPremiumCard(
                                icon: Icons.send_rounded,
                                title: "Kirim Saldo",
                                subtitle: "Transfer ke teman via QR / NIM",
                                color: const Color(0xFFFF5252),
                                onTap: () {
                                  // TRIGGER PINDAH MENU
                                  setSheetState(() {
                                    isKirimMode = true;
                                  });
                                },
                              ),

                              const SizedBox(height: 15),

                              // TOMBOL 2: MINTA SALDO (YANG TADI HILANG)
                              _buildPremiumCard(
                                icon: Icons.qr_code_2_rounded,
                                title: "Minta Saldo",
                                subtitle: "Tampilkan QR Code saya",
                                color: const Color(0xFF43A047),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) => RequestSaldoPage(
                                              username: widget.username,
                                              nim: widget.nim)));
                                },
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  // WIDGET CARD HORIZONTAL
  Widget _buildPremiumCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET CARD VERTIKAL
  Widget _buildVerticalCard(
      {required IconData icon,
      required String title,
      required Color color,
      required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 36),
              ),
              const SizedBox(height: 15),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  // --- NAVIGASI BAWAH ---
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? const Color(0xFF1A237E) : Colors.grey,
                size: 26),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: isSelected ? const Color(0xFF1A237E) : Colors.grey,
                    fontSize: 11,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // List halaman content
    final List<Widget> pages = [
      DashboardPage(
          username: widget.username, saldo: widget.saldo, nim: widget.nim),
      CicilanPage(username: widget.username),
      Container(), // Placeholder tengah
      KasPage(username: widget.username),
      EditProfilePage(
          username: widget.username, email: widget.email, nim: widget.nim),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _showTransactionMenu,
        backgroundColor: const Color(0xFF1A237E),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.swap_horiz, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        height: 70,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home_filled, "Beranda", 0),
            _buildNavItem(Icons.receipt_long, "Cicilan", 1),
            const SizedBox(width: 50),
            _buildNavItem(Icons.monetization_on, "Kas", 3),
            _buildNavItem(Icons.person, "Profil", 4),
          ],
        ),
      ),
    );
  }
}
