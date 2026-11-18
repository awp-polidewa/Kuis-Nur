# Model Data Supabase

Rancangan ini sengaja kecil untuk kebutuhan satu kios. Gunakan PostgreSQL Supabase dan buat perubahan skema melalui SQL migration yang tersimpan di repository.

## 1. Aturan umum data

- Semua tabel bisnis memiliki `id` UUID sebagai primary key.
- Semua tabel bisnis memiliki `owner_id UUID NOT NULL REFERENCES auth.users(id)`.
- Terapkan RLS pada semua tabel bisnis. Pengguna hanya dapat melakukan operasi terhadap baris dengan `owner_id = auth.uid()`.
- Nominal uang disimpan sebagai integer rupiah (`BIGINT`), bukan `float`.
- Kuantitas stok/penjualan menggunakan `NUMERIC(12,3)` agar dapat menyimpan nilai seperti 0,5 kg.
- Simpan timestamp dalam `TIMESTAMPTZ`; tampilkan sesuai `Asia/Makassar`.
- Tabel yang menjadi histori transaksi menggunakan `created_at` dan tanggal bisnis yang relevan.

## 2. Tabel

### `products`

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | uuid | Primary key |
| owner_id | uuid | Pemilik data |
| name | text | Nama produk, wajib |
| unit | text | Satuan, contoh pcs/kg/liter |
| cost_price | bigint | Harga modal per satuan |
| selling_price | bigint | Harga jual per satuan |
| current_stock | numeric(12,3) | Stok saat ini |
| min_stock | numeric(12,3) | Batas stok minimum |
| is_active | boolean | Default true |
| created_at | timestamptz | Waktu dibuat |
| updated_at | timestamptz | Waktu diperbarui |

### `customers`

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | uuid | Primary key |
| owner_id | uuid | Pemilik data |
| name | text | Nama pelanggan, wajib |
| phone | text nullable | Nomor telepon opsional |
| notes | text nullable | Catatan opsional |
| created_at | timestamptz | Waktu dibuat |

Tidak perlu akun autentikasi pelanggan.

### `sales`

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | uuid | Primary key |
| owner_id | uuid | Pemilik data |
| customer_id | uuid nullable | Wajib untuk bon; nullable untuk tunai |
| payment_type | text | `cash` atau `bon` |
| transaction_at | timestamptz | Tanggal/waktu transaksi |
| total_amount | bigint | Total transaksi dalam rupiah |
| cash_received | bigint nullable | Wajib untuk tunai |
| change_amount | bigint nullable | Kembalian transaksi tunai |
| created_at | timestamptz | Waktu dibuat |

Validasi CHECK yang disarankan: `payment_type` hanya `cash`/`bon`; untuk `bon`, `customer_id` wajib; untuk `cash`, uang diterima minimal sebesar total.

### `sale_items`

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | uuid | Primary key |
| owner_id | uuid | Pemilik data |
| sale_id | uuid | FK ke `sales` |
| product_id | uuid | FK ke `products` |
| product_name_snapshot | text | Nama produk saat transaksi |
| unit_snapshot | text | Satuan saat transaksi |
| quantity | numeric(12,3) | Jumlah terjual |
| unit_price | bigint | Harga jual snapshot |
| unit_cost | bigint | Harga modal snapshot |
| line_total | bigint | Total item yang dibulatkan ke rupiah |

Snapshot menjaga laporan lama tetap konsisten walaupun nama/harga produk diubah.

### `debt_payments`

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | uuid | Primary key |
| owner_id | uuid | Pemilik data |
| sale_id | uuid | FK ke transaksi bon |
| amount | bigint | Nominal pembayaran |
| payment_at | timestamptz | Tanggal pembayaran |
| note | text nullable | Catatan opsional |
| created_at | timestamptz | Waktu dibuat |

Saldo utang dihitung dari `sales.total_amount - SUM(debt_payments.amount)` untuk transaksi bon. Jangan menyimpan saldo duplikat jika belum ada kebutuhan nyata.

