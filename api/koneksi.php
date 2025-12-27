<?php
// MATIKAN SEMUA ERROR DISPLAY (Supaya JSON bersih)
error_reporting(0);
ini_set('display_errors', 0);

// HEADER CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");

// Tangani Pre-flight Request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

$host = "localhost";
$user = "root";
$pass = "";
$db = "bhinnekapay_db";

$connect = new mysqli($host, $user, $pass, $db);

if ($connect->connect_error) {
    // Return JSON error kalau koneksi DB gagal
    die(json_encode(['success' => false, 'message' => 'DB Connection Failed: ' . $connect->connect_error]));
}

header("Content-Type: application/json");
?>