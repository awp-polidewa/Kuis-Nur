<script lang="ts">
	import type { LayoutProps } from './$types';
	import { navigating, page } from '$app/state';
	import Icon from '$lib/Icon.svelte';
	let { children, data }: LayoutProps = $props();
	const links = [
		{ href: '/dashboard', label: 'Beranda', icon: 'home' },
		{ href: '/kasir', label: 'Kasir', icon: 'plus' },
		{ href: '/bon', label: 'Buku Utang', icon: 'clock' },
		{ href: '/stok', label: 'Stok Barang', icon: 'grid' },
		{ href: '/laporan', label: 'Laporan', icon: 'bar-chart' }
	] as const;
</script>
<svelte:head><title>Kios Nur — Kasir & Stok</title><meta name="viewport" content="width=device-width, initial-scale=1" /></svelte:head>
<div class="shell">
 {#if navigating.to}<div class="nav-progress" role="status" aria-label="Memuat halaman"></div>{/if}
 <aside class="sidebar"><a class="brand" href="/dashboard" data-sveltekit-preload-data="hover" data-sveltekit-preload-code="hover"><span class="brand-mark">N</span><span>Kios Nur<small>Kasir & Stok</small></span></a><nav>{#each links as link}<a href={link.href} data-sveltekit-preload-data="hover" data-sveltekit-preload-code="hover" class:active={page.url.pathname === link.href} aria-current={page.url.pathname === link.href ? 'page' : undefined}><Icon name={link.icon} size={19} />{link.label}</a>{/each}</nav><form method="POST" action="/logout"><button class="logout"><Icon name="exit" size={18} />Keluar</button></form></aside>
 <main><header class="topbar"><span>Operasional kios · Makassar</span><span class="user-chip">{data.user?.email}</span></header><section class="page">{@render children()}<footer class="icon-credit">awpCode</footer></section></main>
 <nav class="mobile-nav">{#each links as link}<a href={link.href} data-sveltekit-preload-data="tap" data-sveltekit-preload-code="tap" class:active={page.url.pathname === link.href} aria-current={page.url.pathname === link.href ? 'page' : undefined}><Icon name={link.icon} size={19} />{link.label}</a>{/each}</nav>
</div>
<style>
 .shell{min-height:100vh}.sidebar{position:fixed;inset:0 auto 0 0;width:232px;background:var(--sidebar);border-right:1px solid var(--border);padding:28px 18px;display:flex;flex-direction:column;z-index:4}.brand{display:flex;gap:12px;align-items:center;color:var(--ink);font-size:21px;font-weight:800;text-decoration:none;padding:0 10px 36px}.brand-mark{display:grid;place-items:center;background:linear-gradient(135deg,#C41E3A 0 48%,#E8504A 48% 74%,#F4A0A099 74% 100%);width:38px;height:38px;border-radius:13px;color:white}.brand small{display:block;color:var(--muted);font-size:15px;font-weight:500;margin-top:2px}.sidebar nav{display:grid;gap:6px}.sidebar nav a,.logout{display:flex;gap:12px;align-items:center;padding:12px 13px;border:0;border-radius:12px;text-decoration:none;color:#7A726B;background:transparent;font:inherit;font-size:18px;text-align:left}.sidebar nav a:hover,.sidebar nav a.active{background:var(--surface);color:var(--crimson);font-weight:700}.sidebar nav a.active{box-shadow:inset 3px 0 0 var(--purple)}.logout{margin-top:auto;cursor:pointer}.shell main{margin-left:232px}.topbar{position:sticky;top:0;z-index:3;height:70px;display:flex;align-items:center;justify-content:space-between;padding:0 40px;border-bottom:1px solid var(--border);background:var(--surface);color:#7A726B;font-size:17px}.user-chip{background:var(--surface);padding:9px 14px;border:1px solid var(--border);border-radius:999px;color:#7A726B}.page{padding:34px 40px 60px;max-width:1440px;margin:auto}.icon-credit{text-align:right;font-size:14px;margin-top:18px;color:var(--muted)}.mobile-nav{display:none}@media(max-width:760px){.sidebar{display:none}.shell main{margin:0}.topbar{height:54px;padding:0 18px}.topbar>span:first-child{font-size:15px}.user-chip{max-width:52%;overflow:hidden;text-overflow:ellipsis}.page{padding:23px 16px 100px}.mobile-nav{position:fixed;display:flex;bottom:0;left:0;right:0;height:70px;background:var(--surface);border-top:1px solid var(--border);justify-content:space-around;align-items:center;padding-bottom:env(safe-area-inset-bottom);z-index:5}.mobile-nav a{font-size:14px;text-decoration:none;color:var(--muted);display:grid;justify-items:center;gap:4px;padding:5px 8px;border-radius:12px}.mobile-nav a:hover,.mobile-nav a.active{color:var(--purple);background:#FAF7F2}.mobile-nav a.active{font-weight:700}}
.nav-progress{position:fixed;z-index:10;top:0;left:232px;right:0;height:3px;overflow:hidden;background:#F7E5E5}.nav-progress:after{content:"";display:block;width:38%;height:100%;background:#E8504A;animation:nav-progress-slide .8s ease-in-out infinite alternate}@keyframes nav-progress-slide{from{transform:translateX(-100%)}to{transform:translateX(260%)}}@media(max-width:760px){.nav-progress{left:0}}
</style>
