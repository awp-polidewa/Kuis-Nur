# Panduan Desain UI/UX

## 1. Arah visual

Gunakan gaya **editorial Bento Grid / asymmetric cards** dari `references/design-reference-editorial-bento.png`, dikombinasikan dengan identitas ungu-putih dari `references/design-reference-purple-storefront.png`.

Referensi adalah inspirasi komposisi dan karakter visual, bukan template untuk disalin. Ini tetap aplikasi kasir internal; fungsi dan keterbacaan lebih penting daripada dekorasi.

## 2. Karakter desain

- Editorial dan modern, dengan komposisi panel yang tidak semuanya berukuran sama.
- Bento Grid asimetris untuk ringkasan dashboard dan halaman laporan.
- Background off-white/abu hangat, card terang, serta panel aksen ungu.
- Sudut card membulat dan jarak antarkomponen cukup lega.
- Tipografi judul tegas; angka penting dapat berukuran besar.
- Gunakan ikon sederhana dan konsisten.
- Gunakan ilustrasi/foto hanya jika memberi manfaat; tidak perlu gambar dekoratif untuk setiap card.

## 3. Palet warna

Palet aplikasi memakai merah dan nuansa netral hangat. Sidebar memakai krem `#FAF7F2`, sementara area utama, kartu, panel, dan header memakai putih `#FFFFFF`. Tombol utama memakai merah terang dan logo memakai crimson dengan aksen salmon.

| Token | Warna | Kegunaan |
|---|---|---|
| Sidebar | `#FAF7F2` | Latar navigasi samping |
| Background utama | `#FFFFFF` | Latar area konten, kartu, panel, dan header |
| Crimson | `#C41E3A` | Logo dan aksen penting |
| Merah terang | `#E8504A` | Tombol utama dan CTA |
| Salmon | `#F4A0A0` | Lapisan aksen logo |
| Beige gelap | `#D9CFC4` | Border dan pemisah |
| Teks utama | `#1F1B18` | Judul dan isi utama |
| Teks sekunder | `#7A726B` | Deskripsi dan label sekunder |

Pastikan kontras teks cukup. Gunakan teks putih pada tombol merah terang dan teks gelap di atas latar netral.

## 4. Layout aplikasi

### Desktop

- Gunakan app shell dengan navigasi samping sederhana dan area konten utama.
- Header berisi nama halaman, tanggal/konteks seperlunya, dan menu akun.
- Konten utama memakai grid responsif dengan ukuran card bervariasi.
- Tabel panjang boleh memakai lebar penuh; jangan dipaksa menjadi card asimetris jika membuat data sulit dibaca.

### Mobile

- Mobile harus menjadi prioritas karena pemilik menggunakan smartphone Android.
- Navigasi dapat memakai bottom navigation ringkas atau menu yang mudah dijangkau.
- Form kasir, pembayaran bon, dan tambah stok harus nyaman digunakan satu tangan.
- Input angka memakai keyboard numerik jika memungkinkan.
- Tombol aksi utama memiliki area sentuh yang cukup.
- Hindari tabel yang meluber; gunakan daftar/card ringkas atau horizontal scroll yang jelas bila memang dibutuhkan.

## 5. Pola halaman

### Dashboard

- Satu panel utama untuk penjualan hari ini atau ringkasan paling penting.
- Card kecil untuk jumlah transaksi, piutang, dan estimasi keuntungan.
- Panel daftar stok menipis dan aktivitas terbaru.
- Gunakan komposisi asimetris; jangan membuat semua statistik menjadi card kecil seragam.

### Kasir

- Prioritaskan kecepatan: pencarian produk, daftar hasil, keranjang, total, dan pembayaran.
- Desktop dapat memakai layout dua kolom: katalog dan keranjang.
- Mobile dapat menampilkan katalog terlebih dahulu lalu keranjang/checkout sebagai panel yang mudah dibuka.
- Jangan gunakan animasi yang memperlambat atau menghalangi input.

### Buku Utang

- Ringkasan piutang di bagian atas.
- Daftar pelanggan/utang dengan status jelas.
- Detail transaksi dan tombol catat pembayaran mudah ditemukan.

### Stok

- Ringkasan barang dan stok menipis.
- Tabel/list barang tetap jelas dan efisien.
- Form tambah/edit/stok masuk tidak dibuat terlalu panjang.

### Laporan

- Ringkasan angka utama dan grafik sederhana bila membantu.
- Filter rentang tanggal mudah digunakan.
- Bedakan omzet, penerimaan pembayaran bon, piutang, laba kotor, pengeluaran, dan estimasi laba bersih.

## 6. Komponen dan interaksi

- Gunakan border radius konsisten, bukan bentuk berbeda-beda tanpa alasan.
- Gunakan shadow lembut seperlunya; jangan membuat semua panel melayang tebal.
- Tombol utama memakai primary; tombol destruktif memakai gaya peringatan yang jelas.
- Status bon: Belum Dibayar, Dibayar Sebagian, Lunas.
- Status stok: Normal dan Menipis/Habis.
- Modal/sheet untuk tindakan singkat; jangan membuka dialog bertumpuk.
- Konfirmasi hanya untuk tindakan yang berisiko atau tidak mudah dibatalkan.
- Selalu tampilkan feedback setelah simpan berhasil/gagal.

## 7. Animasi

Animasi bersifat opsional dan halus, misalnya transisi hover/focus atau masuk panel ringan. Jangan membuat animasi scroll berat, parallax, efek presentasi, atau animasi yang mengganggu transaksi.

## 8. Hindari

- Tampilan template admin generik yang semua card-nya sama.
- Warna aksen digunakan pada semua elemen sekaligus.
- Terlalu banyak gradien, glow, blur, dan efek glassmorphism.
- Font dekoratif yang mengurangi keterbacaan.
- Ilustrasi stok foto yang tidak berkaitan dengan kios.
- Card dekoratif yang menghabiskan ruang di layar kasir.
- Mengorbankan tabel, form, atau angka demi estetika.
