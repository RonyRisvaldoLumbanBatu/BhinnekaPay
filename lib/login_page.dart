import 'package:flutter/material.dart';
import 'register_page.dart';
import 'main_page.dart'; // Pastikan import ini ada

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  bool _rememberMe = false;

  // 1. MEMBUAT CONTROLLER
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Membersihkan memori
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF1A237E), // Latar belakang utama Navy Blue
      body: Stack(
        children: [
          // 1. BAGIAN BACKGROUND ATAS (Header dengan Gambar Kampus Samar)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 400, // Tinggi area background
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Layer 1: Gambar Kampus
                Image.asset(
                  "assets/ustb.jpeg", // Pastikan path ini benar
                  fit: BoxFit.cover,
                ),
                // Layer 2: Overlay Biru Navy (Supaya teks tetap terbaca jelas)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF1A237E)
                            .withOpacity(0.85), // Biru atas agak transparan
                        const Color(0xFF1A237E)
                            .withOpacity(0.95), // Biru bawah makin pekat
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // KONTEN HEADER (Icon & Teks)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Column(
                children: [
                  // Logo Icon (Bisa diganti gambar logo png nanti)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance_wallet,
                        size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "BHINNEKA PAY",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Solusi Keuangan Mahasiswa",
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ),

          // Hiasan Lingkaran Abstrak di Background
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. BAGIAN FORM (Kertas Putih Melengkung)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height *
                  0.70, // Mengisi 70% layar bawah
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, -5))
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Selamat Datang!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      Text(
                        "Silakan masuk untuk melanjutkan.",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Input Email
                      _buildModernTextField(
                          label: "Email Address",
                          icon: Icons.email_outlined,
                          controller: _emailController),

                      const SizedBox(height: 20),

                      // Input Password
                      _buildModernPasswordField(),

                      const SizedBox(height: 10),

                      // Remember Me & Forgot Pass
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.9,
                                child: Checkbox(
                                  value: _rememberMe,
                                  activeColor: const Color(0xFF1A237E),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  onChanged: (val) =>
                                      setState(() => _rememberMe = val!),
                                ),
                              ),
                              Text("Ingat Saya",
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 13)),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("Lupa Password?",
                                style: TextStyle(
                                  color: Color(0xFF1A237E),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                )),
                          )
                        ],
                      ),

                      const SizedBox(height: 25),

                      // TOMBOL MASUK MODERN
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF1A237E), // Navy Blue
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            shadowColor:
                                const Color(0xFF1A237E).withOpacity(0.4),
                          ),
                          child: const Text("MASUK",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              )),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Register Link
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            );
                          },
                          child: RichText(
                            text: const TextSpan(
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                              children: [
                                TextSpan(text: "Belum punya akun? "),
                                TextSpan(
                                  text: "Daftar Sekarang",
                                  style: TextStyle(
                                      color: Color(0xFF1A237E),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // LOGIKA LOGIN (Dipisah biar rapi)
  void _handleLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Opps! Email dan Password belum diisi."),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      String username = "User";
      if (email.contains('@')) {
        String rawName = email.split('@')[0];
        if (rawName.isNotEmpty) {
          username = rawName[0].toUpperCase() + rawName.substring(1);
        }
      } else {
        username = email;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(username: username),
        ),
      );
    }
  }

  // WIDGET INPUT MODERN (Dengan Focus Biru)
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
                fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
            filled: true,
            fillColor: Colors.grey[100], // Background abu
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintText: "Masukkan $label",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),

            // Border saat diam (Tidak ada garis)
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent),
            ),

            // Border saat DIKLIK/FOKUS (Garis Biru Navy Tebal)
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
                fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _isObscure,
          decoration: InputDecoration(
            prefixIcon:
                const Icon(Icons.lock_outline, color: Color(0xFF1A237E)),
            suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[400]),
              onPressed: () => setState(() => _isObscure = !_isObscure),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintText: "Masukkan Password",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent),
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
