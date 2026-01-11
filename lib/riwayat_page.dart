import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // DATA DUMMY TRANSAKSI (Biar terlihat seperti E-Wallet beneran)
    final List<Map<String, dynamic>> transactions = [
      {
        "title": "Top Up Saldo",
        "date": "Hari ini, 10:30",
        "amount": 50000,
        "type": "in", // Masuk
      },
      {
        "title": "Ayam Geprek Kantin",
        "date": "Hari ini, 12:15",
        "amount": -15000,
        "type": "out", // Keluar
      },
      {
        "title": "Print Makalah",
        "date": "Kemarin, 09:00",
        "amount": -5000,
        "type": "out",
      },
      {
        "title": "Top Up Saldo",
        "date": "20 Des 2025",
        "amount": 100000,
        "type": "in",
      },
      {
        "title": "Bayar Kas Kelas",
        "date": "18 Des 2025",
        "amount": -20000,
        "type": "out",
      },
    ];

    // Format Rupiah
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Latar abu muda
      appBar: AppBar(
        title: const Text("Riwayat Transaksi",
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = transactions[index];
          final isIncome = item['type'] == 'in';

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: index == 0
                  ? [
                      // Efek bayangan cuma di item pertama biar unik
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                    ]
                  : null,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isIncome ? Colors.green.shade50 : Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isIncome ? Colors.green : Colors.red,
                  size: 20,
                ),
              ),
              title: Text(
                item['title'],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: Text(
                item['date'],
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              trailing: Text(
                currencyFormatter
                    .format(item['amount'])
                    .replaceAll("-", ""), // Hapus minus manual biar rapi
                style: TextStyle(
                  color: isIncome ? Colors.green[700] : Colors.red[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
