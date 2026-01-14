import 'package:flutter/material.dart';

class QrScanPage extends StatelessWidget {
  const QrScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Scan QR Code"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // MOCKUP KAMERA
          const Center(
            child: Text("Kamera akan muncul di sini...",
                style: TextStyle(color: Colors.white54)),
          ),

          // FRAME PEMINDAI
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          // TEXT HELPER
          Positioned(
              bottom: 100,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20)),
                child: const Text("Arahkan QR Code ke dalam kotak",
                    style: TextStyle(color: Colors.white)),
              ))
        ],
      ),
    );
  }
}
