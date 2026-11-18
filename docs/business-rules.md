# Aturan Bisnis

Dokumen ini menjadi acuan utama untuk perhitungan dan perilaku data. Jangan mengubah aturan ini diam-diam.

## 1. Umum

- Mata uang: Rupiah (IDR), tanpa pecahan desimal pada penyimpanan nominal.
- Zona waktu tampilan: `Asia/Makassar`.
- Semua tanggal laporan menggunakan rentang tanggal lokal yang dipilih pengguna.
- Satu akun pemilik mengelola data satu kios.
- Pelanggan tidak memiliki akun login.

## 2. Produk dan satuan

Setiap produk minimal memiliki:

- nama produk;
- satuan yang dipakai dalam penjualan/stok (contoh: pcs, bungkus, kg, liter, karung);
- harga modal per satuan;
- harga jual per satuan;
- jumlah stok saat ini;
- batas stok minimum;
- status aktif/nonaktif.

Jumlah untuk satuan `pcs` dan `bungkus` harus berupa bilangan bulat. Satuan berbobot/bervolume seperti `kg` atau `liter` dapat berupa pecahan hingga tiga angka desimal. Tidak perlu sistem konversi antar-satuan. Pemilik harus memasukkan stok dan jumlah penjualan dalam satuan yang sama.

Harga modal dan harga jual harus bernilai nol atau lebih; untuk produk yang dijual, harga jual harus lebih dari nol. Stok tidak boleh menjadi negatif.

Seluruh form nominal menerima angka integer Rupiah dengan awalan `Rp` dan pemisah ribuan otomatis (contoh input `100000` menjadi `Rp100.000`). Nilai yang dikirim ke server dan disimpan tetap integer Rupiah. Pilihan satuan pada form tambah barang adalah `pcs`, `bungkus`, dan `kg`.

## 3. Transaksi penjualan

- Satu transaksi berisi satu atau lebih item.
- Total transaksi dihitung dari jumlah × harga jual setiap item.
- Harga jual dan harga modal produk disalin ke item transaksi sebagai snapshot saat penjualan dibuat. Perubahan harga produk setelahnya tidak mengubah riwayat transaksi.
- Transaksi hanya dianggap berhasil jika data penjualan, item penjualan, dan pengurangan stok berhasil seluruhnya.
- Jika salah satu proses gagal, seluruh proses penyimpanan transaksi harus dibatalkan.
- Produk nonaktif tidak dapat dipilih untuk transaksi baru.
- Transaksi yang melebihi stok tersedia harus ditolak dengan pesan yang jelas.
- MVP tidak menyediakan edit/hapus transaksi yang sudah berhasil. Jangan menghapus riwayat penjualan.

### 3.1 Transaksi tunai

- Jenis pembayaran: `cash`.
- Uang diterima harus sama dengan atau lebih besar dari total transaksi.
- Kembalian = uang diterima - total transaksi.
- Nilai uang diterima dan kembalian disimpan pada transaksi.
- Transaksi tunai tidak menambah piutang.

### 3.2 Transaksi bon

- Jenis pembayaran: `bon`.
- Pelanggan wajib dipilih atau dibuat sebelum penyimpanan.
- Total transaksi menjadi piutang awal pelanggan.
- Pembayaran awal tidak termasuk dalam flow MVP transaksi bon; pembayaran dilakukan melalui Buku Utang.
- Transaksi bon mengurangi stok dengan cara yang sama seperti transaksi tunai.

## 4. Buku utang

- Sisa utang per transaksi = total transaksi bon - jumlah seluruh pembayaran yang tercatat untuk transaksi tersebut.
- Total piutang pelanggan = jumlah sisa utang semua transaksi bon milik pelanggan.
- Pembayaran harus lebih besar dari nol dan tidak boleh melebihi sisa utang.
- Pembayaran boleh dilakukan sebagian atau sekaligus.
- Status dihitung dari saldo:
  - `Belum Dibayar`: total pembayaran = 0.
  - `Dibayar Sebagian`: total pembayaran > 0 dan sisa utang > 0.
  - `Lunas`: sisa utang = 0.
