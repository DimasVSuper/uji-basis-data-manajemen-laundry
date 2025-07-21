# 🧺 Database Laundry - Semester 2

## 📋 Deskripsi
Database ini dibuat untuk memenuhi tugas **Workshop Uji Basis Data**. Sistem ini digunakan untuk mengelola data laundry secara lengkap, mulai dari pelanggan, karyawan, layanan, produk persediaan, pesanan, detail pesanan, hingga log persediaan.

## 🗂️ Struktur Tabel

### 1. 👤 **Pelanggan**
| Kolom            | Tipe Data         | Keterangan                |
|------------------|------------------|---------------------------|
| id_pelanggan     | INT (PK, AI)     | ID unik pelanggan         |
| nama_pelanggan   | VARCHAR(100)     | Nama lengkap pelanggan    |
| nomor_telepon    | VARCHAR(15)      | Nomor telepon unik        |
| email            | VARCHAR(100)     | Email unik (boleh null)   |
| alamat           | TEXT             | Alamat pelanggan          |
| catatan_pelanggan| TEXT             | Catatan khusus            |

### 2. 👨‍💼 **Karyawan**
| Kolom         | Tipe Data     | Keterangan            |
|---------------|--------------|-----------------------|
| id_karyawan   | INT (PK, AI) | ID unik karyawan      |
| nama_karyawan | VARCHAR(100) | Nama karyawan         |
| posisi        | ENUM         | Posisi (kasir, operator, supervisor, manager) |

### 3. 🧼 **Layanan**
| Kolom          | Tipe Data      | Keterangan                |
|----------------|---------------|---------------------------|
| id_layanan     | INT (PK, AI)  | ID unik layanan           |
| nama_layanan   | VARCHAR(100)  | Nama layanan              |
| deskripsi      | TEXT          | Deskripsi layanan         |
| harga_per_unit | DECIMAL(10,2) | Harga per satuan layanan  |
| satuan         | ENUM          | Satuan (kg, pcs, set)     |
| estimasi_hari  | INT           | Estimasi hari pengerjaan  |

### 4. 📦 **Produk Persediaan**
| Kolom         | Tipe Data      | Keterangan                |
|---------------|---------------|---------------------------|
| id_produk     | INT (PK, AI)  | ID unik produk            |
| nama_produk   | VARCHAR(100)  | Nama produk persediaan    |
| stok_saat_ini | DECIMAL(10,2) | Stok produk saat ini      |
| satuan        | ENUM          | Satuan (liter, kg, pcs, botol) |

### 5. 📋 **Pesanan**
| Kolom                  | Tipe Data         | Keterangan                        |
|------------------------|------------------|-----------------------------------|
| id_pesanan             | INT (PK, AI)     | ID unik pesanan                   |
| id_pelanggan           | INT (FK)         | Relasi ke pelanggan               |
| id_karyawan            | INT (FK)         | Relasi ke karyawan                |
| tanggal_masuk          | DATETIME         | Tanggal masuk pesanan             |
| tanggal_estimasi_selesai| DATETIME        | Estimasi selesai                  |
| tanggal_selesai_aktual | DATETIME (null)  | Tanggal selesai aktual            |
| subtotal_biaya         | DECIMAL(12,2)    | Subtotal biaya                    |
| diskon                 | DECIMAL(12,2)    | Diskon                            |
| total_akhir            | DECIMAL(12,2)    | Total akhir setelah diskon        |
| status                 | ENUM             | Status pesanan                    |
| status_pembayaran      | ENUM             | Status pembayaran                 |
| metode_pembayaran      | ENUM             | Metode pembayaran                 |
| catatan                | TEXT             | Catatan pesanan                   |

### 6. 📝 **Detail Pesanan**
| Kolom                | Tipe Data      | Keterangan                |
|----------------------|---------------|---------------------------|
| id_detail            | INT (PK, AI)  | ID unik detail pesanan    |
| id_pesanan           | INT (FK)      | Relasi ke pesanan         |
| id_layanan           | INT (FK)      | Relasi ke layanan         |
| jumlah               | DECIMAL(10,2) | Jumlah layanan            |
| harga_saat_transaksi | DECIMAL(10,2) | Harga saat transaksi      |
| subtotal             | DECIMAL(12,2) | Subtotal detail pesanan   |

### 7. 📊 **Log Persediaan**
| Kolom            | Tipe Data      | Keterangan                |
|------------------|---------------|---------------------------|
| id_log           | INT (PK, AI)  | ID unik log persediaan    |
| id_produk        | INT (FK)      | Relasi ke produk persediaan |
| id_pesanan       | INT (FK/null) | Relasi ke pesanan (boleh null) |
| jenis_pergerakan | ENUM          | Jenis (masuk, keluar, koreksi) |
| jumlah           | DECIMAL(10,2) | Jumlah pergerakan         |
| tanggal_log      | TIMESTAMP     | Tanggal log               |
| keterangan       | TEXT          | Keterangan tambahan       |

## 🔗 Relasi Antar Tabel
- **pelanggan** → **pesanan** (one-to-many)
- **karyawan** → **pesanan** (one-to-many)
- **pesanan** → **detail_pesanan** (one-to-many)
- **layanan** → **detail_pesanan** (one-to-many)
- **produk_persediaan** → **log_persediaan** (one-to-many)
- **pesanan** → **log_persediaan** (one-to-many, nullable)

## 📁 File yang Tersedia
- `laundry_db.sql` - Script SQL lengkap dengan DDL, data dummy, dan skenario DML
- `readme.md` - Dokumentasi database ini

## 🎯 Fitur Database
- ✅ **DDL**: 7 tabel dengan relasi yang tepat
- ✅ **Data Dummy**: Data realistis untuk testing
- ✅ **DML Scenarios**: 10 contoh query (SELECT, INSERT, UPDATE, DELETE)
- ✅ **Foreign Keys**: Relasi antar tabel yang benar
- ✅ **Constraints**: NOT NULL, UNIQUE, DEFAULT values
- ✅ **ENUM Types**: Untuk pilihan nilai yang terbatas

## 👥 Peserta
- **Dimas Bayu Nugroho** (19240384) (Lead Administrator)
- **M. Riefalldo Ramadhan** (19241047) (Technical Writer)
- **Daulia Artika Samdani** (19240995) (Documentation & Report Writer)
- **Mochammad Rayhan** (19241572) (Documentation Analyst & Administrator)
- **Anis Nurbaiti** (19240071) (Documentation & Report Writer)
- **Raden Yudhistira Wicaksono** (19241616) (Technical Writer)
- **Ichwan Fauzan** (19240621) (Documentation Analyst)
- **Kristian Alexander Wily Wijaya** (19241815) (Technical Writer)

---

> 📚 **Tugas Basis Data Semester 2** | 📅 Dibuat pada: 10 Juli 2025
