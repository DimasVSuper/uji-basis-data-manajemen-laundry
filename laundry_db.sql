-- Active: 1750055228060@@127.0.0.1@3306@laundry_db
-- =========================================
-- DATABASE SISTEM LAUNDRY
-- Dibuat pada: 10 Juli 2025
-- =========================================

-- =========================================
-- -- Deskripsi: Skrip SQL untuk membuat database sistem laundry dengan tabel-tabel yang diperlukan
-- -- dan beberapa data dummy untuk pengujian.
-- =========================================
-- RESET/Delete Database
DROP DATABASE laundry_db;

-- Membuat database
CREATE DATABASE IF NOT EXISTS laundry_db;
USE laundry_db;

-- =========================================
-- TABEL PELANGGAN
-- =========================================
CREATE TABLE pelanggan (
    id_pelanggan INT PRIMARY KEY AUTO_INCREMENT,
    nama_pelanggan VARCHAR(100) NOT NULL,
    nomor_telepon VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    alamat TEXT,
    catatan_pelanggan TEXT
);

-- =========================================
-- TABEL KARYAWAN
-- =========================================
CREATE TABLE karyawan (
    id_karyawan INT PRIMARY KEY AUTO_INCREMENT,
    nama_karyawan VARCHAR(100) NOT NULL,
    posisi ENUM('kasir', 'operator', 'supervisor', 'manager') NOT NULL
);

-- =========================================
-- TABEL LAYANAN
-- =========================================
CREATE TABLE layanan (
    id_layanan INT PRIMARY KEY AUTO_INCREMENT,
    nama_layanan VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    harga_per_unit DECIMAL(10,2) NOT NULL,
    satuan ENUM('kg', 'pcs', 'set') NOT NULL DEFAULT 'kg',
    estimasi_hari INT NOT NULL DEFAULT 1
);

-- =========================================
-- TABEL PRODUK PERSEDIAAN
-- =========================================
CREATE TABLE produk_persediaan (
    id_produk INT PRIMARY KEY AUTO_INCREMENT,
    nama_produk VARCHAR(100) NOT NULL,
    stok_saat_ini DECIMAL(10,2) NOT NULL DEFAULT 0,
    satuan ENUM('liter', 'kg', 'pcs', 'botol') NOT NULL
);

-- =========================================
-- TABEL PESANAN
-- =========================================
CREATE TABLE pesanan (
    id_pesanan INT PRIMARY KEY AUTO_INCREMENT,
    id_pelanggan INT NOT NULL,
    id_karyawan INT NOT NULL,
    tanggal_masuk DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tanggal_estimasi_selesai DATETIME NOT NULL,
    tanggal_selesai_aktual DATETIME NULL,
    subtotal_biaya DECIMAL(12,2) NOT NULL DEFAULT 0,
    diskon DECIMAL(12,2) DEFAULT 0,
    total_akhir DECIMAL(12,2) NOT NULL DEFAULT 0,
    status ENUM('menunggu', 'diproses', 'selesai', 'diambil', 'batal') NOT NULL DEFAULT 'menunggu',
    status_pembayaran ENUM('belum_bayar', 'dp', 'lunas') NOT NULL DEFAULT 'belum_bayar',
    metode_pembayaran ENUM('tunai', 'transfer', 'e_wallet', 'kartu_kredit') NULL,
    catatan TEXT,
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan) ON DELETE RESTRICT,
    FOREIGN KEY (id_karyawan) REFERENCES karyawan(id_karyawan) ON DELETE RESTRICT
);

-- =========================================
-- TABEL DETAIL PESANAN
-- =========================================
CREATE TABLE detail_pesanan (
    id_detail INT PRIMARY KEY AUTO_INCREMENT,
    id_pesanan INT NOT NULL,
    id_layanan INT NOT NULL,
    jumlah DECIMAL(10,2) NOT NULL,
    harga_saat_transaksi DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan) ON DELETE CASCADE,
    FOREIGN KEY (id_layanan) REFERENCES layanan(id_layanan) ON DELETE RESTRICT
);

-- =========================================
-- TABEL LOG PERSEDIAAN
-- =========================================
CREATE TABLE log_persediaan (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    id_produk INT NOT NULL,
    id_pesanan INT NULL, -- Bisa NULL jika bukan untuk pesanan (misal: restock)
    jenis_pergerakan ENUM('masuk', 'keluar', 'koreksi') NOT NULL,
    jumlah DECIMAL(10,2) NOT NULL,
    tanggal_log TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    keterangan TEXT,
    FOREIGN KEY (id_produk) REFERENCES produk_persediaan(id_produk) ON DELETE RESTRICT,
    FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan) ON DELETE SET NULL
);

-- =========================================
-- DATA DUMMY
-- =========================================

