# Catatan Sumber: Wawancara dan Sitemap

Dokumen ini memisahkan fakta dari laporan mitra dan keputusan desain produk. Jangan menganggap ide tambahan sebagai fakta wawancara.

## 1. Fakta dari laporan observasi/wawancara

Sumber: `references/laporan-wawancara-kios-nur.pdf`.

- **Profil usaha (halaman 3):** Kios Nur adalah usaha ritel eceran yang menjual sembako, jajanan, minuman dingin, dan perlengkapan rumah tangga harian.
- **Kegiatan utama (halaman 3):** penjualan langsung tunai dan bon harian, belanja mingguan ke agen grosir pusat, pencatatan manual, dan pengecekan stok secara visual.
- **Hasil wawancara (halaman 5):** utang pelanggan kadang lupa dicatat ketika kios ramai; pemilik kesulitan menghitung keuntungan bersih bulanan; barang laris seperti beras dan minyak dapat kehabisan stok secara mendadak.
- **Hasil observasi (halaman 5):** penjualan dihitung menggunakan kalkulator; harga barang belum memiliki label tempel; nota dan catatan bon menumpuk tanpa arsip rapi.
- **Penggunaan teknologi (halaman 5):** pemilik aktif menggunakan smartphone Android; aplikasi utama adalah WhatsApp untuk memesan barang; belum pernah memakai aplikasi kasir/pencatatan toko.
- **Analisis kebutuhan (halaman 6):** pencatatan transaksi terstruktur, rekap/pemantauan utang pelanggan, dan pencatatan serta peringatan stok.
- **Profil pengguna (halaman 7):** pengelola utama menyukai tampilan simpel, mudah dioperasikan di smartphone, dan tidak memerlukan banyak langkah input.

## 2. Struktur sitemap yang diberikan

Sumber: `references/sitemap.png`.

- Login (autentikasi pemilik).
- Beranda/Dashboard: ringkasan pendapatan, laba, dan total bon.
- Menu Kasir Cepat: input transaksi tunai, input sistem bon, kalkulasi otomatis.
- Menu Buku Utang (Bon): daftar pelanggan bon, nominal dan lama hari, status pelunasan.
- Menu Stok Barang: data harga dan stok, update stok masuk, peringatan stok menipis.
- Menu Laporan Keuangan: rekap harian, rekap bulanan, estimasi laba bersih.

## 3. Keputusan produk yang disepakati dalam diskusi

Hal-hal berikut adalah keputusan proyek, bukan kutipan langsung laporan:

- Aplikasi berupa web online dan akan di-deploy ke Vercel.
- Supabase digunakan untuk PostgreSQL dan autentikasi.
- Framework yang digunakan adalah SvelteKit dengan TypeScript dan Tailwind CSS.
- Codex akan mengerjakan implementasi dengan mengikuti dokumen di repository.
- Satu pemilik menjadi pengguna aplikasi; pelanggan tidak perlu login.
- Pencatatan pengeluaran operasional sederhana menjadi bagian Laporan Keuangan.
- Gaya visual menggabungkan identitas ungu/putih dari referensi awal dengan layout editorial/asymmetric Bento Grid dari referensi kedua.
- Ruang lingkup dijaga sederhana dan hanya mencakup kebutuhan utama Kios Nur.

## 4. Catatan penggunaan referensi desain

- `design-reference-purple-storefront.png` dipakai sebagai inspirasi warna, rounded container, dan identitas visual. Struktur toko fashion, katalog publik, dan elemen belanja online tidak diadopsi.
- `design-reference-editorial-bento.png` dipakai sebagai inspirasi komposisi halaman, perbedaan ukuran panel, color blocking, tipografi, dan ritme visual. Konten presentasi/landing page tidak disalin.
- Gunakan kedua gambar secara adaptif agar aplikasi tetap terbaca dan cepat digunakan untuk transaksi.
