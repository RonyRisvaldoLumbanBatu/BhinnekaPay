import 'package:flutter/material.dart';

class KeamananPage extends StatefulWidget {
  const KeamananPage({super.key});

  @override
  State<KeamananPage> createState() => _KeamananPageState();
}

class _KeamananPageState extends State<KeamananPage> {
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Keamanan Akun",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: const [
                  Icon(Icons.lock_clock, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(
                          "Ubah password secara berkala untuk menjaga keamanan akun Anda.",
                          style: TextStyle(
                              color: Colors.deepOrange, fontSize: 13))),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildPassField("Password Lama", _obscureOld,
                (val) => setState(() => _obscureOld = val)),
            const SizedBox(height: 20),
            _buildPassField("Password Baru", _obscureNew,
                (val) => setState(() => _obscureNew = val)),
            const SizedBox(height: 20),
            _buildPassField("Konfirmasi Password Baru", _obscureConfirm,
                (val) => setState(() => _obscureConfirm = val)),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Password berhasil diubah! (Simulasi)")));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("UBAH PASSWORD",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPassField(
      String label, bool isObscure, Function(bool) onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          obscureText: isObscure,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => onToggle(!isObscure),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              hintText: "Masukkan $label"),
        ),
      ],
    );
  }
}
