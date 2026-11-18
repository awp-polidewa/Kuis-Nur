# Rencana Implementasi MVP

Kerjakan berurutan. Jangan membangun semua halaman sebagai mockup sekaligus lalu menunda integrasi database.

## Tahap 1 — Pemeriksaan repository dan setup

- Periksa apakah repository sudah memiliki aplikasi atau perubahan sebelumnya.
- Jika belum ada, buat scaffold SvelteKit + TypeScript.
- Pasang Tailwind CSS dan integrasi Supabase SSR yang diperlukan.
- Siapkan `.env.example`, konfigurasi adapter Vercel, dan format dasar proyek.
- Buat layout app shell dan halaman login.
- Jalankan type check dan build.

**Selesai bila:** aplikasi dapat dijalankan lokal, build berhasil, dan struktur dasar tidak berlebihan.

## Tahap 2 — Database dan autentikasi

- Buat SQL migration untuk tabel pada `data-model.md`.
- Tambahkan constraint, index minimum, RLS policies, dan function database yang diperlukan untuk transaksi atomik.
- Implementasikan login/logout dan proteksi route.
- Pastikan akun dibuat manual di Supabase Auth, tanpa register publik.

**Selesai bila:** login berfungsi dan semua query terbatasi oleh owner/RLS.

## Tahap 3 — Produk dan stok

- Implementasikan tambah/edit/nonaktif produk.
- Implementasikan daftar dan pencarian produk.
- Implementasikan stok masuk dan penyesuaian.
- Simpan stock movements.
- Implementasikan peringatan stok menipis.

**Selesai bila:** data produk tersimpan di Supabase dan semua perubahan stok tercatat.

## Tahap 4 — Kasir dan transaksi

- Implementasikan katalog/pencarian produk dan keranjang.
- Implementasikan pembayaran tunai dan penghitungan kembalian.
- Implementasikan transaksi bon dengan pelanggan.
- Buat proses penyimpanan transaksi atomik sesuai `data-model.md`.
- Uji stok tidak negatif dan tidak ada partial transaction.

**Selesai bila:** transaksi tersimpan, histori dapat dibaca, dan stok diperbarui konsisten.

## Tahap 5 — Buku utang

- Implementasikan daftar pelanggan dan saldo utang.
- Implementasikan detail transaksi bon.
- Implementasikan pembayaran sebagian/pelunasan.
- Implementasikan status dan umur utang.

**Selesai bila:** saldo/status selalu berasal dari total transaksi bon dikurangi pembayaran.

## Tahap 6 — Laporan dan pengeluaran

- Implementasikan input pengeluaran.
- Implementasikan filter harian/bulanan.
- Implementasikan total omzet, pemisahan tunai/bon, penerimaan pembayaran bon, piutang, estimasi laba kotor dan bersih.
- Pastikan rentang tanggal memakai zona waktu kios.

**Selesai bila:** perhitungan mengikuti `business-rules.md` dan dapat diuji dengan data contoh.

## Tahap 7 — Polishing dan deployment

- Terapkan layout editorial Bento Grid tanpa mengurangi kemudahan operasional.
- Periksa desktop dan smartphone.
- Perbaiki empty/loading/error states.
- Jalankan semua pemeriksaan yang tersedia dan checklist `acceptance-criteria.md`.
- Deploy ke Vercel dan konfigurasi environment variables.
- Uji login serta operasi database pada URL deployment.

**Selesai bila:** MVP berjalan end-to-end pada deployment Vercel dengan Supabase.

## Aturan saat mengerjakan

- Selesaikan satu tahap secara fungsional sebelum menambah detail visual tahap berikutnya.
- Jangan menambahkan fitur di luar PRD.
- Jangan mengarang data asli. Gunakan data dummy hanya untuk development/test.
- Bila waktu terbatas, prioritaskan alur kasir, stok, bon, dan laporan yang benar daripada animasi.
