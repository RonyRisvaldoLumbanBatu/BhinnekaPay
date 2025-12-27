import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KasPage extends StatelessWidget {
  final String username;
  const KasPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Kas & Iuran",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildKasCard("Kas Kelas SI-1A", "Mingguan", 5000, true),
          const SizedBox(height: 15),
          _buildKasCard("Kas Himpunan Mahasiswa", "Bulanan", 20000, false),
          const SizedBox(height: 15),
          _buildKasCard("Donasi Bencana Alam", "Sukarela", 0, false),
        ],
      ),
    );
  }

  Widget _buildKasCard(String title, String type, int amount, bool isPaid) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle),
                    child:
                        const Icon(Icons.monetization_on, color: Colors.blue),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(type,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  )
                ],
              ),
              if (isPaid) const Icon(Icons.check_circle, color: Colors.green)
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(amount > 0 ? formatter.format(amount) : "Nominal Bebas",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1A237E))),
              ElevatedButton(
                onPressed: isPaid ? null : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isPaid ? Colors.grey[300] : const Color(0xFF1A237E),
                  foregroundColor: isPaid ? Colors.grey : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(isPaid ? "SUDAH BAYAR" : "BAYAR"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
