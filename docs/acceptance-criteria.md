# Acceptance Criteria — Checklist MVP

Gunakan checklist ini untuk menguji hasil implementasi. Fitur tidak dianggap selesai hanya karena halaman tampil.

## 1. Login dan keamanan

- [ ] Pengguna dapat login dengan email/password pemilik.
- [ ] Pengguna yang belum login tidak dapat membuka halaman aplikasi.
- [ ] Pengguna dapat logout.
- [ ] Tidak ada halaman pendaftaran publik.
- [ ] Semua tabel bisnis memiliki RLS aktif.
- [ ] Pengguna hanya dapat membaca/mengubah data miliknya.
- [ ] Tidak ada service-role key atau secret di browser/repository.

## 2. Dashboard

- [ ] Penjualan hari ini sesuai transaksi pada tanggal lokal.
- [ ] Jumlah transaksi hari ini sesuai data.
- [ ] Penjualan tunai dan bon dapat dibedakan.
- [ ] Total piutang hanya menghitung saldo bon yang belum lunas.
- [ ] Stok menipis muncul saat stok <= batas minimum.
- [ ] Aktivitas terbaru menampilkan data dari Supabase.
- [ ] Ringkasan tidak menggunakan angka dummy pada produksi.

## 3. Produk dan stok

- [ ] Pemilik dapat menambah produk dengan nama, satuan, modal, harga jual, stok, dan batas minimum.
- [ ] Pemilik dapat mengubah data produk.
- [ ] Pemilik dapat menonaktifkan produk.
- [ ] Pemilik dapat mencari produk.
- [ ] Pemilik dapat mencatat stok masuk.
- [ ] Pemilik dapat melakukan penyesuaian stok dengan alasan.
- [ ] Setiap perubahan stok tercatat di stock movements.
- [ ] Stok tidak dapat menjadi negatif.
- [ ] Produk nonaktif tidak muncul untuk transaksi baru.

## 4. Kasir

- [ ] Pemilik dapat membuat keranjang dari beberapa produk.
- [ ] Jumlah item dapat diubah dan item dapat dihapus sebelum disimpan.
- [ ] Subtotal dan total dihitung dengan benar.
- [ ] Transaksi tunai meminta nominal uang diterima.
- [ ] Kembalian dihitung benar.
- [ ] Transaksi bon mewajibkan pelanggan.
- [ ] Transaksi berhasil menyimpan header dan seluruh item.
- [ ] Stok semua item berkurang sesuai jumlah yang terjual.
- [ ] Jika salah satu bagian transaksi gagal, tidak ada transaksi parsial dan stok tidak berubah sebagian.
- [ ] Stok tidak dapat dijual melebihi stok tersedia, termasuk pada submit bersamaan.
- [ ] Ringkasan transaksi yang berhasil tampil.

## 5. Buku Utang

- [ ] Pemilik dapat menambah pelanggan.
- [ ] Daftar pelanggan menampilkan total piutang berjalan.
- [ ] Detail pelanggan menampilkan transaksi bon.
- [ ] Sisa utang dihitung sebagai total bon dikurangi seluruh pembayaran.
- [ ] Pembayaran sebagian dapat dicatat.
- [ ] Pelunasan penuh dapat dicatat.
- [ ] Pembayaran melebihi saldo ditolak.
- [ ] Status Belum Dibayar/Dibayar Sebagian/Lunas sesuai saldo.
- [ ] Umur utang ditampilkan dalam hari.
- [ ] Pembayaran bon tidak dihitung ulang sebagai omzet.

## 6. Pengeluaran dan laporan

- [ ] Pemilik dapat mencatat pengeluaran dengan tanggal, kategori, keterangan, dan nominal.
- [ ] Nominal nol/negatif ditolak.
- [ ] Pengeluaran dapat ditampilkan berdasarkan periode.
- [ ] Filter laporan harian/bulanan bekerja.
- [ ] Total omzet menggabungkan penjualan tunai dan bon berdasarkan tanggal transaksi.
- [ ] Penjualan tunai dan bon ditampilkan terpisah.
- [ ] Pembayaran bon tampil terpisah dari omzet.
- [ ] Estimasi laba kotor memakai snapshot harga jual dan modal per item.
- [ ] Total pengeluaran dihitung berdasarkan tanggal pengeluaran.
- [ ] Estimasi laba bersih = estimasi laba kotor - total pengeluaran.
- [ ] UI menggunakan istilah estimasi, bukan mengklaim laporan akuntansi resmi.

## 7. Desain dan usability

- [ ] Layout menggunakan arah editorial/asymmetric Bento Grid pada area ringkasan.
- [ ] Identitas utama ungu dan off-white konsisten.
- [ ] Semua halaman responsif di smartphone Android.
- [ ] Navigasi mudah dipahami.
- [ ] Input angka mudah digunakan pada smartphone.
- [ ] Loading, empty state, error state, dan feedback simpan tersedia.
- [ ] Form kasir tidak dipenuhi dekorasi atau animasi.
- [ ] Teks, angka, tabel, dan status mudah dibaca.

## 8. Build dan deployment

- [ ] TypeScript check berhasil.
- [ ] Lint berhasil bila konfigurasi lint tersedia.
- [ ] Test yang tersedia berhasil.
- [ ] Build production berhasil.
- [ ] Migration SQL tersedia dalam repository.
- [ ] Environment variables terdokumentasi di `.env.example`.
- [ ] Aplikasi terhubung ke project Supabase yang benar.
- [ ] URL deployment Vercel dapat dibuka dan login/data diuji.
