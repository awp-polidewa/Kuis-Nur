<script lang="ts">import type { PageProps } from './$types';import {rupiah,dateMakassar} from '$lib/format';import Icon from '$lib/Icon.svelte';let {data}:PageProps=$props();</script>
<div class="dashboard-page">
<div class="heading"><div><p class="eyebrow">SELAMAT DATANG KEMBALI</p><h1>Ringkasan kios</h1><p class="muted">Pantau aktivitas Kios Nur hari ini.</p></div><a class="primary" href="/kasir"><Icon name="plus" class="icon-inverse" size={16} /> Transaksi baru</a></div>
<div class="bento"><article class="card hero"><span class="kicker">PENJUALAN HARI INI</span><strong class="big-number">{rupiah(data.total)}</strong><span class="hero-note">{data.count} transaksi tercatat</span><div class="split"><div><small>Tunai</small><b>{rupiah(data.cash)}</b></div><div><small>Bon</small><b>{rupiah(data.bon)}</b></div></div><div class="spark"><Icon name="sparkles" size={72} /></div></article>
 <div class="summary-stack"><article class="card receivable"><span class="kicker">TOTAL PIUTANG BERJALAN</span><strong>{rupiah(data.receivables)}</strong><a href="/bon">Buka buku utang <Icon name="arrow" size={14} /></a><div class="orb"><Icon name="coins" size={52} /></div></article>
 <article class="card profit"><span class="kicker">ESTIMASI LABA KOTOR</span><strong>{rupiah(data.gross)}</strong><small>berdasarkan transaksi hari ini</small></article></div>
 <article class="card low"><div class="row-between"><div><span class="kicker">PERLU DIPERHATIKAN</span><h2>Stok menipis</h2></div><a href="/stok">Lihat semua <Icon name="arrow" size={14} /></a></div>{#if data.lowStock.length}<ul>{#each data.lowStock as p}<li><span class="item-dot"><Icon name="warning-shield" size={16} /></span><span>{p.name}<small>{p.current_stock} {p.unit} tersisa</small></span><b>Min. {p.min_stock}</b></li>{/each}</ul>{:else}<p class="muted empty">Semua stok masih aman.</p>{/if}</article>
<article class="card activity"><div class="row-between"><div><span class="kicker">BARU SAJA</span><h2>Aktivitas terbaru</h2></div><a href="/laporan">Lihat laporan <Icon name="arrow" size={14} /></a></div>{#if data.recent.length}<ul>{#each data.recent as s}<li><span class="activity-icon"><Icon name={s.payment_type==='cash'?'cash':'clock'} size={16} /></span><span>{s.customers?.[0]?.name ?? 'Penjualan tunai'}<small>{dateMakassar(s.transaction_at)}</small></span><b>{rupiah(s.total_amount)}</b></li>{/each}</ul>{:else}<p class="muted empty">Belum ada transaksi. Mulai catat penjualan pertamamu.</p><a href="/kasir" class="text-link">Buka kasir <Icon name="arrow" size={14} /></a>{/if}</article></div>
</div>
<style>
.summary-stack{display:contents}
@media(max-width:600px){
	.summary-stack{grid-column:1/-1;display:grid;grid-template-columns:1fr;overflow:hidden;border:1px solid var(--border);border-radius:16px;background:var(--surface)}
	.summary-stack :global(.card){border:0;border-radius:0;background:transparent}
	.summary-stack :global(.card+.card){border-top:1px solid var(--border)}
	.dashboard-page :global(*){font-size:12px!important}
	.dashboard-page :global(img){width:12px;height:12px}
}
</style>
