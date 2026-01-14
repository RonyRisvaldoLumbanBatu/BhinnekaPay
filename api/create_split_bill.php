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

// Terima Data
$title = $_POST['title'] ?? '';
$total_amount = $_POST['total_amount'] ?? 0;
$creator_nim = $_POST['creator_nim'] ?? '';
$members_json = $_POST['members'] ?? '[]';

if (empty($title) || empty($creator_nim) || empty($members_json)) {
    echo json_encode(['success' => false, 'message' => 'Data tidak lengkap']);
    exit();
}

$members = json_decode($members_json, true);
if (json_last_error() !== JSON_ERROR_NONE || empty($members)) {
    echo json_encode(['success' => false, 'message' => 'Format data anggota salah']);
    exit();
}

// Mulai Transaksi
$connect->begin_transaction(); // FIXED: use $connect instead of $conn

try {
    // 1. Insert ke HEADER (split_bills)
    $stmt1 = $connect->prepare("INSERT INTO split_bills (title, total_amount, creator_nim) VALUES (?, ?, ?)");
    $stmt1->bind_param("sds", $title, $total_amount, $creator_nim);

    if (!$stmt1->execute()) {
        throw new Exception("Gagal membuat header tagihan");
    }

    $split_bill_id = $connect->insert_id;
    $stmt1->close();

    // 2. Insert ke MEMBERS (split_bill_members)
    $stmt2 = $connect->prepare("INSERT INTO split_bill_members (split_bill_id, user_nim, user_name, amount, payment_status) VALUES (?, ?, ?, ?, ?)");

    foreach ($members as $member) {
        $m_nim = $member['nim'];
        $m_name = $member['name'];
        $m_amount = $member['amount'];
        $m_status = ($m_nim === $creator_nim) ? 'paid' : 'pending';

        $stmt2->bind_param("issds", $split_bill_id, $m_nim, $m_name, $m_amount, $m_status);

        if (!$stmt2->execute()) {
            throw new Exception("Gagal menambahkan anggota: " . $m_name);
        }
    }
    $stmt2->close();

    // Commit transaksi
    $connect->commit();
    echo json_encode(['success' => true, 'message' => 'Split Bill Berhasil Dibuat!']);

} catch (Exception $e) {
    $connect->rollback();
    echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
}

$connect->close(); // FIXED: use $connect
?>