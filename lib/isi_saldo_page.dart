import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'qr_saldo_page.dart'; // Import Halaman QR

class IsiSaldoPage extends StatefulWidget {
  final String username;
  const IsiSaldoPage({super.key, required this.username});

  @override
  State<IsiSaldoPage> createState() => _IsiSaldoPageState();
}

class _IsiSaldoPageState extends State<IsiSaldoPage> {
  final TextEditingController _amountController = TextEditingController();
  final _currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  void _updateAmount(int amount) {
    setState(() {
      _amountController.text = amount.toString();
    });
  }

  void _handleTopUp() {
    String rawAmount = _amountController.text.replaceAll('.', '');
    int? nominal = int.tryParse(rawAmount);

    if (nominal == null || nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan nominal yang valid!")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            QrSaldoPage(nominal: nominal, username: widget.username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cek apakah halaman ini bisa di-pop (artinya dibuka dari dashboard/push)
    bool showBackButton = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // 1. CUSTOM HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(
                20, 50, 20, 25), // Padding atas untuk StatusBar
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF283593)], // Gradasi Navy
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: Row(
              children: [
                // Tombol Back Custom (Kondisional)
                if (showBackButton)
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),

                // Teks Header
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Top Up Saldo",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Isi dana aman lewat Biro Keuangan",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. KONTEN SCROLLABLE
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Mau isi saldo berapa?",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E))),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1), blurRadius: 10)
                      ],
                      border: Border.all(
                          color: const Color(0xFF1A237E).withOpacity(0.1)),
                    ),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E)),
                      decoration: const InputDecoration(
                        prefixText: "Rp ",
                        prefixStyle: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        border: InputBorder.none,
                        hintText: "0",
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // CHIPS
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [50000, 100000, 200000, 500000].map((amount) {
                      return InkWell(
                        onTap: () => _updateAmount(amount),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.05),
                                  blurRadius: 5)
                            ],
                          ),
                          child: Text(
                            _currencyFormatter
                                .format(amount)
                                .replaceAll("Rp ", ""),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A237E)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 40),

                  // METODE PEMBAYARAN
                  const Text("Metode Pembayaran",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E))),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFF1A237E), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFF1A237E).withOpacity(0.1),
                            blurRadius: 15)
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A237E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.storefront_rounded,
                              color: Color(0xFF1A237E), size: 30),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Setor Tunai (Biro Keuangan)",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A237E))),
                              SizedBox(height: 4),
                              Text("Kunjungi loket biro & scan QR.",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        const Icon(Icons.check_circle_rounded,
                            color: Color(0xFF1A237E), size: 28),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // TOMBOL
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _handleTopUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                        shadowColor: const Color(0xFF1A237E).withOpacity(0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("BUAT KODE SETOR TUNAI",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          SizedBox(width: 12),
                          Icon(Icons.qr_code_2_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
