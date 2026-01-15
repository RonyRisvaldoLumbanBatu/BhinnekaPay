<?php
include 'koneksi.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$username = $_POST['username'] ?? '';

if (empty($username)) {
    echo json_encode(['success' => false, 'message' => 'Username required']);
    exit();
}

// QUERY: Ambil semua transaksi user ini, urutkan dari yang terbaru
$sql = "SELECT * FROM transaksi WHERE username = ? ORDER BY created_at DESC";
$stmt = $connect->prepare($sql);
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode([
    'success' => true,
    'data' => $data
]);

$stmt->close();
$connect->close();
?>