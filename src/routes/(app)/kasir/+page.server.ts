import { fail } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';

const quantityMatchesUnit = (quantity: number, unit: string) =>
	unit === 'pcs' || unit === 'bungkus'
		? Number.isSafeInteger(quantity)
		: Math.round(quantity * 1000) / 1000 === quantity;

export const load: PageServerLoad = async ({ locals }) => {
	const [products, customers] = await Promise.all([
		locals.supabase!
			.from('products')
			.select('id,name,unit,selling_price,current_stock')
			.eq('is_active', true)
			.gt('current_stock', 0)
			.order('name'),
		locals.supabase!.from('customers').select('id,name,phone').order('name')
	]);
	return { products: products.data ?? [], customers: customers.data ?? [] };
};

export const actions: Actions = {
	customer: async ({ request, locals }) => {
		const form = await request.formData();
		const name = String(form.get('name') ?? '').trim();
		const phone = String(form.get('phone') ?? '').trim();
		if (!name) return fail(400, { error: 'Nama pelanggan wajib diisi.' });
		const { error } = await locals.supabase!.from('customers').insert({ name, phone: phone || null });
		return error ? fail(400, { error: 'Pelanggan gagal ditambahkan.' }) : { customerSaved: true };
	},
	sell: async ({ request, locals }) => {
		const form = await request.formData();
		const payment = String(form.get('payment_type') ?? '');
		const customer = String(form.get('customer_id') ?? '') || null;
		const cashRaw = String(form.get('cash_received') ?? '');
		const cash = cashRaw ? Number(cashRaw) : null;
		let items: any[];
		try {
			items = JSON.parse(String(form.get('items') ?? '[]'));
		} catch {
			return fail(400, { error: 'Data keranjang tidak valid.' });
		}
		if (!Array.isArray(items) || items.length === 0) {
			return fail(400, { error: 'Tambahkan barang ke keranjang terlebih dahulu.' });
		}
		if (!['cash', 'bon'].includes(payment)) return fail(400, { error: 'Pilih metode pembayaran.' });
		if (payment === 'bon' && !customer) {
			return fail(400, { error: 'Pelanggan wajib dipilih untuk transaksi bon.' });
		}
		if (payment === 'cash' && (!Number.isSafeInteger(cash) || Number(cash) < 0)) {
			return fail(400, { error: 'Masukkan jumlah uang diterima.' });
		}

		const clean = items.map((item) => ({
			product_id: String(item.id),
			quantity: Number(item.quantity)
		}));
		if (clean.some((item) => !item.product_id || !Number.isFinite(item.quantity) || item.quantity <= 0)) {
			return fail(400, { error: 'Jumlah barang harus lebih dari nol.' });
		}

		const productIds = [...new Set(clean.map((item) => item.product_id))];
		const { data: products, error: productsError } = await locals.supabase!
			.from('products')
			.select('id,unit')
			.in('id', productIds);
		if (productsError || !products || products.length !== productIds.length) {
			return fail(400, { error: 'Data barang berubah. Muat ulang halaman kasir.' });
		}
		const units = new Map(products.map((product) => [product.id, product.unit]));
		if (clean.some((item) => !quantityMatchesUnit(item.quantity, units.get(item.product_id) ?? ''))) {
			return fail(400, {
				error: 'Jumlah pcs dan bungkus harus bilangan bulat. Jumlah kg dapat memakai pecahan hingga tiga angka desimal.'
			});
		}

		const { data, error } = await locals.supabase!.rpc('create_sale', {
			p_payment_type: payment,
			p_customer_id: customer,
			p_cash_received: cash,
			p_items: clean
		});
		if (error) {
			return fail(400, {
				error: error.message.includes('Stok')
					? error.message
					: 'Transaksi gagal disimpan. Periksa kembali keranjang dan pembayaran.'
			});
		}
		return { saleId: data as string };
	}
};
