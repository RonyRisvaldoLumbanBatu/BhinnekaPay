<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

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

        // --- LOG TRANSAKSI (IN) ---
        $desc = "Top Up Saldo";
        $stmt_log = $connect->prepare("INSERT INTO transaksi (username, type, amount, description) VALUES (?, 'IN', ?, ?)");
        $stmt_log->bind_param("sds", $username, $amount, $desc);
        $stmt_log->execute();
        $stmt_log->close();
        // --------------------------

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