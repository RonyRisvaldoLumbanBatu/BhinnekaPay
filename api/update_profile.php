<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include 'koneksi.php';

// Cek param
$old_username = $_POST['username_old']; // Untuk identifikasi user (WHERE clause)
$new_username = $_POST['username_new'];
$new_phone = $_POST['phone']; // Jika ingin update NO HP juga
$new_kelas = $_POST['kelas']; // <--- FIELD KELAS BARU

if (empty($old_username)) {
    echo json_encode(['success' => false, 'message' => 'User tidak valid']);
    exit();
}

// UPDATE QUERY
// Catatan: Email dan NIM biasanya tidak boleh diubah sembarangan jika jadi Primary ID/Login
// Kita asumsikan update Nama, No HP, dan Kelas
$stmt = $connect->prepare("UPDATE users SET username=?, no_hp=?, kelas=? WHERE username=?");
$stmt->bind_param("ssss", $new_username, $new_phone, $new_kelas, $old_username);

if ($stmt->execute()) {
    echo json_encode(['success' => true, 'message' => 'Profil berhasil diperbarui']);
} else {
    echo json_encode(['success' => false, 'message' => 'Gagal update database']);
}

$stmt->close();
$connect->close();
?>