<?php
include 'koneksi.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$username = $_POST['username'] ?? ''; // Ambil username dari request

if (empty($username)) {
    echo json_encode(['success' => false, 'message' => 'Username required']);
    exit;
}

// 1. HITUNG PEMASUKAN
$sql_in = "SELECT SUM(amount) as total FROM transaksi WHERE username = '$username' AND type = 'IN'";
$result_in = $connect->query($sql_in);
$row_in = $result_in->fetch_assoc();
$pemasukan = $row_in['total'] ?? 0;

// 2. HITUNG PENGELUARAN
$sql_out = "SELECT SUM(amount) as total FROM transaksi WHERE username = '$username' AND type = 'OUT'";
$result_out = $connect->query($sql_out);
$row_out = $result_out->fetch_assoc();
$pengeluaran = $row_out['total'] ?? 0;

// 3. AMBIL BERITA (LIMIT 3)
$berita = [];
$sql_news = "SELECT * FROM berita ORDER BY id DESC LIMIT 3";
$result_news = $connect->query($sql_news);

if ($result_news->num_rows > 0) {
    while ($row = $result_news->fetch_assoc()) {
        $berita[] = $row;
    }
}

// KIRIM HASIL
echo json_encode([
    'success' => true,
    'pemasukan' => $pemasukan,
    'pengeluaran' => $pengeluaran,
    'berita' => $berita
]);
?>