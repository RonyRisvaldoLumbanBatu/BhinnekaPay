import 'package:flutter/material.dart';
import 'bayar_split.dart'; // Import halaman baru

class SplitBillListPage extends StatefulWidget {
  const SplitBillListPage({super.key});

  @override
  State<SplitBillListPage> createState() => _SplitBillListPageState();
}

class _SplitBillListPageState extends State<SplitBillListPage> {
  // 1. Data Dummy Awal
  final List<Map<String, dynamic>> _allBills = [
    {"name": "Budiman", "amount": "Rp100.000", "status": "Unpaid", "btn": true},
    {"name": "Angela", "amount": "Rp100.000", "status": "Unpaid", "btn": true},
    {"name": "Jamal", "amount": "Rp100.000", "status": "Unpaid", "btn": true},
    {"name": "Tukiyem", "amount": "Rp50.000", "status": "Paid", "btn": true},
    {"name": "Siti", "amount": "Rp25.000", "status": "Paid", "btn": true},
    {"name": "Rahmat", "amount": "Rp75.000", "status": "Unpaid", "btn": true},
  ];

  // 2. List yang akan ditampilkan (hasil filter)
  List<Map<String, dynamic>> _foundBills = [];

  @override
  void initState() {
    // Awalnya tampilkan semua data
    _foundBills = _allBills;
    super.initState();
  }

  // 3. Fungsi Pencarian
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // Jika kosong, tampilkan semua
      results = _allBills;
    } else {
      // Filter berdasarkan nama (case insensitive)
      results = _allBills
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Refresh UI
    setState(() {
      _foundBills = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Split Bill List"),
        backgroundColor: const Color(0xFF1A237E), // Navy Blue
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // --- SEARCH BAR & TOMBOL NEW BILL ---
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) =>
                            _runFilter(value), // Panggil fungsi filter
                        decoration: InputDecoration(
                          hintText: "Cari Nama...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Navigasi ke Halaman Buat Bill Baru
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreateSplitBillPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700]),
                      child: const Text("Split New Bill",
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                // Header Tabel
                _buildHeaderRow(),
                const Divider(thickness: 2, color: Color(0xFF1A237E)),

                // --- LIST DATA DINAMIS ---
                // Jika data kosong
                if (_foundBills.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Data tidak ditemukan",
                        style: TextStyle(color: Colors.grey)),
                  ),

                // Mapping data ke Widget Row
                ..._foundBills.map((bill) {
                  return _buildUserRow(
                    bill["name"],
                    bill["amount"],
                    bill["status"],
                    bill["btn"],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: const [
          Expanded(
              flex: 2,
              child: Text("Name",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF1A237E)))),
          Expanded(
              flex: 2,
              child: Text("Amount",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF1A237E)))),
          Expanded(
              flex: 1,
              child: Text("Status",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF1A237E)))),
          Expanded(flex: 2, child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildUserRow(
      String name, String amount, String status, bool showBtn) {
    Color statusColor = status == "Paid" ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF1A237E)))),
          Expanded(
              flex: 2,
              child: Text(amount,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87))),
          Expanded(
              flex: 1,
              child: Text(status,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                      fontSize: 12))),
          Expanded(
            flex: 2,
            child: status == "Unpaid"
                ? ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Tagihan dikirim ke $name")));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        padding: const EdgeInsets.symmetric(vertical: 4)),
                    child: const Text("Send Bill",
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                  )
                : const SizedBox(), // Jika Paid, tombol hilang
          ),
        ],
      ),
    );
  }
}
