# Product Requirements Document (PRD)

**Produk:** Sistem Kasir & Stok Kios Nur  
**Versi:** 1.0 — MVP  
**Status:** Acuan implementasi  
**Target deployment:** Vercel + Supabase

## 1. Ringkasan produk

Sistem Kasir & Stok Kios Nur adalah aplikasi web internal untuk membantu pemilik kios mencatat penjualan tunai dan bon, memantau utang pelanggan, mengelola stok barang, serta melihat ringkasan keuangan. Aplikasi digunakan oleh pemilik melalui browser desktop atau smartphone Android dan selalu membutuhkan koneksi internet.

Tujuan utamanya adalah menggantikan pencatatan manual yang tersebar di buku dan kertas dengan alur digital yang sederhana. Aplikasi tidak ditujukan menjadi toko online atau sistem ERP.

## 2. Latar belakang dan masalah

Berdasarkan laporan observasi dan wawancara Kios Nur:

- Penjualan dan bon masih dicatat secara manual.
- Saat kios ramai, transaksi bon berisiko lupa dicatat.
- Riwayat transaksi lama sulit dicari dan rekap manual rawan selisih.
- Stok dipantau secara visual sehingga barang laris bisa habis tanpa diketahui.
- Pemilik kesulitan menghitung keuntungan bulanan.
- Pemilik menggunakan smartphone Android dan belum pernah memakai aplikasi kasir digital.

Rincian sumber dan halaman laporan tercantum di `source-notes.md`.

## 3. Tujuan produk

1. Mempercepat pencatatan transaksi penjualan.
2. Menyimpan transaksi tunai dan bon dengan riwayat yang dapat dicari.
3. Mengetahui jumlah piutang dan status pembayaran setiap pelanggan.
4. Mengetahui stok barang dan memberi peringatan ketika stok menipis.
5. Menyediakan rekap penjualan dan estimasi keuntungan harian/bulanan.
6. Mencatat pengeluaran operasional sederhana agar estimasi laba bersih lebih informatif.
7. Tetap mudah dipakai oleh pemilik yang baru pertama kali menggunakan aplikasi kasir digital.

## 4. Pengguna dan hak akses

### Pengguna utama — Pemilik Kios Nur

- Login menggunakan akun pemilik.
- Mengelola barang, pelanggan, transaksi, stok, pengeluaran, dan laporan.
- Tidak membutuhkan role atau permission yang berbeda.

### Pelanggan kios

Pelanggan adalah penerima manfaat layanan. Mereka tidak login dan tidak mengakses aplikasi. Data pelanggan hanya disimpan untuk mengaitkan transaksi bon dan pembayaran.

**Keputusan MVP:** hanya satu jenis pengguna aplikasi, yaitu pemilik. Tidak perlu pendaftaran akun publik atau sistem multi-role. Akun pemilik dibuat melalui Supabase Auth/dashboard oleh pengelola proyek.

## 5. Ruang lingkup fitur MVP

### 5.1 Login

- Form email dan password.
- Proteksi halaman aplikasi untuk pengguna yang belum login.
- Tombol logout.
- Tidak menyediakan pendaftaran akun publik.

### 5.2 Dashboard

Tampilkan ringkasan yang langsung berguna:

- Total penjualan hari ini.
- Jumlah transaksi hari ini.
- Penjualan tunai dan penjualan bon.
- Total piutang yang belum lunas.
- Estimasi laba kotor dan/atau estimasi laba bersih sesuai data yang tersedia.
- Daftar barang dengan stok mencapai atau di bawah batas minimum.
- Aktivitas transaksi terbaru.
- Akses cepat ke Kasir, tambah barang, dan catat pengeluaran.

Tidak perlu dashboard analitik kompleks. Gunakan kartu ringkas dan daftar yang mudah dipindai.

### 5.3 Kasir Cepat

- Cari dan pilih barang dari daftar produk aktif.
- Masukkan jumlah barang sesuai satuan produk.
- Tambah, ubah jumlah, atau hapus item dari keranjang sebelum transaksi disimpan.
- Hitung subtotal dan total otomatis.
- Pilih jenis transaksi: tunai atau bon.
- Untuk tunai: masukkan uang diterima dan tampilkan kembalian.
- Untuk bon: pilih pelanggan yang sudah terdaftar atau buat pelanggan baru secara sederhana; transaksi bon harus memiliki pelanggan.
- Simpan transaksi dan tampilkan ringkasan transaksi berhasil.
- Stok harus berkurang otomatis setelah transaksi berhasil.

### 5.4 Buku Utang (Bon)

- Daftar pelanggan dan total sisa utang.
- Daftar transaksi bon per pelanggan.
- Tampilkan nominal awal, jumlah yang telah dibayar, sisa utang, tanggal transaksi, umur utang (hari), dan status.
- Catat pembayaran sebagian atau pelunasan.
- Riwayat pembayaran dapat dilihat.
- Status utang dihitung otomatis: Belum Dibayar, Dibayar Sebagian, atau Lunas.
- Tidak perlu pengingat otomatis melalui WhatsApp/SMS.

### 5.5 Stok Barang

- Daftar barang dengan pencarian.
- Tambah dan edit barang.
- Data minimum: nama, satuan, harga modal, harga jual, stok saat ini, dan batas stok minimum.
- Catat stok masuk dengan jumlah dan, bila diperlukan, harga beli satuan terbaru.
- Catat penyesuaian stok manual dengan alasan singkat.
- Tampilkan peringatan stok menipis.
- Stok otomatis berkurang saat transaksi penjualan disimpan.
- Produk yang sudah memiliki riwayat transaksi dinonaktifkan, bukan dihapus permanen.

