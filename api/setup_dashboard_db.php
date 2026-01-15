<?php
include 'koneksi.php';

// Buat Tabel Transaksi jika belum ada
$sql = "CREATE TABLE IF NOT EXISTS transaksi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    type ENUM('IN', 'OUT') NOT NULL, -- IN = Pemasukan, OUT = Pengeluaran
    amount DECIMAL(15,2) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";

if ($connect->query($sql) === TRUE) {
    echo "Tabel transaksi berhasil dibuat/sudah ada.<br>";
} else {
    echo "Error creating table: " . $connect->error . "<br>";
}
?>