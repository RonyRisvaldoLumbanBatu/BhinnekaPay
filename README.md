# Bhinneka Pay 💸

Desktop-based Fintech Application for University Environment.
Proyek ini bertujuan menciptakan sistem pembayaran tertutup (closed-loop) menggunakan NIM sebagai nomor rekening.

## 🚀 Tech Stack
- **Desktop App:** Python (CustomTkinter)
- **Backend API:** Python (FastAPI)
- **Database:** MySQL
- **Architecture:** Client-Server via REST API

## 🎯 Fitur Utama
1. **Login via NIM:** Autentikasi mahasiswa menggunakan NIM.
2. **Cek Saldo Real-time:** Menampilkan saldo terkini dari server.
3. **Transfer Sesama Mahasiswa:** Kirim uang hanya dengan input NIM tujuan.
4. **Mutasi Transaksi:** Riwayat uang masuk dan keluar.

## 🛠 Cara Install (Development)
1. Clone repo: `git clone https://github.com/USERNAME/bhinneka-pay.git`
2. Setup Backend:
   - `cd backend`
   - `pip install -r requirements.txt`
   - `uvicorn main:app --reload`
3. Setup Desktop App:
   - `cd desktop_app`
   - `pip install -r requirements.txt`
   - `python main.py`

---
*Created by [Nama Kamu] for University Project.*
