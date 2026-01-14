import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class ModelUser {
  final String nim;
  final String nama;
  ModelUser({required this.nim, required this.nama});
}

class CreateSplitBillPage extends StatefulWidget {
  final String creatorUsername;
  final String creatorNim;

  const CreateSplitBillPage(
      {super.key, required this.creatorUsername, required this.creatorNim});

  @override
  State<CreateSplitBillPage> createState() => _CreateSplitBillPageState();
}

class _CreateSplitBillPageState extends State<CreateSplitBillPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _nimFriendController = TextEditingController();

  List<ModelUser> _members = []; // List teman yang diajak
  bool _isLoading = false;

  // Format Rupiah
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    // Otomatis masukkan Creator ke list member (opsional, tapi biasanya creator ikut bayar)
    _members.add(ModelUser(
        nim: widget.creatorNim, nama: "${widget.creatorUsername} (Saya)"));
  }

  // --- CEK NIM TEMAN ---
  Future<void> _checkNimToAdd() async {
    String nimToCheck = _nimFriendController.text.trim();
    if (nimToCheck.isEmpty) return;

    // Cek duplikat
    if (_members.any((m) => m.nim == nimToCheck)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Teman sudah ada di list!")));
      return;
    }

    setState(() => _isLoading = true);

    String baseUrl = kIsWeb
        ? 'http://localhost/api/cek_user.php'
        : 'http://192.168.18.10/api/cek_user.php';

    try {
      final response =
          await http.post(Uri.parse(baseUrl), body: {'nim': nimToCheck});
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        // Ketemu!
        setState(() {
          _members.add(ModelUser(nim: nimToCheck, nama: data['username']));
          _nimFriendController.clear();
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("NIM tidak ditemukan")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Gagal koneksi")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- HITUNG DAN SUBMIT ---
  Future<void> _submitSplitBill() async {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Judul dan Total Biaya wajib diisi")));
      return;
    }

    if (_members.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Minimal ada 1 orang!")));
      return;
    }

    setState(() => _isLoading = true);

    double totalAmount = double.tryParse(_amountController.text) ?? 0;
    double amountPerPerson = totalAmount / _members.length;

    // Siapkan JSON Peserta
    List<Map<String, dynamic>> membersJson = _members.map((m) {
      return {"nim": m.nim, "name": m.nama, "amount": amountPerPerson};
    }).toList();

    String baseUrl = kIsWeb
        ? 'http://localhost/api/create_split_bill.php'
        : 'http://192.168.18.10/api/create_split_bill.php';

    try {
      final response = await http.post(Uri.parse(baseUrl), body: {
        'title': _titleController.text,
        'total_amount': totalAmount.toString(),
        'creator_nim': widget.creatorNim,
        'members': jsonEncode(membersJson)
      });

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        if (!mounted) return;
        Navigator.pop(context); // Balik ke List
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Split Bill Berhasil Dibuat!"),
            backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message'] ?? "Gagal"),
            backgroundColor: Colors.red));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hitung Preview
    double total = double.tryParse(_amountController.text) ?? 0;
    double perPerson = _members.isNotEmpty ? total / _members.length : 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Buat Split Bill"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. INFO UTAMA
            const Text("Detail Tagihan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: "Judul (Misal: Makan Bakso)",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.title)),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: (val) => setState(() {}), // Refresh kalkulasi realtime
              decoration: InputDecoration(
                  labelText: "Total Biaya (Rp)",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.monetization_on)),
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1),
            const SizedBox(height: 10),

            // 2. TAMBAH TEMAN
            const Text("Siapa yang patungan?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nimFriendController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Masukkan NIM Teman",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isLoading ? null : _checkNimToAdd,
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(14),
                      backgroundColor: const Color(0xFF1A237E)),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.person_add, color: Colors.white),
                )
              ],
            ),

            // 3. LIST PESERTA
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final m = _members[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Text(m.nama[0],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E))),
                  ),
                  title: Text(m.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(m.nim),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _members.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 4. RINGKASAN
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Per Orang Bayar:",
                      style: TextStyle(fontSize: 14)),
                  Text(formatter.format(perPerson),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E))),
                ],
              ),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitSplitBill,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text("BUAT TAGIHAN",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
