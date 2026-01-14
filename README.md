# 📱 Bhinneka Pay Mobile

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Status](https://img.shields.io/badge/Status-Development-yellow?style=for-the-badge)

**Bhinneka Pay** adalah aplikasi _fintech_ (teknologi finansial) yang dirancang khusus untuk memenuhi kebutuhan transaksi dan manajemen keuangan mahasiswa di lingkungan **Universitas Satya Terra Bhinneka**.

Aplikasi ini hadir dengan antarmuka yang modern, bersih, dan mudah digunakan, memberikan pengalaman perbankan digital yang seamless bagi para mahasiswa.

---

## ✨ Fitur Unggulan

### 🔐 1. Autentikasi Modern & Dashboard

- **Login & Register**: UI modern dengan validasi real-time.
- **Dashboard Interaktif**: Menampilkan saldo, pemasukan, pengeluaran, dan berita kampus terbaru.
- **Role System**: Mendukung User Mahasiswa, Admin Biro, dan Super Admin.

### 💸 2. Manajemen Keuangan

- **Cicilan Kuliah**: Cek status tagihan SPP, Uang Gedung, dll.
- **Isi Saldo & Transfer**: Simulasi top-up dan kirim saldo antar mahasiswa.
- **Kas Kelas**: Manajemen iuran kelas mingguan/bulanan.
- **Split Bill**: (Coming Soon) Bagi tagihan dengan teman.

---

## 🛠️ Teknologi & Arsitektur

- **Framework**: [Flutter](https://flutter.dev/) (Google UI Toolkit)
- **Bahasa Pemrograman**: Dart
- **Backend**: PHP Native (API)
- **Database**: MySQL
- **Struktur Folder Modular**:
  - `lib/pages/auth`: Halaman Login & Registrasi
  - `lib/pages/home`: Halaman Utama & Dashboard
  - `lib/pages/transaksi`: Fitur Pembayaran & Invoice
  - `lib/pages/fitur`: Modul (Cicilan, Kas, dll)
  - `lib/pages/admin`: Panel Admin
  - `lib/api`: Backend Script (PHP)

---

## 🚀 Cara Menjalankan Aplikasi

1.  **Clone Repository**

    ```bash
    git clone https://github.com/RonyRisvaldoLumbanBatu/BhinnekaPay.git
    cd bhinneka-pay-mobile
    ```

2.  **Setup Backend**

    - Pindahkan folder `api` ke dalam `htdocs` (jika menggunakan XAMPP).
    - Import database `bhinnekapay_db` (jika ada SQL-nya).
    - Sesuaikan `koneksi.php` jika perlu.

3.  **Jalankan Flutter**
    ```bash
    flutter pub get
    flutter run
    ```

---

## 👤 Kontributor

Dikembangkan oleh **Rony Risvaldo Lumban Batu** sebagai bagian dari proyek pengembangan sistem keuangan digital kampus.

_Dibuat dengan ❤️ menggunakan Flutter._