-- Insert data pelanggan
INSERT INTO pelanggan (nama_pelanggan, nomor_telepon, email, alamat, catatan_pelanggan) VALUES
('Budi Santoso', '081234567890', 'budi@email.com', 'Jl. Merdeka No. 123, Jakarta', 'Pelanggan VIP'),
('Sari Dewi', '082345678901', 'sari@email.com', 'Jl. Sudirman No. 456, Bandung', 'Alergi parfum'),
('Ahmad Rizki', '083456789012', 'ahmad@email.com', 'Jl. Gatot Subroto No. 789, Surabaya', 'Suka ekspres'),
('Maya Sari', '084567890123', 'maya@email.com', 'Jl. Thamrin No. 321, Jakarta', NULL),
('Doni Pratama', '085678901234', NULL, 'Jl. Ahmad Yani No. 654, Medan', 'Bayar cash');

-- Insert data karyawan
INSERT INTO karyawan (nama_karyawan, posisi) VALUES
('Rina Kartika', 'kasir'),
('Joko Susilo', 'operator'),
('Linda Sari', 'supervisor'),
('Bambang Wijaya', 'manager'),
('Tari Melati', 'operator');

-- Insert data layanan
INSERT INTO layanan (nama_layanan, deskripsi, harga_per_unit, satuan, estimasi_hari) VALUES
('Cuci Reguler', 'Cuci dengan deterjen biasa', 5000.00, 'kg', 2),
('Cuci Express', 'Cuci cepat selesai hari ini', 8000.00, 'kg', 1),
('Cuci Kering', 'Dry cleaning untuk pakaian khusus', 15000.00, 'pcs', 3),
('Setrika Saja', 'Hanya setrika tanpa cuci', 3000.00, 'kg', 1),
('Cuci Sepatu', 'Cuci khusus untuk sepatu', 25000.00, 'pcs', 2),
('Cuci Boneka', 'Cuci untuk boneka dan mainan', 20000.00, 'pcs', 3);

-- Insert data produk persediaan
INSERT INTO produk_persediaan (nama_produk, stok_saat_ini, satuan) VALUES
('Deterjen Bubuk', 25.50, 'kg'),
('Softener Cair', 12.00, 'liter'),
('Pewangi Pakaian', 8.00, 'botol'),
('Pemutih Pakaian', 6.50, 'liter'),
('Sabun Cuci Sepatu', 15.00, 'pcs');

-- Insert data pesanan
INSERT INTO pesanan (id_pelanggan, id_karyawan, tanggal_masuk, tanggal_estimasi_selesai, tanggal_selesai_aktual, subtotal_biaya, diskon, total_akhir, status, status_pembayaran, metode_pembayaran, catatan) VALUES
(1, 1, '2025-07-08 09:00:00', '2025-07-10 17:00:00', '2025-07-10 16:30:00', 25000.00, 2000.00, 23000.00, 'selesai', 'lunas', 'tunai', 'Sudah diambil'),
(2, 2, '2025-07-09 10:30:00', '2025-07-10 17:00:00', NULL, 40000.00, 0.00, 40000.00, 'diproses', 'dp', 'transfer', 'DP 20rb'),
(3, 1, '2025-07-09 14:00:00', '2025-07-11 17:00:00', NULL, 15000.00, 0.00, 15000.00, 'menunggu', 'belum_bayar', NULL, NULL),
(4, 3, '2025-07-10 08:00:00', '2025-07-11 17:00:00', NULL, 50000.00, 5000.00, 45000.00, 'diproses', 'lunas', 'e_wallet', 'Prioritas'),
(1, 2, '2025-07-10 15:00:00', '2025-07-12 17:00:00', NULL, 30000.00, 0.00, 30000.00, 'menunggu', 'belum_bayar', NULL, 'Pelanggan VIP');

-- Insert data detail pesanan
INSERT INTO detail_pesanan (id_pesanan, id_layanan, jumlah, harga_saat_transaksi, subtotal) VALUES
(1, 1, 5.00, 5000.00, 25000.00),
(2, 2, 3.00, 8000.00, 24000.00),
(2, 4, 4.00, 3000.00, 12000.00),
(2, 3, 1.00, 15000.00, 15000.00),
(3, 1, 3.00, 5000.00, 15000.00),
(4, 5, 2.00, 25000.00, 50000.00),
(5, 2, 2.00, 8000.00, 16000.00),
(5, 4, 3.00, 3000.00, 9000.00),
(5, 1, 1.00, 5000.00, 5000.00);

-- Insert data log persediaan
INSERT INTO log_persediaan (id_produk, id_pesanan, jenis_pergerakan, jumlah, keterangan) VALUES
(1, 1, 'keluar', 0.50, 'Digunakan untuk pesanan ID 1'),
(2, 1, 'keluar', 0.25, 'Digunakan untuk pesanan ID 1'),
(1, 2, 'keluar', 0.75, 'Digunakan untuk pesanan ID 2'),
(3, 2, 'keluar', 1.00, 'Digunakan untuk pesanan ID 2'),
(5, 4, 'keluar', 2.00, 'Digunakan untuk cuci sepatu'),
(1, NULL, 'masuk', 5.00, 'Restock deterjen'),
(2, NULL, 'masuk', 3.00, 'Restock softener');

