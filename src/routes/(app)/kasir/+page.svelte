<script lang="ts">
	import type { PageProps } from './$types';
	import { rupiah } from '$lib/format';
	import Icon from '$lib/Icon.svelte';
	import CurrencyInput from '$lib/components/CurrencyInput.svelte';
	let { data, form }: PageProps = $props();
	let query = $state('');
	let cart = $state<{ id: string; name: string; unit: string; price: number; quantity: number; stock: number }[]>([]);
	let method = $state('cash');
	let customer = $state('');
	let cash = $state<number | null>(null);
	let filtered = $derived(data.products.filter((p) => p.name.toLowerCase().includes(query.toLowerCase())));
	let total = $derived(cart.reduce((sum, item) => sum + Math.round(item.price * item.quantity), 0));
	let change = $derived(Math.max(0, Number(cash ?? 0) - total));
	$effect(() => { if (form?.saleId) cart = []; });
	function add(product: (typeof data.products)[number]) {
		const item = cart.find((x) => x.id === product.id);
		if (item) item.quantity += 1;
		else cart.push({ id: product.id, name: product.name, unit: product.unit, price: Number(product.selling_price), quantity: 1, stock: Number(product.current_stock) });
	}
	function remove(id: string) { cart = cart.filter((item) => item.id !== id); }
