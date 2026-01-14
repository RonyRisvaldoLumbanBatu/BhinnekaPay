import 'package:flutter/material.dart';

class UbahProfilPage extends StatefulWidget {
  final String username;
  final String email;
  final String nim;

  const UbahProfilPage(
      {super.key,
      required this.username,
      required this.email,
      required this.nim});

  @override
  State<UbahProfilPage> createState() => _UbahProfilPageState();
}

class _UbahProfilPageState extends State<UbahProfilPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _nimController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
    _nimController = TextEditingController(text: widget.nim);
    _phoneController =
        TextEditingController(text: "081234567890"); // Dummy No HP
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Ubah Data Diri",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // FOTO PROFIL EDITABLE
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10)
                      ]),
                  child: Center(
                    child: Text(
                      widget.username.isNotEmpty
                          ? widget.username[0].toUpperCase()
                          : "U",
                      style: const TextStyle(fontSize: 40, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Color(0xFF1A237E), shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 20),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),

            _buildTextField("Nama Lengkap", _nameController, Icons.person),
            const SizedBox(height: 15),
            _buildTextField("Nomor Handphone", _phoneController, Icons.phone,
                inputType: TextInputType.phone),
            const SizedBox(height: 15),

            // EMAIL & NIM (READ ONLY)
            _buildTextField("Email Kampus", _emailController, Icons.email,
                isReadOnly: true),
            const SizedBox(height: 15),
            _buildTextField("NIM", _nimController, Icons.badge,
                isReadOnly: true),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Data berhasil diperbarui! (Simulasi)")));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("SIMPAN PERUBAHAN",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool isReadOnly = false, TextInputType inputType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: isReadOnly,
          keyboardType: inputType,
          style: TextStyle(color: isReadOnly ? Colors.grey : Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(icon,
                color: isReadOnly ? Colors.grey : const Color(0xFF1A237E)),
            filled: true,
            fillColor: isReadOnly ? Colors.grey[100] : Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF1A237E), width: 2)),
          ),
        ),
      ],
    );
  }
}
