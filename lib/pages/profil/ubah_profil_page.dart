import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'dart:convert';
import 'package:minibank/pages/auth/login_page.dart'; // Untuk logout setelah update (opsional)

class UbahProfilPage extends StatefulWidget {
  final String username;
  final String email;
  final String nim;
  final String kelas;

  const UbahProfilPage({
    super.key,
    required this.username,
    required this.email,
    required this.nim,
    this.kelas = "-",
  });

  @override
  State<UbahProfilPage> createState() => _UbahProfilPageState();
}

class _UbahProfilPageState extends State<UbahProfilPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _nimController;
  late TextEditingController _phoneController;
  late TextEditingController _kelasController; // <-- CONTROLLER KELAS

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
    _nimController = TextEditingController(text: widget.nim);
    _phoneController = TextEditingController(
      text: "081234567890",
    ); // Dummy No HP (Nanti bisa ambil dari DB)
    _kelasController = TextEditingController(
      text: widget.kelas == "-" ? "" : widget.kelas,
    );
  }

  Future<void> _handleUpdate() async {
    setState(() => _isLoading = true);

    // API URL
    String baseUrl = kIsWeb
        ? 'http://localhost/api/update_profile.php'
        : 'http://192.168.18.10/api/update_profile.php';

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'username_old': widget.username, // KUNCI WHERE (harus valid)
          'username_new': _nameController.text, // Nama Baru
          'phone': _phoneController.text,
          'kelas': _kelasController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Data berhasil diperbarui! Silakan Login Ulang."),
              backgroundColor: Colors.green,
            ),
          );

          // Redirect ke Login karena data sensitif (Username) berubah
          // Atau pop saja jika backend support token (disini kita simpel login ulang)
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        } else {
          _showError(data['message'] ?? "Gagal update profile");
        }
      } else {
        _showError("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Kesalahan koneksi: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Ubah Data Diri",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
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
                      color: Color(0xFF1A237E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            _buildTextField("Nama Lengkap", _nameController, Icons.person),
            const SizedBox(height: 15),

            // INPUT KELAS (BARU)
            _buildTextField(
              "Kelas",
              _kelasController,
              Icons.class_outlined,
              hint: "Contoh: TI 3A",
            ),
            const SizedBox(height: 15),

            _buildTextField(
              "Nomor Handphone",
              _phoneController,
              Icons.phone,
              inputType: TextInputType.phone,
            ),
            const SizedBox(height: 15),

            // EMAIL & NIM (READ ONLY)
            _buildTextField(
              "Email Kampus",
              _emailController,
              Icons.email,
              isReadOnly: true,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              "NIM",
              _nimController,
              Icons.badge,
              isReadOnly: true,
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "SIMPAN PERUBAHAN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isReadOnly = false,
    TextInputType inputType = TextInputType.text,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: isReadOnly,
          keyboardType: inputType,
          style: TextStyle(color: isReadOnly ? Colors.grey : Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: isReadOnly ? Colors.grey : const Color(0xFF1A237E),
            ),
            filled: true,
            fillColor: isReadOnly ? Colors.grey[100] : Colors.white,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
