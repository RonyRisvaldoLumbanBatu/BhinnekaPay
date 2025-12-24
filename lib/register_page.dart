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
  final TextEditingController _confirmPasswordController = TextEditingController();

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), // Kembali ke Login
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Buat Akun Baru",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Silakan lengkapi data diri Anda untuk mendaftar."),
                const SizedBox(height: 30),

                // 2. PASANG CONTROLLER KE WIDGET
                _buildTextField("Nama Lengkap", Icons.person_outline, _nameController),
                const SizedBox(height: 16),
                _buildTextField("NIM", Icons.badge_outlined, _nimController),
                const SizedBox(height: 16),
                _buildTextField("Email Kampus", Icons.email_outlined, _emailController),
                const SizedBox(height: 16),
                
                // Password
                _buildPasswordField("Password", _passwordController, _isObscure, (val) {
                  setState(() => _isObscure = val);
                }),
                const SizedBox(height: 16),
                
                // Konfirmasi Password
                _buildPasswordField("Konfirmasi Password", _confirmPasswordController, _isObscureConfirm, (val) {
                  setState(() => _isObscureConfirm = val);
                }),

                const SizedBox(height: 30),

                // 3. TOMBOL DAFTAR DENGAN VALIDASI
                ElevatedButton(
                  onPressed: () {
                    // Ambil nilai text
                    String nama = _nameController.text.trim();
                    String nim = _nimController.text.trim();
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();
                    String confirm = _confirmPasswordController.text.trim();

                    // Validasi 1: Cek Kosong
                    if (nama.isEmpty || nim.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Semua data wajib diisi!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return; // Stop proses
                    }

                    // Validasi 2: Cek Password Sama
                    if (password != confirm) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Konfirmasi Password tidak cocok!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return; // Stop proses
                    }

                    // JIKA SUKSES
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Registrasi Berhasil! Silakan Login."),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Arahkan ke Halaman Login (Hapus history register)
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false, 
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("DAFTAR SEKARANG", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Kembali ke halaman Login
                      },
                      child: const Text(
                        "Masuk disini",
                        style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget Text Field dengan Controller
  Widget _buildTextField(String label, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 6),
        TextField(
          controller: controller, // Pasang Controller
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
            filled: true,
            fillColor: Colors.blue[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }

  // Helper Widget Password Field dengan Controller & Toggle Visibility sendiri
  Widget _buildPasswordField(
      String label, 
      TextEditingController controller, 
      bool isObscureState, 
      Function(bool) onToggle
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 6),
        TextField(
          controller: controller, // Pasang Controller
          obscureText: isObscureState,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1A237E)),
            suffixIcon: IconButton(
              icon: Icon(isObscureState ? Icons.visibility_off : Icons.visibility),
              onPressed: () => onToggle(!isObscureState), // Toggle visibility
            ),
            filled: true,
            fillColor: Colors.blue[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }
}