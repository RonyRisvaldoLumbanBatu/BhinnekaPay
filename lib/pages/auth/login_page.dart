import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Untuk cek kIsWeb
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:minibank/pages/auth/register_page.dart';
import 'package:minibank/pages/home/main_page.dart'; // User Biasa
import 'package:minibank/pages/admin/admin_main_page.dart'; // Admin Biro
import 'package:minibank/pages/admin/super_admin_dashboard_page.dart'; // Super Admin

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Variabel ukuran
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // bool isMobile = width < 600; // Tidak dipakai, hapus biar clean

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            // 1. HEADER NAVY MEWAH (Background + Dekorasi)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: height * 0.45,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1A237E), // Navy Blue Base
                  image: DecorationImage(
                    image: AssetImage("assets/ustb.jpeg"),
                    fit: BoxFit.cover,
                    opacity:
                        0.4, // Gambar dibuat agak transparan biar teks jelas
                  ),
                ),
                child: Container(
                  // Gradient Overlay biar makin elegan
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF1A237E).withOpacity(0.8),
                        const Color(0xFF0D47A1).withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // DEKORASI LINGKARAN ABSTRAK (Hiasan)
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 100,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // KONTEN HEADER (Logo & Teks)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: height * 0.40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white30, width: 2),
                    ),
                    child: const Icon(Icons.account_balance_wallet_rounded,
                        size: 48, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "BHINNEKA PAY",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4))
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Solusi Keuangan Mahasiswa",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          letterSpacing: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            // 2. FORM LOGIN (Bottom Sheet Style)
            Positioned(
              top: height * 0.38, // Naik sedikit menutupi header
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, -10))
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "Selamat Datang!",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E)),
                      ),
                      const Text(
                        "Silakan masuk dengan akun Anda.",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 30),

                      // INPUT EMAIL
                      _buildModernTextField(
                        label: "Email Kampus",
                        icon: Icons.email_outlined,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),

                      // INPUT PASSWORD
                      _buildModernPasswordField(),

                      // OPSI TAMBAHAN (Updated: Pakai Wrap biar responsif)
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (val) =>
                                    setState(() => _rememberMe = val!),
                                activeColor: const Color(0xFF1A237E),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                              const Text("Ingat Saya",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black54)),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("Lupa Password?",
                                style: TextStyle(
                                    color: Color(0xFF1A237E),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),

                      // TOMBOL LOGIN
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A237E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 8,
                            shadowColor:
                                const Color(0xFF1A237E).withOpacity(0.4),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text("MASUK SEKARANG",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 1)),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // DAFTAR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Belum punya akun? ",
                              style: TextStyle(color: Colors.grey[600])),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterPage())),
                            child: const Text("Daftar Sekarang",
                                style: TextStyle(
                                    color: Color(0xFF1A237E),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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

  // LOGIKA LOGIN (Updated dengan Loading State & Get Saldo)
  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack("Email dan Password wajib diisi!", isError: true);
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Logic URL Dinamis (Updated IP Laptop)
      String baseUrl = kIsWeb
          ? 'http://localhost/api/login.php'
          : 'http://192.168.18.10/api/login.php';

      final response = await http.post(
        Uri.parse(baseUrl),
        body: {"username": email, "password": password},
      ).timeout(const Duration(seconds: 10)); // Timeout

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          // --- SUKSES ---
          final role = data['role'];
          final username = data['username'];
          final email = data['email'] ?? ""; // Ambil Email
          final nim = data['nim']; // Ambil NIM
          final kelas = data['kelas'] ?? "-"; // Ambil Kelas (DEFAULT "-")
          final rawSaldo = double.tryParse(data['saldo'].toString()) ?? 0.0;
          final saldo = rawSaldo.toInt();

          if (!mounted) return;

          Widget destination;
          if (role == 'superadmin') {
            destination = const SuperAdminDashboardPage();
          } else if (role == 'admin') {
            destination = AdminMainPage(adminName: username);
          } else {
            // PASSING Data ke Main Page
            destination = MainPage(
              username: username,
              saldo: saldo.toString(),
              email: email,
              nim: nim,
              kelas: kelas, // <--- PASSING KELAS
              roleKelas: data['role_kelas'] ??
                  "anggota", // <--- PASSING ROLE KELAS (FIXED)
            );
          }

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => destination));
        } else {
          // --- GAGAL (Salah Password) ---
          _showSnack(data['message'] ?? "Login Gagal", isError: true);
        }
      } else {
        _showSnack("Error Server: ${response.statusCode}", isError: true);
      }
    } catch (e) {
      _showSnack("Terjadi kesalahan koneksi", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // WIDGET TEXT FIELD
  Widget _buildModernTextField(
      {required String label,
      required IconData icon,
      required TextEditingController controller}) {
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
            prefixIcon: Icon(icon, color: const Color(0xFF1A237E), size: 22),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintText: "Masukkan $label",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),

            // Border saat diam
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent),
            ),

            // Border saat FOKUS (Biru Navy)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Password",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A237E),
                fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _isObscure,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline_rounded,
                color: Color(0xFF1A237E), size: 22),
            suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[400], size: 20),
              onPressed: () => setState(() => _isObscure = !_isObscure),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintText: "Masukkan Password",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),

            // Border saat diam
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent),
            ),

            // Border saat FOKUS (Biru Navy)
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
