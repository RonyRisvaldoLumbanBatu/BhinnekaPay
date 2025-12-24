import 'package:flutter/material.dart';
import 'package:minibank/main_page.dart';

class PdfInvoicePage extends StatelessWidget {
  // 1. Simpan waktu saat halaman Invoice dibuka (Snapshot)
  final DateTime transactionTime = DateTime.now();
  
  // 2. Tambahkan variable username (agar bisa balik ke MainPage)
  final String username; // <--- PERBAIKAN 1: Tambahkan ini

  // 3. Wajibkan di konstruktor (Hapus const karena DateTime.now())
  PdfInvoicePage({super.key, required this.username}); // <--- PERBAIKAN 2: Tambahkan required

  // --- HELPER FORMAT TANGGAL (MANUAL - INDONESIA) ---
  String _formatSimpleDate(DateTime time) {
    return "${time.day}/${time.month}/${time.year}";
  }

  String _formatDetailedDate(DateTime time) {
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

    return "$hari, ${time.day} $bulan ${time.year}\npukul $jam.$menit";
  }

  String _formatFooterDate(DateTime time) {
    String jam = time.hour.toString().padLeft(2, '0');
    String menit = time.minute.toString().padLeft(2, '0');
    String detik = time.second.toString().padLeft(2, '0');
    return "${time.day}/${time.month}/${time.year}, $jam.$menit.$detik";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background kertas putih
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Bhinneka Pay",
                        style: TextStyle(
                          color: Color(0xFF304FFE), // Purple/Blue
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text("Laporan Pembayaran Digital", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text("LUNAS", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              
              // TANGGAL HEADER (DINAMIS)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Tanggal: ${_formatSimpleDate(transactionTime)}", 
                  style: const TextStyle(fontSize: 12)
                ),
              ),
              
              const Divider(thickness: 2, color: Color(0xFF304FFE)),
              const SizedBox(height: 20),

              // --- INFORMASI PEMBAYARAN (2 KOLOM) ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kolom Kiri
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Informasi Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        _buildInfoText("No. Invoice:", "INV/${transactionTime.year}/${transactionTime.month}/${transactionTime.day}/1875"), // Contoh No Invoice Dinamis
                        const SizedBox(height: 8),
                        
                        // TANGGAL BODY (DINAMIS)
                        _buildInfoText("Tanggal:", _formatDetailedDate(transactionTime)),
                        
                        const SizedBox(height: 8),
                        _buildInfoRowColored("Status:", "Berhasil", Colors.green),
                      ],
                    ),
                  ),
                  // Kolom Kanan
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        _buildInfoText("Platform:", "Bhinneka Pay"),
                        const SizedBox(height: 8),
                        _buildInfoText("Tipe:", "Virtual Account"),
                        const SizedBox(height: 8),
                        _buildInfoText("No. Rekening:", "•••• 4532"),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- RINGKASAN PEMBAYARAN ---
              const Text("Ringkasan Pembayaran", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow("Tagihan Per Minggu", "Rp 225.000"),
                    const Divider(),
                    _buildSummaryRow("Jumlah Minggu", "2 Minggu"),
                    const Divider(),
                    _buildSummaryRow("Total Dibayar", "Rp 450.000", isPrimary: true),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- RINCIAN TAGIHAN ---
              const Text("Rincian Tagihan", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              const Divider(),
              _buildTableRow("Keterangan", "Jumlah", isHeader: true),
              const Divider(),
              _buildTableRow("Baju PDH", "Rp. 10.000/minggu"),
              _buildTableRow("Uang Kuliah", "Rp 145.000/minggu"),
              _buildTableRow("Uang Sertifikasi MOS", "Rp 50.000/minggu"),
              _buildTableRow("Uang UPM", "Rp 20.000/minggu"),
              const Divider(),
              _buildTableRow("Subtotal per minggu", "Rp 225.000", isBold: true),
              const SizedBox(height: 30),

              // --- DISCLAIMER ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  border: Border.all(color: Colors.amber),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "Dokumen ini merupakan bukti pembayaran yang sah dan dihasilkan secara otomatis oleh sistem. Tidak diperlukan tanda tangan basah.",
                  style: TextStyle(fontSize: 11, color: Colors.black87, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 20),

              // --- FOOTER & TANGGAL CETAK ---
              Center(
                child: Column(
                  children: [
                    const Text("Bhinneka Pay - Sistem Pembayaran Digital", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    // TANGGAL FOOTER (DINAMIS)
                    Text("Dokumen ini dicetak pada: ${_formatFooterDate(transactionTime)}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // --- TOMBOL AKSI ---
              Row(
                children: [
                  // 1. TOMBOL KEMBALI (MERAH) - Pop biasa
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); 
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Tutup", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  
                  const SizedBox(width: 16),

                  // 2. TOMBOL KE BERANDA (BIRU) - PushAndRemoveUntil
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                         // PERBAIKAN 3: Kirim balik username ke MainPage
                         Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage(username: username)), 
                          (route) => false, 
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF304FFE),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Ke Beranda", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER (Tetap Sama) ---

  Widget _buildInfoText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInfoRowColored(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(
            value, 
            style: TextStyle(
              fontSize: 13, 
              fontWeight: FontWeight.bold,
              color: isPrimary ? const Color(0xFF304FFE) : Colors.black
            )
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(String col1, String col2, {bool isHeader = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            col1, 
            style: TextStyle(
              fontWeight: (isHeader || isBold) ? FontWeight.bold : FontWeight.normal,
              fontSize: 13
            )
          ),
          Text(
            col2, 
            style: TextStyle(
              fontWeight: (isHeader || isBold) ? FontWeight.bold : FontWeight.normal,
              fontSize: 13
            )
          ),
        ],
      ),
    );
  }
}