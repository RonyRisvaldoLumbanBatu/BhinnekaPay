<?php
include 'koneksi.php';

// HAPUS SEMUA DATA BERITA
$sql = "TRUNCATE TABLE berita";

if ($connect->query($sql) === TRUE) {
    echo "<h3>SUKSES! Semua data berita sudah dihapus.</h3>";
    echo "Sekarang Info Terbaru di aplikasi akan kosong.";
} else {
    echo "Gagal menghapus: " . $connect->error;
}
?>