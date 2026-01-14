<?php
include 'koneksi.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$nim = $_POST['nim'] ?? '';

if (empty($nim)) {
    echo json_encode(['success' => false, 'message' => 'NIM wajib diisi']);
    exit();
}

// QUERY: Cari split bill dimana user ini terdaftar sebagai anggota
// Kita Join header (split_bills) dengan detail (split_bill_members)
// Group by split_bill_id agar tidak duplikat jika ada logika lain, tapi disini distinct cukup
// Kita juga perlu hitung jumlah anggota per bill

$sql = "
    SELECT 
        sb.id, 
        sb.title, 
        sb.total_amount, 
        sb.created_at, 
        sb.status,
        sbm.payment_status, -- Status bayar user ini
        sbm.amount as my_share, -- Beban user ini
        (SELECT COUNT(*) FROM split_bill_members WHERE split_bill_id = sb.id) as total_users
    FROM split_bills sb
    JOIN split_bill_members sbm ON sb.id = sbm.split_bill_id
    WHERE sbm.user_nim = ?
    ORDER BY sb.created_at DESC
";

$stmt = $connect->prepare($sql);
$stmt->bind_param("s", $nim);
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