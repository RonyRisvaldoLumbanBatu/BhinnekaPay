import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'dart:convert';

class BuatKasPage extends StatefulWidget {
  final String username;
  final String kelas;

  const BuatKasPage({super.key, required this.username, required this.kelas});

  @override
  State<BuatKasPage> createState() => _BuatKasPageState();
}

class _BuatKasPageState extends State<BuatKasPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _nominalController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitKas() async {
    if (_titleController.text.isEmpty || _nominalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Judul dan Nominal wajib diisi!")));
      return;
    }

    setState(() => _isLoading = true);

    String baseUrl = kIsWeb
        ? 'http://localhost/api/create_kas.php'
        : 'http://192.168.18.10/api/create_kas.php';

    try {
      final response = await http.post(Uri.parse(baseUrl), body: {
        'title': _titleController.text,
        'deskripsi': _descController.text,
        'nominal': _nominalController.text,
        'kelas': widget.kelas,
        'creator': widget.username
      });

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        if (!mounted) return;
        Navigator.pop(context); // Kembali ke list
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Tagihan Berhasil Dibuat!"),
            backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message'] ?? "Gagal"),
            backgroundColor: Colors.red));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error koneksi server"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Tagihan Kas"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Buat tagihan baru untuk kelas:",
                style: TextStyle(color: Colors.grey)),
            Text(widget.kelas,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E))),
            const SizedBox(height: 30),
            _buildInput("Judul Tagihan", "Contoh: Kas Kebersihan Minggu 1",
                _titleController),
            const SizedBox(height: 15),
            _buildInput("Deskripsi (Opsional)",
                "Contoh: Bayar paling lambat Jumat", _descController),
            const SizedBox(height: 15),
            _buildInput("Nominal (Rp)", "Contoh: 5000", _nominalController,
                isNumber: true),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitKas,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("BUAT TAGIHAN",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
      String label, String hint, TextEditingController controller,
      {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
              hintText: hint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
        ),
      ],
    );
  }
}
