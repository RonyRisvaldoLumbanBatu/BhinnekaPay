<?php
// MATIKAN ERROR DISPLAY
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include 'koneksi.php';

$input_id = $_POST['username']; // Ini bisa berupa Username atau Email

if (empty($input_id)) {
    echo json_encode(['success' => false, 'message' => 'Username required']);
    exit();
}

// QUERY PINTAR: Cari berdasarkan Username ATAU Email
$query = "SELECT saldo FROM users WHERE username = '$input_id' OR email = '$input_id'";
$result = $connect->query($query);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo json_encode([
        'success' => true,
        'saldo' => $row['saldo']
    ]);
} else {
    echo json_encode(['success' => false, 'message' => 'User not found']);
}
?>