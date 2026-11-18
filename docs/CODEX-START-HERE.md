# Instruksi Awal untuk Codex

Salin instruksi ini sebagai tugas awal Codex saat membuka repository.

---

Baca `AGENTS.md` dan seluruh dokumen di `docs/` sebelum mengubah kode. Dokumen tersebut adalah spesifikasi dan batas ruang lingkup proyek Sistem Kasir & Stok Kios Nur.

Tugasmu adalah membangun MVP yang benar-benar berfungsi menggunakan SvelteKit, TypeScript, Tailwind CSS, Supabase PostgreSQL/Auth, dan deployment Vercel. Ikuti `docs/implementation-plan.md` secara bertahap dan gunakan `docs/acceptance-criteria.md` untuk memeriksa hasil.

Aturan paling penting:

1. Jangan over-engineering. Bangun hanya yang tercantum dalam PRD.
2. Jangan membuat toko online, multi-cabang, role kompleks, supplier kompleks, payment gateway, integrasi WhatsApp, mode offline, atau fitur lain di luar scope.
3. Prioritaskan ketepatan transaksi, pengurangan stok, saldo bon, dan perhitungan laporan.
4. Gunakan Supabase RLS untuk melindungi data pemilik.
5. Proses transaksi penjualan harus atomik: simpan transaksi, item, dan pengurangan stok sebagai satu kesatuan.
6. Gunakan snapshot harga modal/harga jual pada item transaksi agar laporan historis tidak berubah saat harga produk diedit.
7. Terapkan desain editorial asymmetric Bento Grid dengan identitas ungu/off-white sesuai `docs/design-guidelines.md` dan gambar di `docs/references/`. Jangan menyalin struktur toko fashion dari referensi.
8. Mobile usability adalah prioritas karena aplikasi digunakan di smartphone Android.
9. Jangan mengisi data produksi dengan data dummy.
10. Jangan menyatakan fitur/build selesai sebelum implementasi dan pengujian terkait benar-benar dilakukan.

Langkah pertama:

- Periksa isi repository dan laporkan kondisi awalnya.
- Jika sudah ada proyek, pertahankan pekerjaan yang valid dan jangan menimpa tanpa alasan.
- Berikan rencana kerja ringkas sesuai tahapan implementasi.
- Mulai Tahap 1 dan lanjutkan implementasi secara berurutan. Jangan berhenti pada rancangan atau mockup.
- Pada akhir setiap tahap, laporkan file penting yang dibuat/diubah, pemeriksaan yang dijalankan, hasilnya, dan hal yang belum selesai.

Jika ada detail yang tidak disebutkan, pilih solusi paling sederhana yang konsisten dengan dokumen. Catat asumsi penting; jangan memperluas scope sendiri.

---
