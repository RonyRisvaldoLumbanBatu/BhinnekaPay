import 'package:flutter/material.dart';
import 'main_page.dart';
import 'payment_success_page.dart';

class CicilanPage extends StatelessWidget {
  // 1. Add username variable to pass back to MainPage
  final String username;

  // 2. Require it in the constructor
  const CicilanPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bayar Cicilan"),
        backgroundColor: const Color(0xFF1A237E), // Navy Blue
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFE3F2FD), // Light Blue Background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Blue inside Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A237E),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: const Text(
                  "Bayar Cicilan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Section: Bill & Amount
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Tagihan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text("Rp225.000/minggu", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Jumlah Bayar:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text("Rp450.000", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Divider(thickness: 1), 
                    const SizedBox(height: 10),

                    // Detail Bill Section
                    const Text("Detail Tagihan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)),
                    const SizedBox(height: 10),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50], // Light grey
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow("Baju PDH :", "10.000/minggu"),
                          _buildDetailRow("Uang Kuliah :", "145.000/minggu"),
                          _buildDetailRow("Uang Sertifikasi MOS :", "50.000/minggu"),
                          _buildDetailRow("Uang UPM :", "20.000/minggu"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Action Buttons Section
                    Row(
                      children: [
                        // Pay Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to Payment Success Page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // --- FIX: Pass 'username' here ---
                                  builder: (context) => PaymentSuccessPage(username: username), 
                                ), 
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A237E), // Navy Blue
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            child: const Text("Bayar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Back Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // 3. FIX: Pass username back to MainPage
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => MainPage(username: username)),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Red
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            child: const Text("Kembali", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for Detail Row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13)),
        ],
      ),
    );
  }
}