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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Tampilan Tablet/Web
            return Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(40),
                      child: _buildLoginForm(context),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: _buildImageSection(),
                ),
              ],
            );
          } else {
            // Tampilan Mobile
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: _buildImageSection(isMobile: true),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildLoginForm(context),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Bagian Form Login
  Widget _buildLoginForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Login",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E), // Navy Blue
          ),
        ),
        const SizedBox(height: 8),
        Text("Masuk ke akun Bhinneka Pay Anda.", style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 32),

        // Input Email
        _buildTextField("Email Address", Icons.email_outlined, _emailController),
        const SizedBox(height: 20),
        
        // Input Password
        _buildPasswordField(),
        
        const SizedBox(height: 10),
        
        // Ingat Saya & Lupa Password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  activeColor: const Color(0xFF1A237E),
                  onChanged: (val) => setState(() => _rememberMe = val!),
                ),
                const Text("Ingat Saya"),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Lupa Password?", style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold)),
            )
          ],
        ),
        
        const SizedBox(height: 20),
        
        // --- TOMBOL LOGIN (DIPERBAIKI) ---
        ElevatedButton(
          onPressed: () {
            // Ambil text dari input
            String email = _emailController.text.trim();
            String password = _passwordController.text.trim();

            // 1. Validasi Input Kosong
            if (email.isEmpty || password.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Email dan Password wajib diisi!"),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              // 2. Logika Mengambil Username dari Email
              // Misal: rafli@gmail.com -> Menjadi "Rafli"
              String username = "User";
              if (email.contains('@')) {
                String rawName = email.split('@')[0];
                // Membuat huruf pertama besar (Capitalize)
                if (rawName.isNotEmpty) {
                   username = rawName[0].toUpperCase() + rawName.substring(1);
                }
              } else {
                username = email;
              }

              // 3. Navigasi ke MainPage dengan Mengirim Username
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(username: username), // Kirim data di sini
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A237E),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("MASUK", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),

        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Belum punya akun? "),
            GestureDetector(
              onTap: () {
                // Navigasi ke Halaman Register
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text(
                "Daftar Sekarang",
                style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      ],
    );
  }

  // Bagian Gambar Samping/Atas
  Widget _buildImageSection({bool isMobile = false}) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E),
        image: DecorationImage(
          // Pastikan file 'assets/ustb.jpeg' sudah didaftarkan di pubspec.yaml
          image: AssetImage("assets/ustb.jpeg"), 
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               if (!isMobile) ...[
                 const Icon(Icons.account_balance_wallet, size: 80, color: Colors.amber),
                 const SizedBox(height: 20),
               ],
               RichText(
                 textAlign: TextAlign.center,
                 text: const TextSpan(
                   style: TextStyle(fontSize: 28, fontFamily: 'Serif', color: Colors.white, height: 1.2),
                   children: [
                     TextSpan(text: "Kelola "),
                     TextSpan(text: "KEUANGAN", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                     TextSpan(text: " Mahasiswa\ndengan Lebih Mudah."),
                   ],
                 ),
               ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        const SizedBox(height: 8),
        TextField(
          controller: controller, // Controller dipasang
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Password", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController, // Controller dipasang
          obscureText: _isObscure,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _isObscure = !_isObscure),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}