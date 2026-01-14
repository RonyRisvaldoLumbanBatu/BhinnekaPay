import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minibank/pages/transaksi/payment_success_page.dart';

class CicilanPage extends StatelessWidget {
  final String username;
  final String saldo;
  final String email;
  final String? nim;

  const CicilanPage(
      {super.key,
      required this.username,
      required this.saldo,
      this.email = "",
      this.nim});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Cicilan Kuliah",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // HEADER INFO
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF283593), Color(0xFF1A237E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A237E).withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.account_balance_wallet_outlined,
                      color: Colors.white, size: 30),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Total Tanggungan",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 13)),
                      SizedBox(height: 5),
                      Text("Rp 13.500.000",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          const Text("Daftar Tagihan",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E))),
          const SizedBox(height: 15),

          // LIST DAFTAR CICILAN
          _buildBillCard(
            context,
            "Uang Gedung - Tahap 1",
            "20 Des 2025",
            5000000,
            "Lunas",
            Colors.green,
            isPaid: true,
          ),
          _buildBillCard(
            context,
            "SPP Semester 1",
            "10 Jan 2026",
            3500000,
            "Belum Lunas",
            Colors.orange,
          ),
          _buildBillCard(
            context,
            "Uang Gedung - Tahap 2",
            "10 Feb 2026",
            5000000,
            "Belum Lunas",
            Colors.redAccent,
            isLocked: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBillCard(BuildContext context, String title, String date,
      int amount, String status, Color statusColor,
      {bool isPaid = false, bool isLocked = false}) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          print("Card tapped: $title");
          if (isPaid) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Tagihan ini sudah lunas."),
                backgroundColor: Colors.green));
          } else if (isLocked) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Selesaikan tagihan sebelumnya terlebih dahulu."),
                backgroundColor: Colors.redAccent));
          } else {
            // Active state
            _showPaymentDetail(context, title, date, amount);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isLocked ? Colors.grey : Colors.black87)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text("Jatuh Tempo: $date",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(formatter.format(amount),
                        style: TextStyle(
                            color: isLocked
                                ? Colors.grey
                                : const Color(0xFF1A237E),
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isLocked
                          ? Colors.grey[200]
                          : statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      isLocked ? "Belum Tersedia" : status,
                      style: TextStyle(
                          color: isLocked ? Colors.grey : statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                  ),
                  if (!isPaid && !isLocked) ...[
                    const SizedBox(height: 12),
                    const Icon(Icons.arrow_forward_ios,
                        size: 14, color: Color(0xFF1A237E))
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentDetail(
      BuildContext context, String title, String date, int amount) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    int adminFee = 2500;
    int total = amount + adminFee;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle Bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(25),
                children: [
                  const Text("Rincian Pembayaran",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 25),

                  // Detail Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text("Jatuh Tempo: $date",
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                        const Divider(height: 30),
                        _buildDetailRow("Nominal Tagihan", amount),
                        const SizedBox(height: 10),
                        _buildDetailRow("Biaya Admin", adminFee),
                        const Divider(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Pembayaran",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(formatter.format(total),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFF1A237E))),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text("Metode Pembayaran",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  // Payment Method Select (Mock)
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF1A237E)),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFE8EAF6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet,
                            color: Color(0xFF1A237E)),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Bhinneka Pay Balance",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  "Sisa Saldo: $saldo", // <-- Use dynamic saldo
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.check_circle,
                            color: Color(0xFF1A237E)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Button
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5))
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close sheet
                    _showPinDialog(context, total);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text("BAYAR SEKARANG",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, int value) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(formatter.format(value),
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showPinDialog(BuildContext context, int amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Masukkan PIN", textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  "Masukkan 6 digit PIN keamanan untuk konfirmasi pembayaran.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 20),
              // Dummy TextField PIN
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  if (value.length == 6) {
                    Navigator.pop(context); // Close Dialog
                    _processPayment(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _processPayment(BuildContext context) {
    // Show Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Simulate Network Delay
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pop(context); // Close Loading

        // Navigate to Success Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessPage(
              username: username,
              saldo: saldo,
              email: email,
              nim: nim,
            ),
          ),
        );
      }
    });
  }
}
