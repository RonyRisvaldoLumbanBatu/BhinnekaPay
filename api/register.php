<?php
// FILE: api/register.php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include 'koneksi.php';

// Terima input dari Flutter
$username = $_POST['username'];
$email = $_POST['email'];
$password = $_POST['password'];

// Validasi Input Sederhana
if (empty($username) || empty($email) || empty($password)) {
    echo json_encode(['success' => false, 'message' => 'Semua kolom wajib diisi!']);
    exit();
}

// 1. CEK DUPLIKAT EMAIL (Biar gak double akun)
$checkQuery = "SELECT * FROM users WHERE email = '$email'";
$checkResult = mysqli_query($connect, $checkQuery);

if (mysqli_num_rows($checkResult) > 0) {
    echo json_encode(['success' => false, 'message' => 'Email ini sudah terdaftar!']);
    exit();
}

// 2. AUTO-GENERATE NIM DARI EMAIL
// Contoh: "2403310101@students.ac.id" -> NIM: "2403310101"
// Kita ambil string sebelum tanda '@'
$emailParts = explode('@', $email);
$nimCandidate = $emailParts[0];

// Pastikan NIM hanya angka (Opsional, tapi bagus untuk validasi)
$nim = preg_match('/^[0-9]+$/', $nimCandidate) ? $nimCandidate : null;

// Jika format email bukan NIM (misal: rony@gmail.com), NIM dikosongkan atau diisi manual jika parameter 'nim' dikirim flutter
if ($nim == null && isset($_POST['nim'])) {
    $nim = $_POST['nim'];
}

// 3. INSERT KE DATABASE
// Default saldo = 0, role = 'student'
$insertQuery = "INSERT INTO users (username, email, password, nim, role, saldo) 
                VALUES ('$username', '$email', '$password', '$nim', 'student', 0)";

if (mysqli_query($connect, $insertQuery)) {
    echo json_encode([
        'success' => true,
        'message' => 'Registrasi Berhasil. Silakan Login.',
        'nim_generated' => $nim // Info balik ke user
    ]);
} else {
    echo json_encode(['success' => false, 'message' => 'Gagal Mendaftar: ' . mysqli_error($connect)]);
}
?>