- Umur utang (hari) dihitung dari tanggal transaksi bon sampai tanggal hari ini. Untuk transaksi lunas, boleh tampilkan umur sampai tanggal pelunasan terakhir bila dibutuhkan; jangan membuat proses aging akuntansi kompleks.
- Pembayaran bon bukan penjualan baru dan tidak boleh menambah omzet penjualan lagi.
- Riwayat pembayaran harus disimpan, tidak menimpa transaksi bon awal.

## 5. Stok barang

Stok berubah melalui tiga sumber:

1. **Stok masuk:** menambah stok.
2. **Penjualan:** mengurangi stok berdasarkan item transaksi.
3. **Penyesuaian:** menambah/mengurangi stok karena koreksi fisik, disertai alasan singkat.

Setiap perubahan stok harus membuat catatan pergerakan stok. Nilai stok saat ini harus konsisten dengan perubahan yang disimpan.

- Stok menipis jika `current_stock <= min_stock`.
- Stok masuk harus memiliki jumlah lebih besar dari nol.
- Penyesuaian tidak boleh menyebabkan stok negatif.
- Harga beli pada stok masuk boleh diisi. Jika diisi, perbarui harga modal produk untuk transaksi berikutnya. Harga modal pada transaksi yang sudah terjadi tetap menggunakan snapshot lama.
- Tidak perlu menyimpan supplier atau membuat purchase order.

## 6. Pengeluaran operasional

Setiap pengeluaran memiliki:

- tanggal;
- kategori;
- keterangan singkat;
- nominal lebih besar dari nol.

Kategori boleh menggunakan pilihan sederhana seperti Transportasi, Listrik, Operasional Lainnya, dan Lainnya. Kategori dapat disimpan sebagai teks agar mudah disesuaikan tanpa membuat tabel kategori tersendiri.

Pengeluaran dicatat terpisah dari transaksi pembelian stok. Biaya pembelian stok tercermin pada harga modal barang dan bukan otomatis pengeluaran operasional, untuk menghindari pengurangan ganda dalam estimasi laba.

## 7. Definisi laporan

Untuk rentang tanggal yang dipilih:

- **Total penjualan/omzet:** jumlah total semua transaksi tunai dan bon berdasarkan tanggal transaksi.
- **Penjualan tunai:** jumlah transaksi berjenis tunai.
- **Penjualan bon:** jumlah transaksi berjenis bon.
- **Penerimaan pembayaran bon:** jumlah pembayaran utang yang diterima pada tanggal pembayaran. Tampilkan terpisah; jangan ditambahkan ke omzet.
- **Piutang berjalan:** total saldo belum lunas sampai saat ini, bukan hanya transaksi yang dibuat pada periode laporan.
- **Estimasi laba kotor:** jumlah dari `(harga jual snapshot - harga modal snapshot) × jumlah` setiap item pada transaksi yang tanggalnya berada dalam rentang laporan.
- **Total pengeluaran:** jumlah pengeluaran operasional yang tanggalnya berada dalam rentang laporan.
- **Estimasi laba bersih:** estimasi laba kotor - total pengeluaran pada rentang yang sama.

Rumus ini merupakan estimasi sederhana, bukan laporan akuntansi resmi. Jangan menyebutnya laba bersih final atau arus kas.

## 8. Dashboard

- Angka penjualan hari ini berdasarkan tanggal transaksi lokal.
- Total bon/piutang adalah saldo semua transaksi bon yang belum lunas.
- Daftar stok menipis memakai aturan `current_stock <= min_stock`.
- Pembayaran bon yang diterima hari ini ditampilkan terpisah dari penjualan hari ini bila komponen tersebut ditampilkan.

## 9. Validasi minimum

- Nama produk dan nama pelanggan tidak boleh kosong.
- Nominal uang tidak boleh negatif.
- Jumlah item penjualan dan stok masuk harus positif.
- Pembayaran bon tidak boleh melebihi saldo.
- Transaksi bon wajib memiliki pelanggan.
- Transaksi tunai wajib memiliki uang diterima yang cukup.
- Stok tidak boleh negatif, termasuk pada transaksi bersamaan.
