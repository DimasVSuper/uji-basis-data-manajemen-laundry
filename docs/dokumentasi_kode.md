# 💻 Dokumentasi SQL Kode - Database Laundry

---

## 📋 Daftar Isi
1. [DDL (Data Definition Language)](#ddl-data-definition-language)
2. [DML Insert Data Dummy](#dml-insert-data-dummy)
3. [DML Query Examples](#dml-query-examples)
4. [Advanced SQL Techniques](#advanced-sql-techniques)
5. [Best Practices](#best-practices)

---

## 🏗️ DDL (Data Definition Language)

### 1. Database Creation & Setup

```sql
-- =========================================
-- MEMBUAT DATABASE
-- =========================================
DROP DATABASE laundry_db;           -- Hapus database jika sudah ada
CREATE DATABASE IF NOT EXISTS laundry_db;  -- Buat database baru
USE laundry_db;                     -- Gunakan database
```

**💡 Pembelajaran:**
- `DROP DATABASE` - Menghapus database yang sudah ada
- `CREATE DATABASE IF NOT EXISTS` - Membuat database jika belum ada
- `USE` - Memilih database yang akan digunakan

### 2. Tabel Pelanggan

```sql
CREATE TABLE pelanggan (
    id_pelanggan INT PRIMARY KEY AUTO_INCREMENT,    -- Primary Key dengan auto increment
    nama_pelanggan VARCHAR(100) NOT NULL,           -- Field wajib diisi
    nomor_telepon VARCHAR(15) UNIQUE NOT NULL,      -- Field unik dan wajib
    email VARCHAR(100) UNIQUE,                      -- Field unik tapi boleh NULL
    alamat TEXT,                                    -- Field panjang untuk alamat
    catatan_pelanggan TEXT                          -- Field opsional
);
```

**💡 Pembelajaran:**
- `PRIMARY KEY AUTO_INCREMENT` - Kunci utama yang otomatis bertambah
- `NOT NULL` - Field yang wajib diisi
- `UNIQUE` - Field yang tidak boleh duplikat
- `VARCHAR(n)` vs `TEXT` - Varchar untuk data pendek, TEXT untuk data panjang

### 3. Tabel Karyawan

```sql
CREATE TABLE karyawan (
    id_karyawan INT PRIMARY KEY AUTO_INCREMENT,
    nama_karyawan VARCHAR(100) NOT NULL,
    posisi ENUM('kasir', 'operator', 'supervisor', 'manager') NOT NULL
);
```

**💡 Pembelajaran:**
- `ENUM` - Membatasi nilai yang bisa dimasukkan ke field
- Berguna untuk data yang pilihan terbatas dan tetap

### 4. Tabel Layanan

```sql
CREATE TABLE layanan (
    id_layanan INT PRIMARY KEY AUTO_INCREMENT,
    nama_layanan VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    harga_per_unit DECIMAL(10,2) NOT NULL,          -- 10 digit total, 2 digit desimal
    satuan ENUM('kg', 'pcs', 'set') NOT NULL DEFAULT 'kg',  -- Default value
    estimasi_hari INT NOT NULL DEFAULT 1           -- Default value numerik
);
```

**💡 Pembelajaran:**
- `DECIMAL(10,2)` - Tipe data untuk uang/harga (10 digit total, 2 desimal)
- `DEFAULT` - Nilai default jika tidak diisi
- Pemilihan tipe data yang tepat untuk kebutuhan bisnis

### 5. Tabel Produk Persediaan

```sql
CREATE TABLE produk_persediaan (
    id_produk INT PRIMARY KEY AUTO_INCREMENT,
    nama_produk VARCHAR(100) NOT NULL,
    stok_saat_ini DECIMAL(10,2) NOT NULL DEFAULT 0,
    satuan ENUM('liter', 'kg', 'pcs', 'botol') NOT NULL
);
```

**💡 Pembelajaran:**
- Menggunakan DECIMAL untuk stok karena bisa ada nilai desimal (misal: 2.5 kg)
- ENUM berbeda dari tabel layanan sesuai kebutuhan produk

### 6. Tabel Pesanan (dengan Foreign Keys)

```sql
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
    
    -- FOREIGN KEY CONSTRAINTS
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan) ON DELETE RESTRICT,
    FOREIGN KEY (id_karyawan) REFERENCES karyawan(id_karyawan) ON DELETE RESTRICT
);
```

**💡 Pembelajaran:**
- `DATETIME` - Tipe data untuk tanggal dan waktu
- `CURRENT_TIMESTAMP` - Otomatis mengisi waktu saat ini
- `FOREIGN KEY` - Menghubungkan tabel dengan tabel lain
- `ON DELETE RESTRICT` - Mencegah penghapusan data yang dirujuk
- `DECIMAL(12,2)` - Lebih besar untuk total transaksi

### 7. Tabel Detail Pesanan

```sql
CREATE TABLE detail_pesanan (
    id_detail INT PRIMARY KEY AUTO_INCREMENT,
    id_pesanan INT NOT NULL,
    id_layanan INT NOT NULL,
    jumlah DECIMAL(10,2) NOT NULL,
    harga_saat_transaksi DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    
    -- FOREIGN KEYS dengan berbagai action
    FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan) ON DELETE CASCADE,
    FOREIGN KEY (id_layanan) REFERENCES layanan(id_layanan) ON DELETE RESTRICT
);
```

**💡 Pembelajaran:**
- `ON DELETE CASCADE` - Hapus detail jika pesanan dihapus
- `ON DELETE RESTRICT` - Tidak boleh hapus layanan jika masih digunakan
- Penyimpanan harga saat transaksi untuk historical data

### 8. Tabel Log Persediaan

```sql
CREATE TABLE log_persediaan (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    id_produk INT NOT NULL,
    id_pesanan INT NULL,  -- Boleh NULL untuk non-pesanan (restock)
    jenis_pergerakan ENUM('masuk', 'keluar', 'koreksi') NOT NULL,
    jumlah DECIMAL(10,2) NOT NULL,
    tanggal_log TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    keterangan TEXT,
    
    -- FOREIGN KEYS dengan action berbeda
    FOREIGN KEY (id_produk) REFERENCES produk_persediaan(id_produk) ON DELETE RESTRICT,
    FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan) ON DELETE SET NULL
);
```

**💡 Pembelajaran:**
- `TIMESTAMP` vs `DATETIME` - TIMESTAMP otomatis update
- `ON DELETE SET NULL` - Set NULL jika data induk dihapus
- Foreign key yang boleh NULL untuk fleksibilitas

---

## 📊 DML Insert Data Dummy

### 1. Insert Pelanggan

```sql
INSERT INTO pelanggan (nama_pelanggan, nomor_telepon, email, alamat, catatan_pelanggan) VALUES
('Budi Santoso', '081234567890', 'budi@email.com', 'Jl. Merdeka No. 123, Jakarta', 'Pelanggan VIP'),
('Sari Dewi', '082345678901', 'sari@email.com', 'Jl. Sudirman No. 456, Bandung', 'Alergi parfum'),
('Ahmad Rizki', '083456789012', 'ahmad@email.com', 'Jl. Gatot Subroto No. 789, Surabaya', 'Suka ekspres'),
('Maya Sari', '084567890123', 'maya@email.com', 'Jl. Thamrin No. 321, Jakarta', NULL),
('Doni Pratama', '085678901234', NULL, 'Jl. Ahmad Yani No. 654, Medan', 'Bayar cash');
```

**💡 Pembelajaran:**
- `INSERT INTO ... VALUES` - Syntax dasar insert multiple rows
- Penggunaan `NULL` untuk field yang boleh kosong
- Tidak perlu insert id_pelanggan karena AUTO_INCREMENT

### 2. Insert Karyawan

```sql
INSERT INTO karyawan (nama_karyawan, posisi) VALUES
('Rina Kartika', 'kasir'),
('Joko Susilo', 'operator'),
('Linda Sari', 'supervisor'),
('Bambang Wijaya', 'manager'),
('Tari Melati', 'operator');
```

**💡 Pembelajaran:**
- Insert dengan ENUM values
- Nilai ENUM harus sesuai dengan yang didefinisikan di DDL

### 3. Insert Layanan

```sql
INSERT INTO layanan (nama_layanan, deskripsi, harga_per_unit, satuan, estimasi_hari) VALUES
('Cuci Reguler', 'Cuci dengan deterjen biasa', 5000.00, 'kg', 2),
('Cuci Express', 'Cuci cepat selesai hari ini', 8000.00, 'kg', 1),
('Cuci Kering', 'Dry cleaning untuk pakaian khusus', 15000.00, 'pcs', 3),
('Setrika Saja', 'Hanya setrika tanpa cuci', 3000.00, 'kg', 1),
('Cuci Sepatu', 'Cuci khusus untuk sepatu', 25000.00, 'pcs', 2),
('Cuci Boneka', 'Cuci untuk boneka dan mainan', 20000.00, 'pcs', 3);
```

**💡 Pembelajaran:**
- Insert dengan DECIMAL values (gunakan format 5000.00)
- Mix antara satuan 'kg' dan 'pcs' sesuai jenis layanan

### 4. Insert dengan Foreign Key

```sql
INSERT INTO pesanan (id_pelanggan, id_karyawan, tanggal_masuk, tanggal_estimasi_selesai, tanggal_selesai_aktual, subtotal_biaya, diskon, total_akhir, status, status_pembayaran, metode_pembayaran, catatan) VALUES
(1, 1, '2025-07-08 09:00:00', '2025-07-10 17:00:00', '2025-07-10 16:30:00', 25000.00, 2000.00, 23000.00, 'selesai', 'lunas', 'tunai', 'Sudah diambil'),
(2, 2, '2025-07-09 10:30:00', '2025-07-10 17:00:00', NULL, 40000.00, 0.00, 40000.00, 'diproses', 'dp', 'transfer', 'DP 20rb');
```

**💡 Pembelajaran:**
- Insert dengan foreign key menggunakan ID yang sudah ada
- Format DATETIME: 'YYYY-MM-DD HH:MM:SS'
- Konsistensi data antara subtotal, diskon, dan total_akhir

---

## 🔍 DML Query Examples

### 1. SELECT Dasar dengan JOIN

```sql
-- Query 1: Menampilkan semua pesanan dengan detail pelanggan
SELECT 
    pesanan.id_pesanan,
    pelanggan.nama_pelanggan,
    pesanan.tanggal_masuk,
    pesanan.status,
    pesanan.total_akhir
FROM pesanan
JOIN pelanggan ON pesanan.id_pelanggan = pelanggan.id_pelanggan
ORDER BY pesanan.tanggal_masuk DESC;
```

**💡 Pembelajaran:**
- `JOIN` (sama dengan INNER JOIN) - Menggabungkan data dari 2 tabel
- `ON` clause - Kondisi penggabungan tabel
- `ORDER BY ... DESC` - Mengurutkan dari terbaru ke terlama
- Alias tabel untuk readability

### 2. SELECT dengan WHERE Clause

```sql
-- Query 2: Cari pesanan yang belum selesai
SELECT 
    pesanan.id_pesanan,
    pelanggan.nama_pelanggan,
    pesanan.status,
    pesanan.tanggal_estimasi_selesai
FROM pesanan
JOIN pelanggan ON pesanan.id_pelanggan = pelanggan.id_pelanggan
WHERE pesanan.status IN ('menunggu', 'diproses');
```

**💡 Pembelajaran:**
- `WHERE` - Filter data berdasarkan kondisi
- `IN (value1, value2)` - Cek apakah nilai ada dalam list
- Kombinasi JOIN dengan WHERE untuk filter yang kompleks

### 3. Multiple JOIN

```sql
-- Query 3: Detail pesanan dengan layanan (3 tabel)
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
```

**💡 Pembelajaran:**
- Multiple JOIN - Menggabungkan lebih dari 2 tabel
- Chain JOIN - JOIN secara berurutan
- WHERE dengan nilai spesifik untuk detail satu pesanan

### 4. GROUP BY dan Aggregate Functions

```sql
-- Query 4: Total pendapatan per layanan
SELECT 
    layanan.nama_layanan,
    COUNT(detail_pesanan.id_detail) as jumlah_transaksi,
    SUM(detail_pesanan.subtotal) as total_pendapatan
FROM layanan
JOIN detail_pesanan ON layanan.id_layanan = detail_pesanan.id_layanan
GROUP BY layanan.id_layanan, layanan.nama_layanan
ORDER BY total_pendapatan DESC;
```

**💡 Pembelajaran:**
- `GROUP BY` - Mengelompokkan data berdasarkan kolom tertentu
- `COUNT()` - Menghitung jumlah rows
- `SUM()` - Menjumlahkan nilai numerik
- `AS` - Alias untuk kolom hasil
- GROUP BY dengan multiple columns untuk akurasi

### 5. UPDATE Statement

```sql
-- Query 5: Mengubah status pesanan
UPDATE pesanan 
SET status = 'selesai', 
    tanggal_selesai_aktual = '2025-07-10 16:00:00'
WHERE id_pesanan = 3;

-- Validation query
SELECT * FROM pesanan WHERE id_pesanan = 3;
```

**💡 Pembelajaran:**
- `UPDATE ... SET` - Mengubah data existing
- Multiple column update dalam satu statement
- `WHERE` clause wajib untuk mencegah update semua data
- Validation query untuk mengecek hasil update

### 6. UPDATE dengan Kondisi Kompleks

```sql
-- Query 6: Memberikan diskon untuk pelanggan VIP
UPDATE pesanan 
SET diskon = 5000, 
    total_akhir = subtotal_biaya - 5000
WHERE id_pelanggan = 1 AND status = 'menunggu';

-- Validation
SELECT * FROM pesanan WHERE id_pelanggan = 1 AND status = 'menunggu';
```

**💡 Pembelajaran:**
- `AND` operator dalam WHERE clause
- Kalkulasi dalam UPDATE (subtotal_biaya - 5000)
- Update berdasarkan multiple conditions

### 7. INSERT dengan Functions

```sql
-- Query 7: Menambah pelanggan baru
INSERT INTO pelanggan (nama_pelanggan, nomor_telepon, email, alamat) 
VALUES ('Rudi Hartono', '086789012345', 'rudi@email.com', 'Jl. Kebon Jeruk No. 888, Jakarta');

-- Validation
SELECT * FROM pelanggan WHERE nama_pelanggan = 'Rudi Hartono';
```

**💡 Pembelajaran:**
- INSERT single record
- Validation dengan SELECT untuk memastikan data tersimpan

### 8. INSERT dengan Functions Built-in

```sql
-- Query 8: Menambah pesanan dengan function NOW()
INSERT INTO pesanan (id_pelanggan, id_karyawan, tanggal_masuk, tanggal_estimasi_selesai, subtotal_biaya, total_akhir, status) 
VALUES (6, 1, NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY), 15000, 15000, 'menunggu');

-- Validation
SELECT * FROM pesanan WHERE id_pelanggan = 6 ORDER BY id_pesanan DESC LIMIT 1;
```

**💡 Pembelajaran:**
- `NOW()` - Function untuk waktu saat ini
- `DATE_ADD(date, INTERVAL n DAY)` - Menambah hari ke tanggal
- `ORDER BY ... DESC LIMIT 1` - Mengambil record terbaru

### 9. DELETE Statement

```sql
-- Query 9: Menghapus layanan tertentu
DELETE FROM layanan WHERE nama_layanan = 'Cuci Boneka';

-- Validation
SELECT * FROM layanan WHERE nama_layanan = 'Cuci Boneka';
```

**💡 Pembelajaran:**
- `DELETE FROM ... WHERE` - Menghapus data berdasarkan kondisi
- HATI-HATI: DELETE tanpa WHERE akan hapus semua data!
- Validation untuk memastikan data terhapus

### 10. SUBQUERY Complex

```sql
-- Query 10: Pelanggan dengan pesanan terbanyak
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
```

**💡 Pembelajaran:**
- `SUBQUERY` - Query dalam query
- `HAVING` vs `WHERE` - HAVING untuk filter hasil GROUP BY
- `MAX()` function - Mencari nilai maksimum
- Nested subquery - Query dalam query dalam query

---

## 🎯 Advanced SQL Techniques

### 1. CASE Statement untuk Logic

```sql
-- Contoh: Status stok dengan logic
SELECT 
    nama_produk,
    stok_saat_ini,
    CASE 
        WHEN stok_saat_ini < 5 THEN 'Stok Menipis'
        WHEN stok_saat_ini < 10 THEN 'Stok Sedang'
        ELSE 'Stok Aman'
    END as status_stok
FROM produk_persediaan;
```

**💡 Pembelajaran:**
- `CASE WHEN ... THEN ... ELSE ... END` - Conditional logic
- Multiple conditions dengan WHEN
- ELSE sebagai default case

### 2. Window Functions (Advanced)

```sql
-- Contoh: Ranking pelanggan berdasarkan total belanja
SELECT 
    pel.nama_pelanggan,
    SUM(p.total_akhir) as total_belanja,
    RANK() OVER (ORDER BY SUM(p.total_akhir) DESC) as ranking
FROM pelanggan pel
JOIN pesanan p ON pel.id_pelanggan = p.id_pelanggan
WHERE p.status_pembayaran = 'lunas'
GROUP BY pel.id_pelanggan, pel.nama_pelanggan;
```

**💡 Pembelajaran:**
- `RANK() OVER()` - Window function untuk ranking
- Kombinasi dengan GROUP BY dan aggregate functions

### 3. EXISTS vs IN

```sql
-- Cari pelanggan yang punya pesanan
-- Menggunakan EXISTS (lebih efisien)
SELECT nama_pelanggan
FROM pelanggan pel
WHERE EXISTS (
    SELECT 1 FROM pesanan p 
    WHERE p.id_pelanggan = pel.id_pelanggan
);

-- Menggunakan IN
SELECT nama_pelanggan
FROM pelanggan 
WHERE id_pelanggan IN (
    SELECT DISTINCT id_pelanggan FROM pesanan
);
```

**💡 Pembelajaran:**
- `EXISTS` vs `IN` - Perbedaan performance dan use case
- `SELECT 1` dalam EXISTS - Tidak perlu data aktual, hanya cek keberadaan

---

## ✅ Best Practices

### 1. Naming Conventions

```sql
-- ✅ GOOD: Konsisten dan descriptive
CREATE TABLE pesanan (
    id_pesanan INT PRIMARY KEY,
    tanggal_masuk DATETIME,
    status_pembayaran ENUM(...)
);

-- ❌ BAD: Tidak konsisten
CREATE TABLE order (
    orderID INT PRIMARY KEY,
    date_in DATETIME,
    payStatus ENUM(...)
);
```

### 2. Index Strategy

```sql
-- ✅ GOOD: Index untuk foreign keys dan frequent WHERE clauses
CREATE INDEX idx_pesanan_tanggal ON pesanan(tanggal_masuk);
CREATE INDEX idx_pesanan_status ON pesanan(status);
CREATE INDEX idx_pelanggan_telepon ON pelanggan(nomor_telepon);

-- ✅ GOOD: Composite index untuk multiple column queries
CREATE INDEX idx_pesanan_tanggal_status ON pesanan(tanggal_masuk, status);
```

### 3. Data Types

```sql
-- ✅ GOOD: Appropriate data types
price DECIMAL(10,2)        -- Untuk harga/uang
stock DECIMAL(10,2)        -- Untuk stok yang bisa desimal
quantity INT               -- Untuk quantity yang selalu integer
created_at TIMESTAMP       -- Untuk tracking waktu

-- ❌ BAD: Wrong data types
price VARCHAR(20)          -- Jangan simpan angka sebagai string
date_field VARCHAR(50)     -- Jangan simpan tanggal sebagai string
```

### 4. Query Optimization

```sql
-- ✅ GOOD: Specific columns
SELECT id_pesanan, nama_pelanggan, total_akhir
FROM pesanan p
JOIN pelanggan pel ON p.id_pelanggan = pel.id_pelanggan;

-- ❌ BAD: SELECT *
SELECT *
FROM pesanan p
JOIN pelanggan pel ON p.id_pelanggan = pel.id_pelanggan;

-- ✅ GOOD: LIMIT untuk large datasets
SELECT * FROM pesanan 
ORDER BY tanggal_masuk DESC 
LIMIT 100;
```

### 5. Security

```sql
-- ✅ GOOD: Prepared statements (dalam aplikasi)
-- $stmt = $pdo->prepare("SELECT * FROM pesanan WHERE id_pelanggan = ?");
-- $stmt->execute([$customer_id]);

-- ❌ BAD: String concatenation (SQL Injection risk)
-- $query = "SELECT * FROM pesanan WHERE id_pelanggan = " . $_GET['id'];
```

---

## 📚 Summary Pembelajaran

### Core Concepts Covered:
1. **DDL**: CREATE, ALTER, DROP, indexes, constraints
2. **DML**: SELECT, INSERT, UPDATE, DELETE
3. **Joins**: INNER, LEFT, RIGHT, FULL OUTER
4. **Functions**: Aggregate (COUNT, SUM, AVG), Date (NOW, DATE_ADD)
5. **Advanced**: Subqueries, CASE statements, window functions
6. **Constraints**: Primary keys, foreign keys, unique, not null
7. **Data Types**: INT, VARCHAR, TEXT, DECIMAL, DATETIME, ENUM

### Key Learning Points:
- 🔑 **Data Integrity**: Foreign keys dan constraints
- 🔑 **Performance**: Proper indexing dan query optimization
- 🔑 **Security**: Avoid SQL injection
- 🔑 **Maintainability**: Consistent naming dan good structure
- 🔑 **Business Logic**: ENUM values dan validation

---

*Dokumentasi SQL ini dibuat untuk pembelajaran Database Management System dalam konteks Uji Basis Data Manajemen Laundry - PT Zahir International*