# Kios Nur — Sistem Kasir & Stok

Aplikasi internal untuk satu pemilik kios, dibuat dengan SvelteKit, TypeScript, Tailwind CSS, Supabase Auth/PostgreSQL, dan adapter Vercel.

## Menjalankan lokal

1. Salin `.env.example` menjadi `.env`.
2. Isi `PUBLIC_SUPABASE_URL` dan `PUBLIC_SUPABASE_ANON_KEY` dari project Supabase yang benar. Jangan isi atau commit service-role key.
3. Jalankan `npm install`, kemudian `npm run dev`.
4. Buat akun pemilik secara manual melalui Supabase Dashboard → Authentication → Users. Aplikasi tidak menyediakan registrasi publik.

## Database

Jalankan migration `supabase/migrations/202611170001_initial_schema.sql` terhadap project Supabase melalui Supabase CLI (`supabase db push`) atau SQL Editor. Migration membuat tabel bisnis, constraint, indeks, RLS, dan RPC atomik untuk penjualan, perubahan stok, pembuatan produk dengan stok awal, serta pembayaran bon.

Semua nominal tersimpan dalam rupiah integer. Kuantitas memakai `NUMERIC(12,3)`. Tanggal laporan dihitung dengan zona waktu Asia/Makassar.

## Pemeriksaan

- `npm run check` — pemeriksaan Svelte/TypeScript.
- `npm run build` — build produksi Vercel.

## Deploy Vercel

Hubungkan repository ke Vercel, tambahkan `PUBLIC_SUPABASE_URL` dan `PUBLIC_SUPABASE_ANON_KEY` pada environment variables untuk deployment, lalu deploy. Setelah deployment, uji login dan alur data menggunakan akun pemilik dan database yang sudah dimigrasikan.

## Fitur MVP

- Login pemilik tanpa pendaftaran publik.
- Dashboard data hari ini, piutang, stok menipis, dan transaksi terbaru.
- Kasir tunai/bon dengan perhitungan harga dan stok atomik di PostgreSQL.
- Produk, stok masuk, penyesuaian, dan pencatatan pergerakan stok.
- Buku utang dengan riwayat pembayaran sebagian/pelunasan.
- Laporan berdasarkan rentang tanggal dan pencatatan pengeluaran operasional.
