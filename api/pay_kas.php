<?php
include 'koneksi.php';

$kas_id = $_POST['kas_id'];
$nim = $_POST['nim'];
$nama = $_POST['nama'];
$nominal = $_POST['nominal'];

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
    echo json_encode(['success' => true, 'message' => 'Pembayaran Berhasil!']);
} else {
    echo json_encode(['success' => false, 'message' => 'Gagal mencatat pembayaran']);
}
?>