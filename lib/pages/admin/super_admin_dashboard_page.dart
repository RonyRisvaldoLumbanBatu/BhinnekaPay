import 'package:flutter/material.dart';

class SuperAdminDashboardPage extends StatefulWidget {
  const SuperAdminDashboardPage({super.key});

  @override
  State<SuperAdminDashboardPage> createState() =>
      _SuperAdminDashboardPageState();
}

class _SuperAdminDashboardPageState extends State<SuperAdminDashboardPage> {
  bool _isMaintenanceMode = false;
  bool _isServerOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Super Admin Control",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(
            0xFF212121), // Hitam/Gelap untuk Super Admin (Beda dari Navy)
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.power_settings_new, color: Colors.redAccent),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER SERVER STATUS
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF212121), // Dark Header
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isServerOnline
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _isServerOnline ? Colors.green : Colors.red),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle,
                              size: 12,
                              color:
                                  _isServerOnline ? Colors.green : Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            _isServerOnline
                                ? "SYSTEM ONLINE"
                                : "SYSTEM OFFLINE",
                            style: TextStyle(
                              color: _isServerOnline
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Server Load / Database",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "CPU: 12%  |  RAM: 2.4GB  |  DB: OK",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 2. MAINTENANCE SWITCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1), blurRadius: 10)
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle),
                      child:
                          const Icon(Icons.build_circle, color: Colors.orange),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Maintenance Mode",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(
                            _isMaintenanceMode
                                ? "Aplikasi SEDANG Maintenance"
                                : "Aplikasi Dapat Diakses User",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isMaintenanceMode,
                      activeColor: Colors.orange,
                      onChanged: (val) {
                        setState(() => _isMaintenanceMode = val);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(val
                                  ? "Mode Maintenance AKTIF!"
                                  : "Mode Maintenance NON-AKTIF!")),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 3. MENU MANAJEMEN GRID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Manajemen Sistem",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const SizedBox(height: 15),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.3,
                    children: [
                      _buildMenuCard(Icons.admin_panel_settings, "Kelola Admin",
                          "Tambah/Hapus Petugas", Colors.indigo, () {}),
                      _buildMenuCard(Icons.people_alt, "Data User",
                          "Semua Mahasiswa", Colors.blue, () {}),
                      _buildMenuCard(Icons.storage, "Database",
                          "Backup & Restore", Colors.teal, () {}),
                      _buildMenuCard(Icons.bug_report, "Error Logs",
                          "Cek Kendala Sistem", Colors.red, () {}),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Spasi bawah
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(IconData icon, String title, String subtitle,
      Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
