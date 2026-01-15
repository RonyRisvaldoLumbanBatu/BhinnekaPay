<?php
include 'koneksi.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$kas_id = $_POST['kas_id'];
$nim = $_POST['nim'];
$nama = $_POST['nama'];
$nominal = $_POST['nominal'];
$username = $_POST['username'] ?? ''; // PERLU USERNAME untuk log transaksi

// Jika username tidak dikirim, kita cari dari NIM
if (empty($username)) {
    $q_user = mysqli_query($connect, "SELECT username FROM users WHERE nim = '$nim'");
    if ($r_user = mysqli_fetch_assoc($q_user)) {
        $username = $r_user['username'];
    }
}

// 1. CEK SALDO USER
$cek_saldo = mysqli_query($connect, "SELECT saldo FROM users WHERE nim = '$nim'");
$data_user = mysqli_fetch_assoc($cek_saldo);
$saldo_sekarang = $data_user['saldo'];

if ($saldo_sekarang < $nominal) {
    echo json_encode(['success' => false, 'message' => 'Saldo tidak cukup!']);
    exit();
}

// 2. KURANGI SALDO
$saldo_baru = $saldo_sekarang - $nominal;
mysqli_query($connect, "UPDATE users SET saldo = '$saldo_baru' WHERE nim = '$nim'");

// 3. CATAT PEMBAYARAN DI TABEL KAS
$stmt = $connect->prepare("INSERT INTO kas_payments (kas_item_id, user_nim, user_nama, nominal_bayar) VALUES (?, ?, ?, ?)");
$stmt->bind_param("isss", $kas_id, $nim, $nama, $nominal);

if ($stmt->execute()) {

    // --- LOG TRANSAKSI (OUT) ---
    if (!empty($username)) {
        $desc = "Bayar Kas";
        $stmt_log = $connect->prepare("INSERT INTO transaksi (username, type, amount, description) VALUES (?, 'OUT', ?, ?)");
        $stmt_log->bind_param("sds", $username, $nominal, $desc);
        $stmt_log->execute();
        $stmt_log->close();
    }
    // ---------------------------

    echo json_encode(['success' => true, 'message' => 'Pembayaran Berhasil!']);
} else {
    echo json_encode(['success' => false, 'message' => 'Gagal mencatat pembayaran']);
}
?>