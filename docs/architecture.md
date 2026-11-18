# Arsitektur dan Struktur Implementasi

## 1. Stack yang ditetapkan

| Area | Teknologi |
|---|---|
| Framework full-stack | SvelteKit |
| Bahasa | TypeScript |
| Styling | Tailwind CSS |
| Database | Supabase PostgreSQL |
| Authentication | Supabase Auth |
| Hosting | Vercel |

Gunakan versi stabil yang kompatibel saat proyek dibuat. Jangan menambah framework UI atau backend kedua tanpa kebutuhan yang jelas.

## 2. Prinsip arsitektur

- Satu aplikasi SvelteKit.
- Supabase menjadi database dan penyedia autentikasi.
- SvelteKit menangani halaman, server load, form actions, dan validasi server.
- Query dan operasi sensitif dijalankan di server bila sesuai.
- RLS tetap menjadi lapisan keamanan database; jangan hanya mengandalkan penyembunyian UI.
- Satu pemilik/satu kios untuk MVP.
- Tidak ada layanan backend terpisah atau microservices.

## 3. Struktur folder yang disarankan

Sesuaikan dengan scaffold SvelteKit yang dipakai, tetapi pertahankan struktur sederhana seperti:

```text
src/
  lib/
    components/       # komponen UI yang dipakai berulang
    server/           # helper server dan operasi database
    supabase/         # client Supabase browser/server jika diperlukan
    utils/            # formatter rupiah, tanggal, validasi kecil
  routes/
    (auth)/login/
    (app)/             # layout halaman yang membutuhkan login
      +layout.server.ts
      dashboard/
      kasir/
      bon/
      stok/
      laporan/
  hooks.server.ts
supabase/
  migrations/          # SQL migration yang version-controlled
static/
docs/
```

Ini hanya panduan. Jangan membuat folder jika belum ada kebutuhan nyata.

## 4. Autentikasi

- Gunakan Supabase Auth email/password.
- Gunakan pola SSR Supabase yang sesuai untuk SvelteKit agar sesi diverifikasi dengan benar di server.
- Lindungi seluruh route aplikasi selain halaman login.
- Tidak ada halaman register publik.
- Jika sesi tidak valid, arahkan pengguna ke login.
- Sediakan logout.

## 5. Environment variables

Buat `.env.example` berisi nama variabel yang diperlukan, misalnya:

```env
PUBLIC_SUPABASE_URL=
PUBLIC_SUPABASE_ANON_KEY=
```

Gunakan nama variabel yang sesuai dengan library Supabase yang dipilih. Service-role key tidak diperlukan untuk alur browser biasa. Jika suatu tugas administratif benar-benar memerlukan service-role key, hanya gunakan di server dan jangan expose ke client.

Jangan commit file `.env` berisi nilai rahasia.

## 6. Database migrations

- Semua pembuatan tabel, constraint, index, RLS policy, dan function dicatat sebagai SQL migration di `supabase/migrations/`.
- Jangan hanya mengubah schema manual di dashboard Supabase tanpa migration repository.
- Siapkan instruksi singkat untuk menjalankan migration pada project Supabase.
- Buat akun pemilik secara manual melalui Supabase Auth; jangan membuat endpoint pendaftaran publik.

## 7. Data flow

- Baca data halaman melalui server load bila data memerlukan sesi pemilik.
- Form kirim data melalui SvelteKit actions atau endpoint server yang sesuai.
- Validasi data di server sebelum menulis.
- Untuk operasi multi-tabel yang harus konsisten (khususnya penjualan), gunakan PostgreSQL function/RPC dalam satu transaksi.
- Hindari request terpisah dari client untuk insert transaksi, insert item, dan update stok.

## 8. UI dan state

- Gunakan state lokal Svelte untuk kebutuhan komponen.
- Jangan menambah Redux, Zustand, atau state manager eksternal.
- Hindari state global jika data dapat dimuat dari server atau ditangani komponen.
- Buat komponen kecil untuk pola yang benar-benar berulang seperti Button, Input, Card, Modal/Sheet, Badge, dan Table; jangan membuat framework komponen sendiri.
- Formatter rupiah dan tanggal dibuat sebagai utilitas sederhana.

## 9. Error handling

- Tampilkan pesan yang mudah dipahami pengguna.
- Jangan menampilkan stack trace, detail SQL, token, atau data rahasia.
- Catat error teknis di log server tanpa membocorkan data sensitif.
- Berikan kondisi loading, empty state, dan error state pada halaman utama.

## 10. Deployment Vercel

- Pastikan build SvelteKit menggunakan adapter yang kompatibel dengan Vercel.
- Atur environment variables Supabase pada project Vercel.
- Jalankan build lokal sebelum deployment.
- Jangan menganggap deployment berhasil sebelum URL dan alur login/database diuji.