### `stock_movements`

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | uuid | Primary key |
| owner_id | uuid | Pemilik data |
| product_id | uuid | FK ke `products` |
| movement_type | text | `in`, `sale`, atau `adjustment` |
| quantity_change | numeric(12,3) | Perubahan bertanda: positif menambah, negatif mengurangi |
| reference_sale_id | uuid nullable | Diisi untuk pergerakan karena penjualan |
| note | text nullable | Alasan stok masuk/penyesuaian |
| created_at | timestamptz | Waktu dibuat |

Untuk `in`, perubahan harus positif. Untuk `sale`, perubahan negatif. Untuk `adjustment`, bisa positif atau negatif.

### `expenses`

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | uuid | Primary key |
| owner_id | uuid | Pemilik data |
| expense_date | date | Tanggal pengeluaran |
| category | text | Kategori pengeluaran |
| description | text nullable | Keterangan |
| amount | bigint | Nominal rupiah, harus lebih dari nol |
| created_at | timestamptz | Waktu dibuat |

## 3. Relasi utama

- Satu `customer` dapat memiliki banyak `sales`.
- Satu `sale` memiliki banyak `sale_items`.
- Satu transaksi bon dapat memiliki banyak `debt_payments`.
- Satu `product` memiliki banyak `sale_items` dan `stock_movements`.
- Satu `sale` dapat direferensikan oleh beberapa `stock_movements` (satu untuk setiap produk dalam transaksi).

## 4. Indeks minimum

Tambahkan indeks untuk kebutuhan query utama, misalnya:

- `products(owner_id, name)`.
- `customers(owner_id, name)`.
- `sales(owner_id, transaction_at)`.
- `sales(owner_id, customer_id, transaction_at)`.
- `sale_items(sale_id)`.
- `debt_payments(sale_id, payment_at)`.
- `stock_movements(owner_id, product_id, created_at)`.
- `expenses(owner_id, expense_date)`.

Jangan membuat indeks berlebihan sebelum ada query yang membutuhkannya.

## 5. Integritas dan transaksi database

### Membuat penjualan

Proses membuat penjualan harus atomik: validasi pemilik dan produk aktif, cek stok tersedia, hitung ulang harga/total di server/database, insert `sales`, insert `sale_items`, update stok, dan insert `stock_movements`. Jika salah satu gagal, seluruh perubahan dibatalkan.

Implementasi sederhana yang disarankan: satu PostgreSQL function/RPC khusus untuk menyimpan penjualan. Jangan melakukan beberapa request terpisah dari browser untuk langkah-langkah tersebut.

### Stok masuk/penyesuaian

Perubahan `products.current_stock` dan insert `stock_movements` harus berada dalam satu transaksi database. Gunakan fungsi database kecil atau mekanisme server yang menjamin atomisitas.

### Pembayaran bon

Validasi transaksi memang bon dan nominal pembayaran tidak melebihi sisa saldo. Gunakan operasi database yang aman terhadap pembayaran bersamaan agar saldo tidak menjadi negatif.

## 6. RLS dan keamanan

- Aktifkan RLS pada semua tabel di atas.
- Kebijakan SELECT/INSERT/UPDATE/DELETE harus membatasi `owner_id = auth.uid()`.
- `owner_id` ditetapkan dari sesi pengguna di sisi server; jangan percaya nilai owner_id dari form/browser.
- Relasi antar-data harus divalidasi agar pengguna tidak dapat mereferensikan data milik akun lain.
- Jangan pernah mengekspos Supabase service-role key di browser atau repository.
- Jangan mematikan RLS untuk mempermudah development.

## 7. Hal yang tidak diperlukan

- Tabel roles/permissions.
- Tabel branches/tenants.
- Tabel suppliers/purchase_orders.
- Tabel notification jobs.
- Tabel audit log generik.
- Tabel kategori yang terpisah untuk pengeluaran jika pilihan teks sudah cukup.
- Tabel saldo piutang terpisah yang menduplikasi nilai hasil perhitungan.
