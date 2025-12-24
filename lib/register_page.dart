import 'package:flutter/material.dart';
import 'login_page.dart'; // Pastikan import ini ada

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscure = true;
  bool _isObscureConfirm = true; // Toggle khusus untuk konfirmasi password

  // 1. MEMBUAT CONTROLLER UNTUK SEMUA INPUT
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Bersihkan memori saat halaman ditutup
  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E), // 1. Latar Belakang Navy Blue
      body: SafeArea(
        child: Column(
          children: [
            // 2. HEADER (Custom AppBar)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      "Daftar Akun Baru",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                      width: 40), // Penyeimbang biar judul pas di tengah
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 3. KONTEN FORM (Kertas Putih Melengkung)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Lengkapi Data Diri",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Isi formulir di bawah ini untuk mendapatkan akses penuh ke Bhinneka Pay.",
                        style: TextStyle(color: Colors.grey, height: 1.5),
                      ),
                      const SizedBox(height: 30),

                      // FORM INPUT DATA
                      _buildModernTextField("Nama Lengkap",
                          Icons.person_outline, _nameController),
                      const SizedBox(height: 16),
                      _buildModernTextField(
                          "NIM", Icons.badge_outlined, _nimController),
                      const SizedBox(height: 16),
                      _buildModernTextField("Email Kampus",
                          Icons.email_outlined, _emailController),
                      const SizedBox(height: 16),

                      // Password
                      _buildModernPasswordField(
                          "Password", _passwordController, _isObscure, (val) {
                        setState(() => _isObscure = val);
                      }),
                      const SizedBox(height: 16),

                      // Konfirmasi Password
                      _buildModernPasswordField("Konfirmasi Password",
                          _confirmPasswordController, _isObscureConfirm, (val) {
                        setState(() => _isObscureConfirm = val);
                      }),

                      const SizedBox(height: 40),

                      // TOMBOL DAFTAR MODERN
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A237E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          child: const Text("BUAT AKUN",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              )),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Login Link
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: const TextSpan(
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                                children: [
                                  TextSpan(text: "Sudah punya akun? "),
                                  TextSpan(
                                    text: "Login sekarang",
                                    style: TextStyle(
                                        color: Color(0xFF1A237E),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Tambahan spacer bawah
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // LOGIKA REGISTER (Dipisah)
  void _handleRegister() {
    String nama = _nameController.text.trim();
    String nim = _nimController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirm = _confirmPasswordController.text.trim();

    if (nama.isEmpty ||
        nim.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua data wajib diisi!"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Konfirmasi Password tidak cocok!"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Registrasi Berhasil! Silakan Login."),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  // Helper Widget Modern
  Widget _buildModernTextField(
      String label, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A237E),
                fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF1A237E)), // Icon Biru
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintText: "Masukkan $label",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color(0xFF1A237E), width: 2), // Fokus Biru
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernPasswordField(
      String label,
      TextEditingController controller,
      bool isObscureState,
      Function(bool) onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A237E),
                fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscureState,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline,
                color: Color(0xFF1A237E)), // Icon Biru
            suffixIcon: IconButton(
              icon: Icon(
                  isObscureState ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[400]),
              onPressed: () => onToggle(!isObscureState),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintText: "Masukkan $label",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color(0xFF1A237E), width: 2), // Fokus Biru
            ),
          ),
        ),
      ],
    );
  }
}