-- =========================================
-- CONTOH SKENARIO DML (Data Manipulation Language)
-- =========================================

-- 1. SELECT: Menampilkan semua pesanan dengan detail pelanggan
SELECT 
    pesanan.id_pesanan,
    pelanggan.nama_pelanggan,
    pesanan.tanggal_masuk,
    pesanan.status,
    pesanan.total_akhir
FROM pesanan
JOIN pelanggan ON pesanan.id_pelanggan = pelanggan.id_pelanggan
ORDER BY pesanan.tanggal_masuk DESC;

-- 2. SELECT dengan WHERE: Cari pesanan yang belum selesai
SELECT 
    pesanan.id_pesanan,
    pelanggan.nama_pelanggan,
    pesanan.status,
    pesanan.tanggal_estimasi_selesai
FROM pesanan
JOIN pelanggan ON pesanan.id_pelanggan = pelanggan.id_pelanggan
WHERE pesanan.status IN ('menunggu', 'diproses');

-- 3. SELECT dengan JOIN: Detail pesanan dengan layanan
SELECT 
    pesanan.id_pesanan,
    pelanggan.nama_pelanggan,
    layanan.nama_layanan,
    detail_pesanan.jumlah,
    detail_pesanan.harga_saat_transaksi,
    detail_pesanan.subtotal
FROM pesanan
JOIN pelanggan ON pesanan.id_pelanggan = pelanggan.id_pelanggan
JOIN detail_pesanan ON pesanan.id_pesanan = detail_pesanan.id_pesanan
JOIN layanan ON detail_pesanan.id_layanan = layanan.id_layanan
WHERE pesanan.id_pesanan = 2;

-- 4. SELECT dengan GROUP BY: Total pendapatan per layanan
SELECT 
    layanan.nama_layanan,
    COUNT(detail_pesanan.id_detail) as jumlah_transaksi,
    SUM(detail_pesanan.subtotal) as total_pendapatan
FROM layanan
JOIN detail_pesanan ON layanan.id_layanan = detail_pesanan.id_layanan
GROUP BY layanan.id_layanan, layanan.nama_layanan
ORDER BY total_pendapatan DESC;

-- 5. UPDATE: Mengubah status pesanan
UPDATE pesanan 
SET status = 'selesai', 
    tanggal_selesai_aktual = '2025-07-10 16:00:00'
WHERE id_pesanan = 3;
-- Cek hasil update status pesanan
SELECT * FROM pesanan WHERE id_pesanan = 3;

-- 6. UPDATE: Memberikan diskon untuk pelanggan VIP
UPDATE pesanan 
SET diskon = 5000, 
    total_akhir = subtotal_biaya - 5000
WHERE id_pelanggan = 1 AND status = 'menunggu';
-- Cek hasil update diskon pelanggan VIP
SELECT * FROM pesanan WHERE id_pelanggan = 1 AND status = 'menunggu';

-- 7. INSERT: Menambah pelanggan baru
INSERT INTO pelanggan (nama_pelanggan, nomor_telepon, email, alamat) 
VALUES ('Rudi Hartono', '086789012345', 'rudi@email.com', 'Jl. Kebon Jeruk No. 888, Jakarta');
-- Cek hasil insert pelanggan baru
SELECT * FROM pelanggan WHERE nama_pelanggan = 'Rudi Hartono';

-- 8. INSERT: Menambah pesanan baru untuk pelanggan baru
INSERT INTO pesanan (id_pelanggan, id_karyawan, tanggal_masuk, tanggal_estimasi_selesai, subtotal_biaya, total_akhir, status) 
VALUES (6, 1, NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY), 15000, 15000, 'menunggu');
-- Cek hasil insert pesanan baru
SELECT * FROM pesanan WHERE id_pelanggan = 6 ORDER BY id_pesanan DESC LIMIT 1;

-- 9. DELETE: Menghapus layanan tertentu
DELETE FROM layanan WHERE nama_layanan = 'Cuci Boneka';
-- Cek hasil delete layanan
SELECT * FROM layanan WHERE nama_layanan = 'Cuci Boneka';

-- 10. SELECT dengan SUBQUERY: Pelanggan dengan pesanan terbanyak
SELECT 
    pelanggan.nama_pelanggan,
    pelanggan.nomor_telepon,
    COUNT(pesanan.id_pesanan) AS jumlah_pesanan
FROM pelanggan
JOIN pesanan ON pelanggan.id_pelanggan = pesanan.id_pelanggan
GROUP BY pelanggan.id_pelanggan
HAVING COUNT(pesanan.id_pesanan) = (
    SELECT MAX(jumlah) FROM (
        SELECT COUNT(id_pesanan) AS jumlah 
        FROM pesanan 
        GROUP BY id_pelanggan
    ) AS max_pesanan
);

