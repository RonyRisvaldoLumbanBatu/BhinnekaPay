import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'dart:convert';
import 'package:minibank/pages/fitur/buat_kas_page.dart';

class KasPage extends StatefulWidget {
  final String username;
  final String kelas;
  final String roleKelas;
  final String nim;

  const KasPage({
    super.key,
    required this.username,
    required this.kelas,
    required this.roleKelas,
    required this.nim,
  });

  @override
  State<KasPage> createState() => _KasPageState();
}

class _KasPageState extends State<KasPage> {
  List<dynamic> _kasList = [];
  bool _isLoading = true;
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _fetchKasData();
  }

  Future<void> _fetchKasData() async {
    setState(() => _isLoading = true);

    String baseUrl = kIsWeb
        ? 'http://localhost/api/get_kas.php'
        : 'http://192.168.18.10/api/get_kas.php';

    try {
      final response = await http.post(Uri.parse(baseUrl),
          body: {'kelas': widget.kelas, 'nim': widget.nim});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _kasList = data['data'];
          });
        }
      }
    } catch (e) {
      print("Error fetching kas: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handlePay(String kasId, int nominal, String title) async {
    // KONFIRMASI PEMBAYARAN
    bool confirm = await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Konfirmasi Bayar"),
                  content: Text(
                      "Bayar $title seharga ${formatter.format(nominal)}?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text("Batal")),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A237E)),
                        child: const Text("Bayar",
                            style: TextStyle(color: Colors.white)))
                  ],
                )) ??
        false;

    if (!confirm) return;

    // PROSES BAYAR
    String baseUrl = kIsWeb
        ? 'http://localhost/api/pay_kas.php'
        : 'http://192.168.18.10/api/pay_kas.php';

    try {
      final response = await http.post(Uri.parse(baseUrl), body: {
        'kas_id': kasId,
        'nim': widget.nim,
        'nama': widget.username,
        'nominal': nominal.toString()
      });

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Pembayaran Berhasil!"),
            backgroundColor: Colors.green));
        _fetchKasData(); // Refresh Data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message']), backgroundColor: Colors.red));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Gagal koneksi server"), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isBendahara = widget.roleKelas.toLowerCase() == 'bendahara';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
            "Kas ${widget.kelas == '-' ? '(Belum ada kelas)' : widget.kelas}",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchKasData,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _kasList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_outlined,
                          size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text("Belum ada tagihan kas",
                          style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _kasList.length,
                  separatorBuilder: (c, i) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final item = _kasList[index];
                    final bool isPaid = item['is_paid'] == true ||
                        item['is_paid'] == 1; // Flexible check
                    final int nominal =
                        int.tryParse(item['nominal'].toString()) ?? 0;

                    return _buildKasCard(item['id'].toString(), item['title'],
                        item['deskripsi'] ?? "Mingguan", nominal, isPaid);
                  },
                ),
      floatingActionButton: isBendahara
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => BuatKasPage(
                            username: widget.username, kelas: widget.kelas)));
                _fetchKasData(); // Refresh setelah buat
              },
              heroTag: "btn_buat_kas",
              backgroundColor: const Color(0xFF1A237E),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Buat Tagihan",
                  style: TextStyle(color: Colors.white)),
            )
          : null,
    );
  }

  Widget _buildKasCard(
      String id, String title, String type, int amount, bool isPaid) {
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
                onPressed: isPaid ? null : () => _handlePay(id, amount, title),
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
