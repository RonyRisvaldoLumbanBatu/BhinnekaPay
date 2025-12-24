import 'package:flutter/material.dart';
import 'login_page.dart'; 
// Pastikan import ini ada

void main() {
  runApp(const BhinnekaPayApp());
}

class BhinnekaPayApp extends StatelessWidget {
  const BhinnekaPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bhinneka Pay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1A237E),
        scaffoldBackgroundColor: const Color(0xFFE3F2FD),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFFFC107),
        ),
      ),
      // SET HOMEPAGE MENJADI LOGIN PAGE
      home: const LoginPage(),
    );
  }
}