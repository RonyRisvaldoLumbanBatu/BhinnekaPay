-- 1. Buat Database
CREATE DATABASE IF NOT EXISTS bhinnekapay_db;
USE bhinnekapay_db;

-- 2. Buat Tabel Users
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, -- Nanti kita enkripsi di tahap login
    nim VARCHAR(20),                -- Kosong jika user adalah Admin
    role ENUM('student', 'admin', 'superadmin') DEFAULT 'student',
    saldo DECIMAL(15, 2) DEFAULT 0, -- Format uang (contoh: 50000.00)
    photo_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Buat Tabel Transaksi
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,     -- Judul Transaksi (misal: "Isi Saldo")
    amount DECIMAL(15, 2) NOT NULL,  -- Jumlah Uang
    type ENUM('in', 'out') NOT NULL, -- in = Pemasukan, out = Pengeluaran
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 4. INSERT DATA DUMMY (Sesuai Permintaan)
-- Password diset "123456" untuk semua

-- A. Super Admin
INSERT INTO users (username, email, password, role, saldo) 
VALUES ('Super Admin', 'superadmin@bhinnekapay.com', '123456', 'superadmin', 0);

-- B. Admin Biro
INSERT INTO users (username, email, password, role, saldo) 
VALUES ('Biro Keuangan', 'admin@bhinnekapay.com', '123456', 'admin', 0);

-- C. Mahasiswa (Hanya Rony)
INSERT INTO users (username, email, password, nim, role, saldo) 
VALUES ('Rony', 'rony@gmail.com', '123456', '2403310133', 'student', 5700000);

-- 5. Insert Dummy Transaksi untuk Rony (ID 3)
INSERT INTO transactions (user_id, title, amount, type) VALUES (3, 'Isi Saldo', 5000000, 'in');
INSERT INTO transactions (user_id, title, amount, type) VALUES (3, 'Bayar Makan', 25000, 'out');
INSERT INTO transactions (user_id, title, amount, type) VALUES (3, 'Transfer Masuk', 725000, 'in');
