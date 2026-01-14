-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 14 Jan 2026 pada 19.35
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bhinnekapay_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `berita`
--

CREATE TABLE `berita` (
  `id` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `subtitle` varchar(100) DEFAULT NULL,
  `date_text` varchar(50) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `kas_items`
--

CREATE TABLE `kas_items` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `deskripsi` varchar(255) DEFAULT NULL,
  `nominal` decimal(15,2) DEFAULT 0.00,
  `target_kelas` varchar(50) NOT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kas_items`
--

INSERT INTO `kas_items` (`id`, `title`, `deskripsi`, `nominal`, `target_kelas`, `created_by`, `created_at`) VALUES
(1, 'Kas Minggu 1', '', 5000.00, 'IF A SR', 'Rony Risvaldo Lumban Batu', '2026-01-14 17:58:11');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kas_payments`
--

CREATE TABLE `kas_payments` (
  `id` int(11) NOT NULL,
  `kas_item_id` int(11) NOT NULL,
  `user_nim` varchar(20) NOT NULL,
  `user_nama` varchar(100) DEFAULT NULL,
  `nominal_bayar` decimal(15,2) DEFAULT NULL,
  `paid_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kas_payments`
--

INSERT INTO `kas_payments` (`id`, `kas_item_id`, `user_nim`, `user_nama`, `nominal_bayar`, `paid_at`) VALUES
(1, 1, '2403310101', 'Rony Risvaldo Lumban Batu', 0.00, '2026-01-14 17:58:20'),
(2, 1, '2403320202', 'Monica Feny Julia Pardede', 0.00, '2026-01-14 18:01:02');

-- --------------------------------------------------------

--
-- Struktur dari tabel `split_bills`
--

CREATE TABLE `split_bills` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `creator_nim` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('proses','selesai') DEFAULT 'proses'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `split_bills`
--

INSERT INTO `split_bills` (`id`, `title`, `total_amount`, `creator_nim`, `created_at`, `status`) VALUES
(1, 'Beli Buku Bareng', 40000.00, '2403310101', '2026-01-14 18:21:39', 'proses');

-- --------------------------------------------------------

--
-- Struktur dari tabel `split_bill_members`
--

CREATE TABLE `split_bill_members` (
  `id` int(11) NOT NULL,
  `split_bill_id` int(11) NOT NULL,
  `user_nim` varchar(20) NOT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL,
  `payment_status` enum('pending','paid') DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `split_bill_members`
--

INSERT INTO `split_bill_members` (`id`, `split_bill_id`, `user_nim`, `user_name`, `amount`, `payment_status`) VALUES
(1, 1, '2403310101', 'Rony Risvaldo Lumban Batu (Saya)', 20000.00, 'paid'),
(2, 1, '2403320202', 'Monica Feny Julia Pardede', 20000.00, 'pending');

-- --------------------------------------------------------

--
-- Struktur dari tabel `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `type` enum('in','out') NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `id` int(11) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `type` enum('IN','OUT') DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `transaksi`
--

INSERT INTO `transaksi` (`id`, `username`, `type`, `amount`, `description`, `date`) VALUES
(1, 'RonyRisvaldoLumbanBatu', 'IN', 1500000.00, 'Kiriman Orang Tua', '2026-01-11 14:15:20'),
(2, 'RonyRisvaldoLumbanBatu', 'OUT', 50000.00, 'Beli Pulsa', '2026-01-11 14:15:20'),
(3, 'RonyRisvaldoLumbanBatu', 'OUT', 120000.00, 'Bayar Kas Kelas', '2026-01-11 14:15:20'),
(4, 'RonyRisvaldoLumbanBatu', 'OUT', 15000.00, 'Makan Siang', '2026-01-11 14:15:20');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nim` varchar(20) DEFAULT NULL,
  `role` enum('student','admin','superadmin') DEFAULT 'student',
  `saldo` decimal(15,2) DEFAULT 0.00,
  `photo_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `kelas` varchar(50) DEFAULT '-',
  `no_hp` varchar(20) DEFAULT '-',
  `role_kelas` varchar(20) DEFAULT 'anggota'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `nim`, `role`, `saldo`, `photo_url`, `created_at`, `kelas`, `no_hp`, `role_kelas`) VALUES
(1, 'Super Admin', 'superadmin@bhinnekapay.com', '123456', NULL, 'superadmin', 0.00, NULL, '2025-12-27 08:02:57', '-', '-', 'anggota'),
(2, 'Biro Keuangan', 'admin@bhinnekapay.com', '123456', NULL, 'admin', 0.00, NULL, '2025-12-27 08:02:57', '-', '-', 'anggota'),
(5, 'Rony Risvaldo Lumban Batu', '2403310101@students.satyaterrabhinneka.ac.id', 'Risvaldo0710', '2403310101', 'student', 0.00, NULL, '2026-01-11 05:45:02', 'IF A SR', '081234567890', 'bendahara'),
(6, 'Monica Feny Julia Pardede', '2403320202@students.satyaterrabhinneka.ac.id', 'Risvaldo0710', '2403320202', 'student', 0.00, NULL, '2026-01-14 17:59:42', 'IF A SR', '081234567890', 'anggota');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `berita`
--
ALTER TABLE `berita`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `kas_items`
--
ALTER TABLE `kas_items`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `kas_payments`
--
ALTER TABLE `kas_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `kas_item_id` (`kas_item_id`);

--
-- Indeks untuk tabel `split_bills`
--
ALTER TABLE `split_bills`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `split_bill_members`
--
ALTER TABLE `split_bill_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `split_bill_id` (`split_bill_id`);

--
-- Indeks untuk tabel `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `berita`
--
ALTER TABLE `berita`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `kas_items`
--
ALTER TABLE `kas_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `kas_payments`
--
ALTER TABLE `kas_payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `split_bills`
--
ALTER TABLE `split_bills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `split_bill_members`
--
ALTER TABLE `split_bill_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `kas_payments`
--
ALTER TABLE `kas_payments`
  ADD CONSTRAINT `kas_payments_ibfk_1` FOREIGN KEY (`kas_item_id`) REFERENCES `kas_items` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `split_bill_members`
--
ALTER TABLE `split_bill_members`
  ADD CONSTRAINT `split_bill_members_ibfk_1` FOREIGN KEY (`split_bill_id`) REFERENCES `split_bills` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
