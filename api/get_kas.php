<?php
include 'koneksi.php';

$kelas = $_POST['kelas'];
$nim_user = $_POST['nim'];

if (empty($kelas) || empty($nim_user)) {
    echo json_encode(['success' => false, 'message' => 'Kelas & NIM wajib diisi']);
    exit();
}

// AMBIL SEMUA TAGIHAN UNTUK KELAS INI
$query = "SELECT * FROM kas_items WHERE target_kelas = '$kelas' ORDER BY created_at DESC";
$result = mysqli_query($connect, $query);

$kas_list = [];

while ($row = mysqli_fetch_assoc($result)) {
    $kas_id = $row['id'];

    // CEK APAKAH USER INI SUDAH BAYAR?
    $check_paid = mysqli_query($connect, "SELECT * FROM kas_payments WHERE kas_item_id = '$kas_id' AND user_nim = '$nim_user'");
    $is_paid = mysqli_num_rows($check_paid) > 0;

    $row['is_paid'] = $is_paid;
    $kas_list[] = $row;
}

echo json_encode([
    'success' => true,
    'data' => $kas_list
]);
?>