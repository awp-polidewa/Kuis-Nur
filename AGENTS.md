## Project Configuration

- **Language**: TypeScript
- **Package Manager**: npm
- **Add-ons**: tailwindcss, sveltekit-adapter

---

# Aturan Kerja Codex — Sistem Kios Nur

Dokumen ini adalah instruksi wajib untuk setiap pekerjaan di repository ini. Baca sebelum membuat atau mengubah kode.

## 1. Sumber kebenaran

1. Baca `docs/README.md`, lalu seluruh dokumen yang relevan di folder `docs/` sebelum implementasi.
2. `docs/prd.md` menentukan kebutuhan produk dan batas ruang lingkup.
3. `docs/business-rules.md` menentukan perilaku dan perhitungan bisnis. Jangan mengubah rumus atau alur transaksi tanpa alasan yang terdokumentasi.
4. `docs/data-model.md` dan `docs/architecture.md` menentukan rancangan data dan arsitektur sederhana.
5. `docs/design-guidelines.md` menentukan arah visual. Gunakan gambar di `docs/references/` sebagai referensi, bukan untuk disalin mentah.
6. Bila ada konflik, prioritaskan: kebutuhan dan aturan bisnis di PRD/Business Rules, lalu keputusan teknis di Architecture/Data Model, lalu gaya visual di Design Guidelines. Laporkan konflik yang tidak dapat diselesaikan dari dokumen.

## 2. Prinsip utama: jangan over-engineering

- Bangun hanya fitur yang tercantum dalam PRD dan kriteria penerimaan.
- Pilih solusi paling sederhana yang aman, mudah dirawat, dan cukup untuk satu kios.
- Jangan menambah modul, role pengguna, layanan, abstraksi, dependensi, atau pola arsitektur hanya karena dianggap lebih canggih.
- Jangan membuat microservices, backend terpisah, Redis, queue, Docker, event bus, multi-tenant framework, atau state-management library tanpa kebutuhan nyata dan persetujuan eksplisit.
- Jangan membuat sistem plugin, permission matrix, konfigurasi generik, atau design system yang terlalu abstrak.
- Gunakan komponen bersama hanya jika benar-benar dipakai berulang. Hindari membuat abstraksi untuk satu penggunaan.
- Jangan mengubah pilihan teknologi yang sudah ditetapkan.
- Jangan membuat fitur toko online, multi-cabang, supplier kompleks, pembayaran online, WhatsApp otomatis, aplikasi pelanggan, atau mode offline.

## 3. Teknologi yang ditetapkan

- SvelteKit + TypeScript.
- Tailwind CSS untuk styling.
- Supabase PostgreSQL untuk database dan Supabase Auth untuk login.
- Deploy ke Vercel.
- Gunakan integrasi Supabase yang sesuai untuk SvelteKit SSR dan environment server/client. Rahasia hanya boleh berada di server/environment variables.

## 4. Cara implementasi

- Kerjakan fitur sampai berfungsi dengan database, bukan hanya membuat mockup atau data statis.
- Gunakan SvelteKit server load/actions atau endpoint yang memang diperlukan; jangan membuat lapisan API tambahan tanpa kebutuhan.
- Validasi input di server. Validasi di browser hanya untuk membantu pengalaman pengguna.
- Pastikan operasi yang mengubah transaksi dan stok konsisten. Gunakan transaksi database/RPC kecil bila satu proses mengubah beberapa tabel.
- Terapkan Supabase Row Level Security (RLS) pada semua tabel data milik kios. Pengguna hanya boleh mengakses data miliknya sendiri.
- Gunakan tipe data uang integer rupiah (`BIGINT`/integer sesuai skema), bukan floating point.
- Jangan menghapus riwayat transaksi. Produk yang sudah pernah dipakai dalam transaksi sebaiknya dinonaktifkan, bukan dihapus.
- Beri pesan sukses/gagal yang jelas dalam Bahasa Indonesia. Hindari `alert()` sebagai pola UI utama.
- Semua halaman harus responsif, terutama untuk smartphone Android.
- Jangan mengisi data produksi dengan data contoh. Data dummy hanya boleh dipakai sebagai seed development yang diberi label jelas.

## 5. Alur kerja yang diharapkan

1. Periksa repository dan kondisi kode yang sudah ada sebelum mengubah file.
2. Buat rencana singkat berdasarkan `docs/implementation-plan.md`.
3. Implementasikan secara bertahap, mulai dari setup, autentikasi/database, lalu modul inti.
4. Setelah setiap bagian, jalankan pemeriksaan yang tersedia: type check, lint, test, dan build. Jangan mengklaim lolos jika belum dijalankan.
5. Jika menemukan kebutuhan yang tidak tertulis, pilih opsi paling sederhana yang tidak memperluas ruang lingkup. Catat sebagai asumsi di `docs/` atau laporkan untuk keputusan pemilik proyek.
6. Jangan mengganti atau menghapus pekerjaan yang sudah ada tanpa memeriksa dampaknya.

## 6. Definition of done

Sebuah fitur belum selesai hanya karena tampilannya sudah ada. Fitur dianggap selesai jika:

- alur utama dapat digunakan;
- data tersimpan dan dibaca dari Supabase;
- validasi dan kondisi kosong/error ditangani;
- akses data dilindungi RLS;
- tampilan desktop dan mobile layak;
- tidak ada error TypeScript/build yang diketahui;
- kriteria terkait di `docs/acceptance-criteria.md` terpenuhi.

## 7. Saat diminta mengubah scope

Jangan diam-diam menambahkan fitur besar. Jelaskan dampaknya terhadap UI, database, dan waktu implementasi secara singkat. Tunggu keputusan pemilik proyek untuk perubahan yang menambah modul atau kompleksitas.
