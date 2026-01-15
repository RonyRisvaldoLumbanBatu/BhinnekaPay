import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart'; // kIsWeb

class RiwayatPage extends StatefulWidget {
  final String username;

  const RiwayatPage({super.key, required this.username});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<dynamic> _transactions = [];
  bool _isLoading = true;
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    setState(() => _isLoading = true);

    String baseUrl = kIsWeb
        ? 'http://localhost/api/get_transactions.php'
        : 'http://192.168.18.10/api/get_transactions.php';

    try {
      final response = await http
          .post(Uri.parse(baseUrl), body: {'username': widget.username});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _transactions = data['data'];
          });
        }
      }
    } catch (e) {
      print("Error fetching transactions: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Riwayat Transaksi",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _fetchTransactions,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text("Belum ada riwayat transaksi",
                          style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    final item = _transactions[index];
                    final bool isIncome = item['type'] == 'IN';
                    final double amount =
                        double.parse(item['amount'].toString());
                    final String date = item['created_at'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 10)
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isIncome
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isIncome
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: isIncome ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['description'] ?? "Transaksi",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(date,
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12)),
                              ],
                            ),
                          ),
                          Text(
                            (isIncome ? "+ " : "- ") + formatter.format(amount),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isIncome ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
