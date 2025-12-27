<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include 'koneksi.php';

// MAGIC TRICK: Terima parameter COMPATIBILITY MODE
// Jika 'username' ada, pakai itu. Jika tidak ada, cek apakah 'email' ada.
$input_id = isset($_POST['username']) ? $_POST['username'] : (isset($_POST['email']) ? $_POST['email'] : '');
$password = $_POST['password'];

if (!$connect) {
    echo json_encode(['success' => false, 'message' => 'Database Error']);
    exit();
}

$query_sql = "SELECT * FROM users WHERE (username = '$input_id' OR email = '$input_id') AND password = '$password'";
$result = mysqli_query($connect, $query_sql);

if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    echo json_encode([
        'success' => true,
        'message' => 'Login Berhasil',
        'username' => $row['username'],
        'saldo' => $row['saldo'],
        'role' => $row['role']
    ]);
} else {
    echo json_encode(['success' => false, 'message' => 'Username atau Password Salah']);
}
?>