</script>
<div class="heading"><div><p class="eyebrow">PENJUALAN</p><h1>Kasir cepat</h1><p class="muted">Cari barang, susun keranjang, lalu simpan.</p></div><span class="badge">{cart.length} jenis barang</span></div>
{#if form?.error}<div class="notice error">{form.error}</div>{/if}
{#if form?.customerSaved}<div class="notice">Pelanggan berhasil ditambahkan. <a href="/kasir">Muat ulang kasir untuk memilihnya.</a></div>{/if}
{#if form?.saleId}<div class="notice success"><b>Transaksi berhasil disimpan.</b> Nomor transaksi {form.saleId}</div>{/if}
<div class="checkout-grid">
	<section class="catalog"><div class="searchbox"><Icon name="search" size={18} /><input bind:value={query} placeholder="Cari nama barang…" /></div><div class="catalog-list">
		{#if filtered.length}{#each filtered as product}<button class="catalog-item" onclick={() => add(product)}><span class="product-mark">{product.name.slice(0,1).toUpperCase()}</span><span class="item-info"><b>{product.name}</b><small>{product.current_stock} {product.unit} tersedia</small></span><span class="item-price"><b>{rupiah(product.selling_price)}</b><small><Icon name="plus" size={15} /></small></span></button>{/each}{:else}<div class="empty-state">Barang aktif tidak ditemukan.</div>{/if}
	</div></section>
	<section class="panel cart"><div class="cart-head"><div><span class="kicker">TRANSAKSI BARU</span><h2>Keranjang</h2></div><span class="badge">{cart.length} item</span></div>
		{#if cart.length}<div class="cart-lines">{#each cart as item}<div class="cart-line"><div class="line-title"><b>{item.name}</b><small>{rupiah(item.price)} / {item.unit}</small></div><input aria-label="Jumlah {item.name} ({item.unit})" type="number" min={item.unit==='pcs'||item.unit==='bungkus'?1:0.001} max={item.stock} step={item.unit==='pcs'||item.unit==='bungkus'?1:0.001} inputmode={item.unit==='pcs'||item.unit==='bungkus'?'numeric':'decimal'} bind:value={item.quantity} /><button class="remove" type="button" aria-label="Hapus {item.name}" onclick={() => remove(item.id)}><Icon name="delete" size={17} /></button><b>{rupiah(Math.round(item.price * item.quantity))}</b></div>{/each}</div>{:else}<div class="cart-empty"><span><Icon name="grid" size={18} /></span><b>Keranjang masih kosong</b><small>Pilih barang dari daftar untuk memulai.</small></div>{/if}
		{#if method === 'bon'}<details class="add-customer"><summary class="summary"><Icon name="plus" size={14} /> Tambah pelanggan baru</summary><form method="POST" action="?/customer" class="new-customer"><label>Nama pelanggan<input name="name" required /></label><label>No. telepon (opsional)<input name="phone" type="tel" /></label><button class="secondary">Simpan pelanggan</button></form></details>{/if}
		<form method="POST" action="?/sell" class="pay-form"><input type="hidden" name="items" value={JSON.stringify(cart.map(({id,quantity}) => ({id,quantity})))} /><div class="total-row"><span>Total belanja</span><b>{rupiah(total)}</b></div><div class="method"><button type="button" class:chosen={method === 'cash'} onclick={() => method = 'cash'}>Tunai</button><button type="button" class:chosen={method === 'bon'} onclick={() => method = 'bon'}>Bon</button><input type="hidden" name="payment_type" value={method} /></div>
			{#if method === 'cash'}<label>Uang diterima<CurrencyInput name="cash_received" bind:value={cash} min={total} required placeholder="Masukkan nominal" /></label><div class="change-row"><span>Kembalian</span><b>{rupiah(change)}</b></div>{:else}<label>Pelanggan<select name="customer_id" bind:value={customer} required><option value="">Pilih pelanggan</option>{#each data.customers as c}<option value={c.id}>{c.name}{c.phone ? ` · ${c.phone}` : ''}</option>{/each}</select></label>{/if}
			<button class="primary wide" disabled={!cart.length}>Simpan transaksi <Icon name="arrow" class="icon-inverse" size={16} /></button>
		</form>
	</section>
</div>
<style>
.checkout-grid{display:grid;grid-template-columns:1.05fr .95fr;gap:16px;align-items:start}.catalog{min-width:0}.searchbox{display:flex;align-items:center;gap:10px;background:var(--surface);border:1px solid var(--border);border-radius:13px;padding:0 14px}.searchbox input{border:0;outline:0}.catalog-list{display:grid;gap:8px;margin-top:12px;max-height:calc(100vh - 240px);overflow:auto}.catalog-item{display:flex;align-items:center;gap:11px;padding:12px;background:var(--surface);border:1px solid var(--border);border-radius:13px;text-align:left;font:inherit;cursor:pointer}.catalog-item:hover{border-color:#E8504A;background:#F7E5E5}.item-info{flex:1}.item-info b,.item-info small,.item-price b,.item-price small{display:block}.item-info b{font-size:17px}.item-info small,.item-price small{font-size:14px;color:var(--muted);margin-top:4px}.item-price{text-align:right}.item-price b{font-size:16px}.item-price small{color:var(--purple)}.cart{position:sticky;top:18px}.cart-head{display:flex;align-items:center;justify-content:space-between}.cart-empty{height:150px;display:grid;align-content:center;justify-items:center;color:var(--muted);gap:8px}.cart-empty span{width:36px;height:36px;display:grid;place-items:center;background:#EDE5DC;color:var(--crimson);border-radius:12px}.cart-empty b{font-size:17px;color:var(--ink)}.cart-empty small{font-size:15px}.cart-lines{display:grid;gap:14px;margin:20px 0;max-height:36vh;overflow:auto}.cart-line{display:grid;grid-template-columns:1fr 72px 22px auto;align-items:center;gap:8px}.line-title b,.line-title small{display:block}.line-title b{font-size:16px}.line-title small{font-size:14px;color:var(--muted);margin-top:4px}.cart-line input{padding:7px;min-height:35px}.cart-line>b{font-size:15px;text-align:right}.remove{border:0;background:transparent;color:#b42318;font-size:24px;cursor:pointer}.pay-form{border-top:1px solid var(--border);padding-top:14px;display:grid;gap:13px}.total-row,.change-row{display:flex;justify-content:space-between;align-items:center;font-size:16px}.total-row b{font-size:26px}.change-row{color:var(--muted)}.change-row b{color:var(--purple)}.method{display:grid;grid-template-columns:1fr 1fr;background:#EDE5DC;border-radius:11px;padding:4px}.method button{border:0;background:transparent;border-radius:8px;padding:9px;font:inherit;font-size:16px;color:var(--muted)}.method button.chosen{background:var(--red);color:#fff;font-weight:800;box-shadow:0 1px 4px #1d102011}.wide{width:100%}.wide:disabled{opacity:.5;cursor:not-allowed}.new-customer{display:grid;gap:10px;margin:12px 0}.summary{cursor:pointer;color:var(--purple);font-size:15px}.success{background:#E9F5E5;color:#2F6B3A;border-color:#C6DFC0;border-left-color:#6BAF71}.add-customer{margin:12px 0}@media(max-width:900px){.checkout-grid{grid-template-columns:1fr}.cart{position:static}.catalog-list{max-height:340px}}@media(max-width:600px){.heading{align-items:center}.heading .badge{font-size:13px}}
</style>
