import type { PageServerLoad } from './$types';
import { todayMakassar } from '$lib/format';
export const load: PageServerLoad = async ({ locals }) => {
 const db=locals.supabase!, today=todayMakassar(), start=new Date(`${today}T00:00:00+08:00`).toISOString(), end=new Date(`${today}T23:59:59.999+08:00`).toISOString();
 const [sales,products,items,debts,recent]=await Promise.all([
  db.from('sales').select('id,payment_type,total_amount,transaction_at').gte('transaction_at',start).lte('transaction_at',end),
  db.from('products').select('id,name,unit,current_stock,min_stock').eq('is_active',true).order('current_stock'),
  db.from('sale_items').select('sale_id,quantity,unit_price,unit_cost,sales!inner(transaction_at)').gte('sales.transaction_at',start).lte('sales.transaction_at',end),
  db.from('sales').select('id,total_amount,debt_payments(amount)').eq('payment_type','bon'),
  db.from('sales').select('id,payment_type,total_amount,transaction_at,customers(name),sale_items(product_name_snapshot,quantity)').order('transaction_at',{ascending:false}).limit(6)
 ]);
 const rows=sales.data??[], gross=(items.data??[]).reduce((n:any,x:any)=>n+(Number(x.unit_price)-Number(x.unit_cost))*Number(x.quantity),0);
 const receivables=(debts.data??[]).reduce((n:any,x:any)=>n+Math.max(0,Number(x.total_amount)-(x.debt_payments??[]).reduce((a:any,p:any)=>a+Number(p.amount),0)),0);
 return {total:rows.reduce((n:any,x:any)=>n+Number(x.total_amount),0),count:rows.length,cash:rows.filter((x:any)=>x.payment_type==='cash').reduce((n:any,x:any)=>n+Number(x.total_amount),0),bon:rows.filter((x:any)=>x.payment_type==='bon').reduce((n:any,x:any)=>n+Number(x.total_amount),0),gross,receivables,lowStock:(products.data??[]).filter((p:any)=>Number(p.current_stock)<=Number(p.min_stock)).slice(0,6),recent:recent.data??[]};
};
