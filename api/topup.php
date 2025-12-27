<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include 'koneksi.php';

// Terima Data
$username = $_POST['username'];
$amount = $_POST['amount'];

if (empty($username) || empty($amount)) {
    echo json_encode(['success' => false, 'message' => 'Data tidak lengkap']);
    exit();
}

// 1. Ambil Saldo Sekarang
$query = "SELECT saldo FROM users WHERE username = '$username'";
$result = $connect->query($query);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $saldo_awal = $row['saldo'];

    // 2. Hitung Saldo Baru
    $saldo_baru = $saldo_awal + $amount;

    // 3. Update Database
    $update = "UPDATE users SET saldo = '$saldo_baru' WHERE username = '$username'";

    if ($connect->query($update) === TRUE) {
        echo json_encode([
            'success' => true,
            'message' => 'Top Up Berhasil',
            'saldo_baru' => $saldo_baru
        ]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Gagal Update Database']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'User tidak ditemukan']);
}
?>