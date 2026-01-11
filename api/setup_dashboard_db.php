<?php
include 'koneksi.php';

// 1. BUAT TABEL TRANSAKSI
$sql_transaksi = "CREATE TABLE IF NOT EXISTS transaksi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    type ENUM('IN', 'OUT'),
    amount DECIMAL(15,2),
    description VARCHAR(255),
    date DATETIME DEFAULT CURRENT_TIMESTAMP
)";

if ($connect->query($sql_transaksi) === TRUE) {
    echo "Tabel 'transaksi' siap.<br>";
} else {
    echo "Error tabel transaksi: " . $connect->error . "<br>";
}

// 2. BUAT TABEL BERITA (INFO TERBARU)
$sql_berita = "CREATE TABLE IF NOT EXISTS berita (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    subtitle VARCHAR(100),
    date_text VARCHAR(50),
    type VARCHAR(20) -- 'calendar' atau 'notification'
)";

if ($connect->query($sql_berita) === TRUE) {
    echo "Tabel 'berita' siap.<br>";
} else {
    echo "Error tabel berita: " . $connect->error . "<br>";
}

// 3. ISI DATA DUMMY (HANYA JIKA KOSONG)
// Cek Transaksi
$check = $connect->query("SELECT * FROM transaksi LIMIT 1");
if ($check->num_rows == 0) {
    // Masukkan data contoh untuk Rony
    $connect->query("INSERT INTO transaksi (username, type, amount, description) VALUES ('RonyRisvaldoLumbanBatu', 'IN', 1500000, 'Kiriman Orang Tua')");
    $connect->query("INSERT INTO transaksi (username, type, amount, description) VALUES ('RonyRisvaldoLumbanBatu', 'OUT', 50000, 'Beli Pulsa')");
    $connect->query("INSERT INTO transaksi (username, type, amount, description) VALUES ('RonyRisvaldoLumbanBatu', 'OUT', 120000, 'Bayar Kas Kelas')");
    $connect->query("INSERT INTO transaksi (username, type, amount, description) VALUES ('RonyRisvaldoLumbanBatu', 'OUT', 15000, 'Makan Siang')");
    echo "Data dummy transaksi ditambahkan.<br>";
}

// Cek Berita (KITA KOSONGKAN DULU SESUAI PERMINTAAN)
/* 
$checkNews = $connect->query("SELECT * FROM berita LIMIT 1");
if ($checkNews->num_rows == 0) {
   // Data dummy dinonaktifkan
} 
*/
echo "Data dummy berita TIDAK ditambahkan (Kosong).<br>";

echo "<h3>SELESAI! Database Dashboard Siap Digunakan.</h3>";
?>