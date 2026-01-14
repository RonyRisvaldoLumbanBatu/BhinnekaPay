import 'package:flutter/material.dart';

class CreateSplitBillPage extends StatelessWidget {
  const CreateSplitBillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Tagihan Baru"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Detail Tagihan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
            const SizedBox(height: 20),
            
            // Input Nama Tagihan
            TextField(
              decoration: InputDecoration(
                labelText: "Nama Tagihan (Contoh: Makan Siang)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 16),

            // Input Total Nominal
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Total Nominal (Rp)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 16),

            // Input Jumlah Orang
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Jumlah Orang",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.group),
              ),
            ),
            const SizedBox(height: 30),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Logika simpan (sementara hanya kembali)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tagihan berhasil dibuat!")),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("BAGIKAN TAGIHAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}