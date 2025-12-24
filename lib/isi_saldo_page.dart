import 'package:flutter/material.dart';
import 'qr_saldo_page.dart';

class IsiSaldoPage extends StatefulWidget {
  final String username; // Variabel username dari Dashboard/MainPage
  
  const IsiSaldoPage({super.key, required this.username});

  @override
  State<IsiSaldoPage> createState() => _IsiSaldoPageState();
}

class _IsiSaldoPageState extends State<IsiSaldoPage> {
  // Variabel untuk menyimpan input angka mentah (string)
  String _inputAmount = "";

  // Fungsi untuk menangani tekanan tombol keypad
  void _onKeyTap(String value) {
    setState(() {
      if (value == '⌫') {
        if (_inputAmount.isNotEmpty) {
          _inputAmount = _inputAmount.substring(0, _inputAmount.length - 1);
        }
      } else if (value == '000') {
        if (_inputAmount.isNotEmpty) {
          _inputAmount += '000';
        }
      } else {
        if (_inputAmount.isEmpty && value == '0') {
          return;
        }
        if (_inputAmount.length < 12) {
          _inputAmount += value;
        }
      }
    });
  }

  // Fungsi helper format Rupiah
  String _getFormattedAmount() {
    if (_inputAmount.isEmpty) return "Rp0";
    String price = _inputAmount.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return "Rp$price";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""), // Kosongkan judul
        backgroundColor: Colors.transparent, 
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Jumlah Isi Saldo", style: TextStyle(color: Colors.grey)),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    color: Colors.blue[50],
                    child: Text(
                      _getFormattedAmount(),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text("Biaya Admin: Rp1.500", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const Divider(height: 30),

                  const Center(child: Text("Cara isi Saldo", style: TextStyle(fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  _buildStep("Tentukan jumlah isi saldo"),
                  _buildStep("Tunjukkan kode bayar ke Admin"),
                  _buildStep("Saldo akan diterima maks. 24 jam"),

                  const SizedBox(height: 20),

                  // Simple Keypad Layout
                  Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        _buildKeypadRow(['1', '2', '3']),
                        _buildKeypadRow(['4', '5', '6']),
                        _buildKeypadRow(['7', '8', '9']),
                        _buildKeypadRow(['0', '000', '⌫']),
                        const SizedBox(height: 10),
                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Validasi: Pastikan tidak kosong dan lebih dari 0
                              if (_inputAmount.isNotEmpty && int.parse(_inputAmount) > 0) {
                                
                                // --- PERBAIKAN DI SINI ---
                                // Mengirim username ke QrSaldoPage
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => QrSaldoPage(
                                      inputNominal: _inputAmount,
                                      username: widget.username, // <--- PENTING: Kirim username
                                    )
                                  )
                                );
                                // -------------------------

                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Masukkan jumlah saldo terlebih dahulu")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A237E), // Navy
                              foregroundColor: Colors.white
                            ),
                            child: const Text("LANJUT"),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => TextButton(
        onPressed: () => _onKeyTap(key),
        child: Text(
          key, 
          style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)
        ),
      )).toList(),
    );
  }
}