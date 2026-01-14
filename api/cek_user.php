<?php
include 'koneksi.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// --- TAMBAHAN PENTING UNTUK FLUTTER WEB (CORS PREFLIGHT) ---
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$nim = $_POST['nim'] ?? '';

if (empty($nim)) {
    echo json_encode(['success' => false, 'message' => 'NIM wajib diisi']);
    exit();
}

// Cek User database
$sql = "SELECT username FROM users WHERE nim = ?";
$stmt = $connect->prepare($sql);
$stmt->bind_param("s", $nim);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode([
        'success' => true,
        'username' => $row['username']
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'User tidak ditemukan'
    ]);
}

$stmt->close();
$connect->close();
?>