import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'bukti_kas_page.dart'; // Pastikan import ini ada

class KasPage extends StatefulWidget {
  // 1. TAMBAHKAN VARIABLE INI
  final String username;

  // 2. TAMBAHKAN DI KONSTRUKTOR (required this.username)
  const KasPage({super.key, required this.username});

  @override
  State<KasPage> createState() => _KasPageState();
}

class _KasPageState extends State<KasPage> {
  int _selectedWeeks = 1;
  final int _pricePerWeek = 10000;
  XFile? _selectedImage;

  String _formatRupiah(int number) {
    return "Rp${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Ambil dari Galeri'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil dari Kamera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalBayar = _selectedWeeks * _pricePerWeek;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bayar Kas Kelas"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFE3F2FD),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF1A237E),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              child: const Text("Bayar Kas Kelas",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE3F2FD),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
              ),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 2,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Periode Minggu:",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _selectedWeeks,
                            isExpanded: true,
                            items: [1, 2, 3, 4, 5, 8, 12].map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text("$e Minggu",
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                )).toList(),
                            onChanged: (v) {
                              setState(() {
                                _selectedWeeks = v!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Tagihan:", style: TextStyle(color: Colors.black54)),
                            Text(
                              _formatRupiah(totalBayar),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A237E)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text("Upload Bukti Transfer:",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                      const SizedBox(height: 8),
                      
                      if (_selectedImage != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _showImageSourceOptions,
                          icon: Icon(_selectedImage == null ? Icons.cloud_upload : Icons.edit, size: 18),
                          label: Text(_selectedImage == null ? "Unggah Bukti Bayar" : "Ganti Foto"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A237E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.centerLeft),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // TOMBOL BAYAR
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_selectedImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Harap upload bukti transfer dulu!"))
                              );
                              return;
                            }
                            
                            // Navigasi ke Halaman Bukti Kas
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BuktiKasPage(
                                  totalBayar: totalBayar,
                                  jumlahMinggu: _selectedWeeks,
                                  imagePath: _selectedImage!.path,
                                  // 3. TERUSKAN USERNAME KE BUKTI KAS PAGE
                                  // Menggunakan 'widget.username' karena variabel ada di class induk
                                  username: widget.username, 
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("BAYAR SEKARANG", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}