# 📚 Dokumentasi Database Laundry - Kelompok 7

## 📋 Informasi Proyek
- **Mata Kuliah**: Basis Data Semester 2
- **Perusahaan**: PT Zahir International
- **Proyek**: Uji Basis Data Manajemen Laundry
- **Kelompok**: 7
- **Tanggal**: 14 Juli 2025
- **Repository**: [uji-basis-data-manajemen-laundry-kelompok-7](https://github.com/DimasVSuper/uji-basis-data-manajemen-laundry-kelompok-7)

## 👥 Anggota Kelompok
| No | Nama | NIM |
|----|------|-----|
| 1 | Dimas Bayu Nugroho | 19240384 |
| 2 | M. Riefalldo Ramadhan | 19241047 |
| 3 | Daulia Artika Samdani | 19240995 |
| 4 | Mochammad Rayhan | 19241572 |
| 5 | Anis Nurbaiti | 19240071 |
| 6 | Raden Yudhistira Wicaksono | 19241616 |
| 7 | Ichwan Fauzan | 19240621 |
| 8 | Kristian Alexander Wily Wijaya | 19241815 |

## 🎯 Tujuan Proyek
Sebagai bagian dari **Uji Basis Data Manajemen Laundry** dari **PT Zahir International**, proyek ini bertujuan untuk merancang dan mengimplementasikan database komprehensif untuk sistem manajemen laundry yang mencakup:
- Pengelolaan data pelanggan dan karyawan
- Sistem pemesanan dan layanan laundry
- Tracking persediaan bahan cuci
- Laporan transaksi dan pendapatan
- Demonstrasi kemampuan desain database relasional

## 🏗️ Arsitektur Database

### Database Engine
- **RDBMS**: MySQL/MariaDB
- **Storage Engine**: InnoDB
- **Character Set**: UTF-8
- **Collation**: utf8_general_ci

### Struktur Database
```
laundry_db/
├── pelanggan (customers)
├── karyawan (employees)
├── layanan (services)
├── produk_persediaan (inventory)
├── pesanan (orders)
├── detail_pesanan (order_details)
└── log_persediaan (inventory_logs)
```

## 🔗 Entity Relationship Diagram (ERD)
```
[Pelanggan] --1:M--> [Pesanan] --1:M--> [Detail Pesanan]
                         |                    |
                      1:M|                    |M:1
                         |                    v
[Karyawan] --1:M--> [Pesanan]           [Layanan]
                         |
                      1:M|
                         v
                  [Log Persediaan] <--M:1-- [Produk Persediaan]
```

## 💾 Spesifikasi Tabel

### 1. Tabel Pelanggan
- **Primary Key**: id_pelanggan (AUTO_INCREMENT)
- **Unique Constraints**: nomor_telepon, email
- **Nullable Fields**: email, catatan_pelanggan
- **Indexes**: nomor_telepon, email

### 2. Tabel Karyawan
- **Primary Key**: id_karyawan (AUTO_INCREMENT)
- **ENUM Values**: posisi (kasir, operator, supervisor, manager)
- **Business Rule**: Setiap pesanan harus ditangani oleh karyawan

### 3. Tabel Layanan
- **Primary Key**: id_layanan (AUTO_INCREMENT)
- **ENUM Values**: satuan (kg, pcs, set)
- **Business Rule**: Harga tidak boleh negatif

### 4. Tabel Produk Persediaan
- **Primary Key**: id_produk (AUTO_INCREMENT)
- **ENUM Values**: satuan (liter, kg, pcs, botol)
- **Business Rule**: Stok tidak boleh negatif

### 5. Tabel Pesanan
- **Primary Key**: id_pesanan (AUTO_INCREMENT)
- **Foreign Keys**: id_pelanggan, id_karyawan
- **ENUM Values**: 
  - status (menunggu, diproses, selesai, diambil, batal)
  - status_pembayaran (belum_bayar, dp, lunas)
  - metode_pembayaran (tunai, transfer, e_wallet, kartu_kredit)

### 6. Tabel Detail Pesanan
- **Primary Key**: id_detail (AUTO_INCREMENT)
- **Foreign Keys**: id_pesanan, id_layanan
- **Business Rule**: Subtotal = jumlah × harga_saat_transaksi

### 7. Tabel Log Persediaan
- **Primary Key**: id_log (AUTO_INCREMENT)
- **Foreign Keys**: id_produk, id_pesanan (nullable)
- **ENUM Values**: jenis_pergerakan (masuk, keluar, koreksi)
- **Business Rule**: Tracking semua pergerakan stok

## 🚀 Cara Instalasi & Setup

### Prerequisites
- MySQL 5.7+ atau MariaDB 10.2+
- MySQL Workbench atau phpMyAdmin (optional)

### Langkah Instalasi
1. **Clone Repository**
   ```bash
   git clone https://github.com/DimasVSuper/uji-basis-data-manajemen-laundry-kelompok-7.git
   cd uji-basis-data-manajemen-laundry-kelompok-7
   ```

2. **Import Database**
   ```bash
   mysql -u root -p < laundry_db.sql
   ```

3. **Verifikasi Database**
   ```sql
   USE laundry_db;
   SHOW TABLES;
   SELECT COUNT(*) FROM pelanggan;
   ```

## 📊 Data Sample
Database sudah dilengkapi dengan data dummy untuk testing:
- **5 Pelanggan** dengan data realistis
- **5 Karyawan** dengan berbagai posisi
- **6 Layanan** laundry umum
- **5 Produk Persediaan** bahan cuci
- **5 Pesanan** dengan status berbeda
- **9 Detail Pesanan** dengan kombinasi layanan
- **7 Log Persediaan** untuk tracking stok

## 🔍 Contoh Query & Use Cases

### 1. Laporan Pesanan Harian
```sql
SELECT 
    p.id_pesanan,
    pel.nama_pelanggan,
    p.tanggal_masuk,
    p.status,
    p.total_akhir
FROM pesanan p
JOIN pelanggan pel ON p.id_pelanggan = pel.id_pelanggan
WHERE DATE(p.tanggal_masuk) = CURDATE()
ORDER BY p.tanggal_masuk DESC;
```

### 2. Tracking Stok Persediaan
```sql
SELECT 
    pp.nama_produk,
    pp.stok_saat_ini,
    pp.satuan,
    CASE 
        WHEN pp.stok_saat_ini < 5 THEN 'Stok Menipis'
        WHEN pp.stok_saat_ini < 10 THEN 'Stok Sedang'
        ELSE 'Stok Aman'
    END as status_stok
FROM produk_persediaan pp
ORDER BY pp.stok_saat_ini ASC;
```

### 3. Laporan Pendapatan per Layanan
```sql
SELECT 
    l.nama_layanan,
    COUNT(dp.id_detail) as total_transaksi,
    SUM(dp.subtotal) as total_pendapatan,
    AVG(dp.subtotal) as rata_rata_transaksi
FROM layanan l
JOIN detail_pesanan dp ON l.id_layanan = dp.id_layanan
JOIN pesanan p ON dp.id_pesanan = p.id_pesanan
WHERE p.status_pembayaran = 'lunas'
GROUP BY l.id_layanan, l.nama_layanan
ORDER BY total_pendapatan DESC;
```

### 4. Pelanggan Terbaik
```sql
SELECT 
    pel.nama_pelanggan,
    pel.nomor_telepon,
    COUNT(p.id_pesanan) as jumlah_pesanan,
    SUM(p.total_akhir) as total_belanja,
    AVG(p.total_akhir) as rata_rata_belanja
FROM pelanggan pel
JOIN pesanan p ON pel.id_pelanggan = p.id_pelanggan
WHERE p.status_pembayaran = 'lunas'
GROUP BY pel.id_pelanggan
HAVING COUNT(p.id_pesanan) >= 2
ORDER BY total_belanja DESC;
```

## 🔐 Keamanan Database

### Foreign Key Constraints
- **ON DELETE RESTRICT**: pelanggan, karyawan, layanan, produk_persediaan
- **ON DELETE CASCADE**: detail_pesanan (hapus otomatis jika pesanan dihapus)
- **ON DELETE SET NULL**: log_persediaan (set NULL jika pesanan dihapus)

### Data Validation
- **UNIQUE Constraints**: nomor_telepon, email pelanggan
- **NOT NULL Constraints**: field wajib diisi
- **ENUM Constraints**: membatasi nilai yang valid
- **DEFAULT Values**: nilai default untuk field opsional

## 📈 Performance Optimization

### Indexing Strategy
- Primary keys (automatic clustered index)
- Foreign keys (automatic index)
- Unique constraints (automatic unique index)
- Composite index pada (tanggal_masuk, status) untuk query laporan

### Best Practices
- Gunakan prepared statements untuk mencegah SQL injection
- Implementasi connection pooling untuk aplikasi
- Regular backup database
- Monitor slow query log

## 🧪 Testing & Validation

### Test Cases Tersedia
1. **CRUD Operations**: INSERT, SELECT, UPDATE, DELETE
2. **JOIN Queries**: Inner join, left join
3. **Aggregate Functions**: COUNT, SUM, AVG, GROUP BY
4. **Subqueries**: Nested queries untuk laporan kompleks
5. **Data Integrity**: Foreign key constraints
6. **Business Logic**: Status workflow pesanan

### Validation Results
- ✅ Semua tabel terbuat dengan benar
- ✅ Data dummy berhasil di-insert
- ✅ Foreign key constraints berfungsi
- ✅ ENUM constraints berfungsi
- ✅ Semua query test berjalan lancar

## 📝 Catatan Pengembangan

### Known Issues
- Tidak ada trigger untuk auto-update stok (disengaja untuk kesederhanaan)
- Tidak ada audit trail untuk perubahan data
- Belum ada hash untuk password karyawan

### Future Improvements
- Implementasi sistem notifikasi stok menipis
- Tambah tabel untuk pelacakan pembayaran detail
- Implementasi sistem discount dan promo
- Integrasi dengan sistem point of sale (POS)

## 📞 Support & Contact
Untuk pertanyaan atau bantuan terkait database ini, silahkan hubungi:
- **Lead Admin**: Dimas Bayu Nugroho (19240384)
- **Project**: Uji Basis Data Manajemen Laundry - PT Zahir International
- **Repository**: [GitHub Repository](https://github.com/DimasVSuper/uji-basis-data-manajemen-laundry-kelompok-7)

---
*Dokumentasi ini dibuat sebagai bagian dari Uji Basis Data Manajemen Laundry dari PT Zahir International - Semester 2*