import 'package:flutter/material.dart';

class LimitPage extends StatelessWidget {
  const LimitPage({super.key});

  @override
  Widget build(BuildContext context) {
    double used = 150000;
    double limit = 2000000;
    double progress = used / limit;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Limit Transaksi",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  const Text("Limit Harian Kamu",
                      style: TextStyle(color: Colors.blueGrey)),
                  const SizedBox(height: 10),
                  const Text("Rp 2.000.000",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E))),
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.white,
                    color: const Color(0xFF1A237E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Terpakai: Rp ${used.toInt()}",
                          style: const TextStyle(fontSize: 12)),
                      Text("Sisa: Rp ${(limit - used).toInt()}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildLimitItem("Transfer ke Sesama", "Rp 50.000.000 / hari"),
            _buildLimitItem("Pembayaran QRIS", "Rp 5.000.000 / transaksi"),
            _buildLimitItem("Tarik Tunai", "Rp 1.000.000 / hari"),
          ],
        ),
      ),
    );
  }

  Widget _buildLimitItem(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Text(value,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }
}
