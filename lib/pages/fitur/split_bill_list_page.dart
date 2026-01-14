import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:minibank/pages/fitur/create_split_bill_page.dart';

class SplitBillListPage extends StatefulWidget {
  final String username;
  final String nim;

  const SplitBillListPage(
      {super.key, required this.username, required this.nim});

  @override
  State<SplitBillListPage> createState() => _SplitBillListPageState();
}

class _SplitBillListPageState extends State<SplitBillListPage> {
  List<dynamic> _bills = [];
  bool _isLoading = true;

  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _fetchBills();
  }

  Future<void> _fetchBills() async {
    setState(() => _isLoading = true);

    String baseUrl = kIsWeb
        ? 'http://localhost/api/get_my_bills.php'
        : 'http://192.168.18.10/api/get_my_bills.php';

    try {
      final response =
          await http.post(Uri.parse(baseUrl), body: {'nim': widget.nim});
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        setState(() {
          _bills = data['data'];
        });
      }
    } catch (e) {
      print("Error fetch bills: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Split Bill",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _fetchBills,
            icon: const Icon(Icons.refresh, color: Colors.white),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "btn_split_bill",
        onPressed: () async {
          // Navigasi & Refresh saat kembali
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => CreateSplitBillPage(
                      creatorUsername: widget.username,
                      creatorNim: widget.nim)));
          _fetchBills();
        },
        backgroundColor: const Color(0xFF1A237E),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Buat Baru", style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bills.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long,
                          size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text("Belum ada tagihan",
                          style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _bills.length,
                  itemBuilder: (context, index) {
                    final item = _bills[index];
                    final double amount = item['total_amount'] != null
                        ? double.parse(item['total_amount'].toString())
                        : 0;
                    // Status user ini (paid/pending)
                    final bool isMyPartPaid = item['payment_status'] == 'paid';
                    // Jika ingin menampilkan status 'Selesai' hanya jika SEMUA anggota lunas, logicnya harus di backend yang cek.
                    // Disini kita tampilkan status pembayaran USER INI saja dulu.

                    return _buildSplitCard(
                        item['title'],
                        item['created_at'],
                        amount,
                        int.parse(item['total_users'].toString()),
                        isMyPartPaid);
                  },
                ),
    );
  }

  Widget _buildSplitCard(
      String title, String date, double total, int members, bool isPaid) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10)
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(date,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isPaid
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPaid ? "Lunas" : "Belum Bayar",
                  style: TextStyle(
                      color: isPaid ? Colors.green : Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.people_outline,
                      size: 18, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text("$members Orang",
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
              Text(formatter.format(total),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1A237E))),
            ],
          )
        ],
      ),
    );
  }
}