Tidak perlu modul pembelian, supplier, purchase order, atau gudang.

### 5.6 Laporan Keuangan

- Filter laporan berdasarkan tanggal atau bulan.
- Rekap penjualan harian dan bulanan.
- Tampilkan penjualan tunai dan penjualan bon secara terpisah.
- Tampilkan penerimaan pembayaran bon secara terpisah dari penjualan agar tidak dihitung ganda sebagai omzet.
- Tampilkan estimasi laba kotor berdasarkan harga jual dan harga modal yang tersimpan pada saat transaksi.
- Form pencatatan pengeluaran operasional: tanggal, kategori, keterangan, dan nominal.
- Tampilkan total pengeluaran pada rentang laporan.
- Estimasi laba bersih = estimasi laba kotor - total pengeluaran pada rentang yang sama.

Gunakan istilah **estimasi laba** karena aplikasi tidak melakukan akuntansi penuh dan hasilnya bergantung pada ketepatan harga modal serta pengeluaran yang dicatat.

## 6. Alur utama pengguna

### Alur A — Penjualan tunai

1. Pemilik membuka Kasir.
2. Mencari dan memilih barang.
3. Mengisi jumlah setiap barang.
4. Sistem menghitung total.
5. Pemilik memilih Tunai, mengisi uang diterima, lalu melihat kembalian.
6. Pemilik menyimpan transaksi.
7. Sistem menyimpan penjualan dan itemnya serta mengurangi stok secara konsisten.

### Alur B — Penjualan bon

1. Pemilik membuat keranjang seperti transaksi biasa.
2. Pemilik memilih Bon.
3. Pemilik memilih atau menambahkan nama pelanggan.
4. Pemilik menyimpan transaksi.
5. Sistem mencatat piutang untuk pelanggan dan mengurangi stok.

### Alur C — Pembayaran bon

1. Pemilik membuka Buku Utang.
2. Memilih pelanggan/transaksi bon.
3. Mengisi jumlah pembayaran.
4. Sistem memvalidasi agar pembayaran tidak melebihi sisa utang.
5. Sistem menyimpan pembayaran dan memperbarui status/sisa utang.

### Alur D — Stok masuk

1. Pemilik membuka Stok Barang.
2. Memilih barang.
3. Mengisi jumlah stok masuk dan opsional harga beli satuan terbaru.
4. Sistem menambah stok dan menyimpan riwayat pergerakan stok.

### Alur E — Pengeluaran

1. Pemilik membuka Laporan Keuangan.
2. Memilih Catat Pengeluaran.
3. Mengisi tanggal, kategori, keterangan, dan nominal.
4. Sistem menyimpan pengeluaran dan memasukkannya ke periode laporan terkait.

## 7. Kebutuhan nonfungsional

- Antarmuka berbahasa Indonesia.
- Responsif dan nyaman digunakan di smartphone Android.
- Penggunaan internet wajib; mode offline tidak termasuk MVP.
- Data hanya dapat diakses setelah login dan dilindungi RLS Supabase.
- Operasi penjualan dan perubahan stok harus konsisten, tidak boleh menghasilkan stok negatif.
- Gunakan rupiah (IDR) untuk semua nilai uang.
- Tanggal/jam ditampilkan sesuai zona waktu kios, yaitu `Asia/Makassar`.
- Form dibuat singkat, label jelas, tombol utama mudah dijangkau.
- Kondisi loading, data kosong, validasi, dan error harus ditangani.

## 8. Di luar ruang lingkup (non-goals)

Jangan membangun hal-hal berikut pada MVP:

- Toko online, katalog publik, checkout pelanggan, atau aplikasi pelanggan.
- Multi-cabang, multi-kios, atau multi-tenant.
- Banyak role pengguna dan permission matrix.
- Modul supplier, purchase order, dan pengadaan kompleks.
- Integrasi WhatsApp otomatis, SMS, email marketing, atau push notification.
- Payment gateway, QRIS/API bank, atau rekonsiliasi bank.
- Barcode scanning, printer struk, atau perangkat POS khusus.
- Mode offline, sinkronisasi offline, atau service worker kompleks.
- Akuntansi lengkap, pajak, neraca, arus kas formal, atau jurnal umum.
- Prediksi stok, AI, rekomendasi produk, dan analitik lanjutan.
- Dashboard drag-and-drop atau tema yang bisa dikustomisasi.

## 9. Definisi keberhasilan

MVP dinilai berhasil bila pemilik dapat menyelesaikan alur berikut tanpa bantuan teknis:

- Login dan melihat ringkasan kios.
- Menambahkan barang beserta harga dan stok awal.
- Melakukan transaksi tunai dan melihat kembalian.
- Melakukan transaksi bon untuk pelanggan.
- Mencatat pembayaran sebagian dan melihat sisa utang.
- Mencatat stok masuk dan melihat perubahan stok.
- Mengetahui barang yang stoknya menipis.
- Mencatat pengeluaran operasional.
- Melihat rekap penjualan serta estimasi laba pada periode tertentu.

## 10. Prioritas saat terjadi trade-off

Urutan prioritas implementasi:

1. Ketepatan transaksi, piutang, dan stok.
2. Kemudahan penggunaan di smartphone.
3. Kejelasan laporan dan estimasi keuntungan.
4. Konsistensi visual sesuai referensi.
5. Animasi/dekorasi hanya bila tidak mengganggu tiga prioritas pertama.
