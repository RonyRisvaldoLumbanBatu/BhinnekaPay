<?php
// FILE: api/delete_rony.php
header("Access-Control-Allow-Origin: *");
include 'koneksi.php';

// Target yang mau dihapus (Data Lama)
$target_user = "Rony";
$target_email = "rony@gmail.com";

$sql = "DELETE FROM users WHERE username = '$target_user' OR email = '$target_email'";

if ($connect->query($sql) === TRUE) {
    if ($connect->affected_rows > 0) {
        echo "<h1>✅ BERHASIL!</h1>";
        echo "<p>Akun User <b>'$target_user'</b> / <b>'$target_email'</b> sudah dihapus dari Database.</p>";
        echo "<p>Silakan buka Aplikasi Bhinneka Pay dan DAFTAR BARU sekarang.</p>";
    } else {
        echo "<h1>⚠️ DATA TIDAK DITEMUKAN</h1>";
        echo "<p>Sepertinya akun Rony sudah tidak ada. Aman untuk daftar baru.</p>";
    }
} else {
    echo "Error deleting record: " . $connect->error;
}
?>