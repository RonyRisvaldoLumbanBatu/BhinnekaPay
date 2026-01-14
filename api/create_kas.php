<?php
include 'koneksi.php';

$title = $_POST['title']; // Contoh: "Kas Mingguan"
$desc = $_POST['deskripsi']; // Contoh: "Untuk kebersihan"
$nominal = $_POST['nominal']; // Contoh: 5000
$kelas = $_POST['kelas']; // Target: "IF A SR"
$creator = $_POST['creator']; // Username Bendahara

if (empty($title) || empty($nominal) || empty($kelas)) {
    echo json_encode(['success' => false, 'message' => 'Data tidak lengkap']);
    exit();
}

$stmt = $connect->prepare("INSERT INTO kas_items (title, deskripsi, nominal, target_kelas, created_by) VALUES (?, ?, ?, ?, ?)");
$stmt->bind_param("ssdss", $title, $desc, $nominal, $kelas, $creator);

if ($stmt->execute()) {
    echo json_encode(['success' => true, 'message' => 'Tagihan Kas Berhasil Dibuat']);
} else {
    echo json_encode(['success' => false, 'message' => 'Gagal membuat tagihan']);
}
?>