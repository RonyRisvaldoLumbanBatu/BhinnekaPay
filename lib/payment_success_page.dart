import 'package:flutter/material.dart';
import 'pdf_invoice_page.dart';
import 'main_page.dart';

class PaymentSuccessPage extends StatelessWidget {
  // 1. Snapshot waktu transaksi
  final DateTime transactionTime = DateTime.now();
  
  // 2. Tambahkan variable username (agar bisa balik ke MainPage)
  final String username; // <--- PERBAIKAN 1: Tambahkan ini

  // 3. Wajibkan di konstruktor (Hapus const karena DateTime.now())
  PaymentSuccessPage({super.key, required this.username}); // <--- PERBAIKAN 2: Tambahkan required

  // Helper format Tanggal
  String _formatDateTime(DateTime time) {
    List<String> namaHari = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
    ];
    List<String> namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    String hari = namaHari[time.weekday - 1];
    String bulan = namaBulan[time.month - 1];
    String jam = time.hour.toString().padLeft(2, '0');
    String menit = time.minute.toString().padLeft(2, '0');
    
    return "$hari, ${time.day} $bulan ${time.year} pukul $jam:$menit";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text("Invoice"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // KARTU UTAMA
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  // Header Hijau
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    color: const Color(0xFF00C853),
                    child: Column(
                      children: const [
                        Icon(Icons.check_circle_outline, size: 64, color: Colors.white),
                        SizedBox(height: 12),
                        Text(
                          "Pembayaran Berhasil!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Transaksi Anda telah berhasil diproses",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Info Invoice Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Digital Report", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text("No. Invoice", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                Text("INV/2025/10/30/2334", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                        const Text("Laporan Pembayaran Cicilan", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 16),

                        // --- TANGGAL (STATIS) ---
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Tanggal & Waktu", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatDateTime(transactionTime), 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Text("Status Pembayaran", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                  SizedBox(height: 4),
                                  Text("• Berhasil", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Ringkasan Pembayaran
                        const Text("Ringkasan Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: [
                              _buildRow("Tagihan Per Minggu", "Rp 225.000"),
                              const Divider(),
                              _buildRow("Jumlah Minggu", "2 Minggu"),
                              const Divider(),
                              _buildRow("Total Dibayar", "Rp 450.000", isBold: true, color: Colors.blue),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Detail Tagihan
                        const Text("Detail Tagihan", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: [
                              _buildRow("Baju PDH", "Rp. 10.000/minggu", isSmall: true),
                              _buildRow("Uang Kuliah", "Rp 145.000/minggu", isSmall: true),
                              _buildRow("Uang Sertifikasi MOS", "Rp 50.000/minggu", isSmall: true),
                              _buildRow("Uang UPM", "Rp 20.000/minggu", isSmall: true),
                              const Divider(),
                              _buildRow("Subtotal per minggu", "Rp 225.000", isBold: true),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Metode Pembayaran
                        const Text("Metode Pembayaran", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF304FFE), Color(0xFF536DFE)]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("Bhinneka Pay", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  Text("Virtual Account", style: TextStyle(color: Colors.white70, fontSize: 10)),
                                ],
                              ),
                              const Text("2403310133", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Aksi Kecil
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               _buildActionButton(Icons.download, "Download", const Color(0xFF304FFE), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // KIRIM USERNAME KE SINI
                    builder: (context) => PdfInvoicePage(username: username) 
                  ),
                );
              }),
                const SizedBox(width: 8),
                _buildActionButton(Icons.print, "Print", Colors.grey[800]!, () {}),
                const SizedBox(width: 8),
                _buildActionButton(Icons.share, "Share", Colors.blue, () {}),
              ],
            ),
            const SizedBox(height: 16),

            // Tombol Kembali ke Dashboard
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    // PERBAIKAN 3: Kirim balik username ke MainPage
                    MaterialPageRoute(builder: (context) => MainPage(username: username)),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Kembali ke Beranda"),
              ),
            ),
            const SizedBox(height: 20),

            // Footer Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                border: Border.all(color: Colors.amber.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Simpan laporan ini sebagai bukti pembayaran yang sah.",
                style: TextStyle(fontSize: 10, color: Colors.brown),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget Helper
  Widget _buildRow(String label, String value, {bool isBold = false, Color? color, bool isSmall = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isSmall ? 12 : 14, color: Colors.grey[700])),
          Text(value, style: TextStyle(fontSize: isSmall ? 12 : 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color ?? Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}