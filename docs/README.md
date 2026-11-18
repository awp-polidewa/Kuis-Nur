# Dokumentasi Proyek Kios Nur

Folder ini adalah acuan produk, desain, dan implementasi untuk Codex. Baca dokumen sesuai urutan berikut.

## Urutan membaca

1. [`../AGENTS.md`](../AGENTS.md) — aturan wajib Codex dan batas anti-overengineering.
2. [`prd.md`](prd.md) — tujuan, pengguna, fitur, dan batas MVP.
3. [`source-notes.md`](source-notes.md) — fakta hasil wawancara dan pemetaan kebutuhan.
4. [`business-rules.md`](business-rules.md) — aturan transaksi, bon, stok, dan laporan.
5. [`data-model.md`](data-model.md) — tabel Supabase dan relasinya.
6. [`architecture.md`](architecture.md) — susunan teknologi dan prinsip implementasi.
7. [`design-guidelines.md`](design-guidelines.md) — layout Bento Grid editorial, warna, dan responsivitas.
8. [`acceptance-criteria.md`](acceptance-criteria.md) — checklist fitur yang harus berfungsi.
9. [`implementation-plan.md`](implementation-plan.md) — urutan pengerjaan yang disarankan.
10. [`CODEX-START-HERE.md`](CODEX-START-HERE.md) — instruksi awal ketika Codex mulai mengerjakan repository.

## Referensi

Folder [`references/`](references/) berisi:

- `sitemap.png` — struktur menu dan fitur awal.
- `design-reference-purple-storefront.png` — referensi identitas visual ungu/putih.
- `design-reference-editorial-bento.png` — referensi komposisi layout editorial/Bento Grid.
- `laporan-wawancara-kios-nur.pdf` — laporan observasi dan wawancara mitra.

## Status keputusan

- Produk: aplikasi internal kasir dan pengelolaan kios untuk satu pemilik.
- Platform: web online, diakses melalui browser desktop atau smartphone.
- Deployment: Vercel.
- Database dan autentikasi: Supabase.
- Pengguna aplikasi: pemilik kios. Pelanggan tidak memiliki akun.
- Mode offline, toko online, multi-cabang, dan integrasi eksternal bukan bagian MVP.
- Pencatatan pengeluaran operasional dimasukkan ke Laporan Keuangan.

Jika ada hal yang belum dijelaskan, jangan menambah sistem besar. Ambil keputusan terkecil yang konsisten dengan dokumen dan catat asumsi tersebut.
