create extension if not exists pgcrypto;

create table public.products (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null default auth.uid() references auth.users(id),
  name text not null check (length(trim(name)) > 0), unit text not null check (length(trim(unit)) > 0),
  cost_price bigint not null default 0 check (cost_price >= 0), selling_price bigint not null check (selling_price > 0),
  current_stock numeric(12,3) not null default 0 check (current_stock >= 0), min_stock numeric(12,3) not null default 0 check (min_stock >= 0),
  is_active boolean not null default true, created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(owner_id,id)
);
create table public.customers (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null default auth.uid() references auth.users(id),
  name text not null check (length(trim(name)) > 0), phone text, notes text, created_at timestamptz not null default now(), unique(owner_id,id)
);
create table public.sales (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null default auth.uid() references auth.users(id), customer_id uuid,
  payment_type text not null check (payment_type in ('cash','bon')), transaction_at timestamptz not null default now(),
  total_amount bigint not null check (total_amount > 0), cash_received bigint, change_amount bigint,
  created_at timestamptz not null default now(), unique(owner_id,id),
  foreign key(owner_id, customer_id) references public.customers(owner_id,id),
  check ((payment_type='bon' and customer_id is not null and cash_received is null and change_amount is null) or
         (payment_type='cash' and cash_received >= total_amount and change_amount = cash_received-total_amount))
);
create table public.sale_items (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null default auth.uid() references auth.users(id), sale_id uuid not null, product_id uuid not null,
  product_name_snapshot text not null, unit_snapshot text not null, quantity numeric(12,3) not null check (quantity > 0),
  unit_price bigint not null check (unit_price > 0), unit_cost bigint not null check (unit_cost >= 0), line_total bigint not null check (line_total > 0),
  foreign key(owner_id,sale_id) references public.sales(owner_id,id), foreign key(owner_id,product_id) references public.products(owner_id,id)
);
create table public.debt_payments (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null default auth.uid() references auth.users(id), sale_id uuid not null,
  amount bigint not null check (amount > 0), payment_at timestamptz not null default now(), note text, created_at timestamptz not null default now(),
  foreign key(owner_id,sale_id) references public.sales(owner_id,id)
);
create table public.stock_movements (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null default auth.uid() references auth.users(id), product_id uuid not null,
  movement_type text not null check (movement_type in ('in','sale','adjustment')), quantity_change numeric(12,3) not null check (quantity_change <> 0),
  reference_sale_id uuid, note text, created_at timestamptz not null default now(), foreign key(owner_id,product_id) references public.products(owner_id,id),
  foreign key(owner_id,reference_sale_id) references public.sales(owner_id,id),
  check ((movement_type='in' and quantity_change>0) or (movement_type='sale' and quantity_change<0) or movement_type='adjustment')
);
create table public.expenses (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null default auth.uid() references auth.users(id), expense_date date not null,
  category text not null check (length(trim(category)) > 0), description text, amount bigint not null check (amount>0), created_at timestamptz not null default now()
);

create index products_owner_name_idx on public.products(owner_id,name);
create index customers_owner_name_idx on public.customers(owner_id,name);
create index sales_owner_time_idx on public.sales(owner_id,transaction_at);
create index sales_owner_customer_time_idx on public.sales(owner_id,customer_id,transaction_at);
create index sale_items_sale_idx on public.sale_items(owner_id,sale_id);
create index debt_payments_sale_time_idx on public.debt_payments(owner_id,sale_id,payment_at);
create index stock_movements_product_time_idx on public.stock_movements(owner_id,product_id,created_at);
create index expenses_owner_date_idx on public.expenses(owner_id,expense_date);

do $$ declare t text; begin
  foreach t in array array['products','customers','sales','sale_items','debt_payments','stock_movements','expenses'] loop
    execute format('alter table public.%I enable row level security',t);
    execute format('create policy owner_select on public.%I for select using (owner_id=auth.uid())',t);
    execute format('create policy owner_insert on public.%I for insert with check (owner_id=auth.uid())',t);
    execute format('create policy owner_update on public.%I for update using (owner_id=auth.uid()) with check (owner_id=auth.uid())',t);
  end loop;
end $$;

create or replace function public.create_sale(p_payment_type text,p_customer_id uuid,p_cash_received bigint,p_items jsonb)
returns uuid language plpgsql security definer set search_path=pg_catalog,public,pg_temp as $$
declare v_owner uuid:=auth.uid(); v_sale uuid:=gen_random_uuid(); v_item jsonb; v_product public.products; v_qty numeric(12,3); v_total bigint:=0; v_line bigint; v_change bigint;
begin
  if v_owner is null or jsonb_typeof(p_items)<>'array' or jsonb_array_length(p_items)=0 then raise exception 'Keranjang transaksi kosong'; end if;
  if p_payment_type not in ('cash','bon') then raise exception 'Metode pembayaran tidak valid'; end if;
  if p_payment_type='bon' and (p_customer_id is null or not exists(select 1 from public.customers where id=p_customer_id and owner_id=v_owner)) then raise exception 'Pelanggan bon wajib dipilih'; end if;
  for v_item in select value from jsonb_array_elements(p_items) loop
    v_qty:=(v_item->>'quantity')::numeric;
    if v_qty<=0 then raise exception 'Jumlah barang harus lebih dari nol'; end if;
    select * into v_product from public.products where id=(v_item->>'product_id')::uuid and owner_id=v_owner and is_active for update;
    if not found then raise exception 'Barang tidak ditemukan atau sudah nonaktif'; end if;
    if v_product.current_stock<v_qty then raise exception 'Stok % tidak mencukupi',v_product.name; end if;
    v_line:=round(v_qty*v_product.selling_price)::bigint; if v_line<=0 then raise exception 'Total item tidak valid'; end if; v_total:=v_total+v_line;
  end loop;
  if p_payment_type='cash' and (p_cash_received is null or p_cash_received<v_total) then raise exception 'Uang diterima kurang dari total transaksi'; end if;
  v_change:=case when p_payment_type='cash' then p_cash_received-v_total else null end;
  insert into public.sales(id,owner_id,customer_id,payment_type,total_amount,cash_received,change_amount) values(v_sale,v_owner,p_customer_id,p_payment_type,v_total,p_cash_received,v_change);
  for v_item in select value from jsonb_array_elements(p_items) loop
    v_qty:=(v_item->>'quantity')::numeric;
    select * into v_product from public.products where id=(v_item->>'product_id')::uuid and owner_id=v_owner and is_active for update;
    if v_product.current_stock<v_qty then raise exception 'Stok % tidak mencukupi',v_product.name; end if;
    v_line:=round(v_qty*v_product.selling_price)::bigint;
    insert into public.sale_items(owner_id,sale_id,product_id,product_name_snapshot,unit_snapshot,quantity,unit_price,unit_cost,line_total)
      values(v_owner,v_sale,v_product.id,v_product.name,v_product.unit,v_qty,v_product.selling_price,v_product.cost_price,v_line);
    update public.products set current_stock=current_stock-v_qty,updated_at=now() where id=v_product.id and owner_id=v_owner;
    insert into public.stock_movements(owner_id,product_id,movement_type,quantity_change,reference_sale_id) values(v_owner,v_product.id,'sale',-v_qty,v_sale);
  end loop;
  return v_sale;
end $$;

create or replace function public.change_stock(p_product_id uuid,p_type text,p_quantity numeric,p_note text,p_new_cost bigint default null)
returns void language plpgsql security definer set search_path=pg_catalog,public,pg_temp as $$
declare v_owner uuid:=auth.uid(); v_product public.products;
begin
  if p_quantity=0 or p_type not in ('in','adjustment') then raise exception 'Perubahan stok tidak valid'; end if;
  if p_type='in' and p_quantity<0 then raise exception 'Stok masuk harus positif'; end if;
  if p_type='adjustment' and nullif(trim(p_note),'') is null then raise exception 'Alasan penyesuaian wajib diisi'; end if;
  select * into v_product from public.products where id=p_product_id and owner_id=v_owner for update;
  if not found then raise exception 'Barang tidak ditemukan'; end if;
  if v_product.current_stock+p_quantity<0 then raise exception 'Stok tidak boleh negatif'; end if;
  update public.products set current_stock=current_stock+p_quantity,cost_price=coalesce(p_new_cost,cost_price),updated_at=now() where id=p_product_id and owner_id=v_owner;
  insert into public.stock_movements(owner_id,product_id,movement_type,quantity_change,note) values(v_owner,p_product_id,p_type,p_quantity,p_note);
end $$;

create or replace function public.create_product(p_name text,p_unit text,p_cost bigint,p_price bigint,p_stock numeric,p_min_stock numeric)
returns uuid language plpgsql security definer set search_path=pg_catalog,public,pg_temp as $$
declare v_owner uuid:=auth.uid(); v_id uuid:=gen_random_uuid();
begin
  if v_owner is null or nullif(trim(p_name),'') is null or nullif(trim(p_unit),'') is null then raise exception 'Nama barang dan satuan wajib diisi'; end if;
  if p_cost<0 or p_price<=0 or p_stock<0 or p_min_stock<0 then raise exception 'Harga dan jumlah stok tidak valid'; end if;
  insert into public.products(id,owner_id,name,unit,cost_price,selling_price,current_stock,min_stock) values(v_id,v_owner,trim(p_name),trim(p_unit),p_cost,p_price,p_stock,p_min_stock);
  if p_stock>0 then insert into public.stock_movements(owner_id,product_id,movement_type,quantity_change,note) values(v_owner,v_id,'in',p_stock,'Stok awal'); end if;
  return v_id;
end $$;

create or replace function public.pay_debt(p_sale_id uuid,p_amount bigint,p_note text default null)
returns uuid language plpgsql security definer set search_path=pg_catalog,public,pg_temp as $$
declare v_owner uuid:=auth.uid(); v_sale public.sales; v_paid bigint; v_id uuid:=gen_random_uuid();
begin
  if p_amount<=0 then raise exception 'Pembayaran harus lebih dari nol'; end if;
  select * into v_sale from public.sales where id=p_sale_id and owner_id=v_owner and payment_type='bon' for update;
  if not found then raise exception 'Transaksi bon tidak ditemukan'; end if;
  select coalesce(sum(amount),0) into v_paid from public.debt_payments where sale_id=p_sale_id and owner_id=v_owner;
  if p_amount>v_sale.total_amount-v_paid then raise exception 'Pembayaran melebihi sisa utang'; end if;
  insert into public.debt_payments(id,owner_id,sale_id,amount,note) values(v_id,v_owner,p_sale_id,p_amount,p_note);
  return v_id;
end $$;

revoke all on function public.create_sale(text,uuid,bigint,jsonb) from public;
revoke all on function public.change_stock(uuid,text,numeric,text,bigint) from public;
revoke all on function public.pay_debt(uuid,bigint,text) from public;
revoke all on function public.create_product(text,text,bigint,bigint,numeric,numeric) from public;
revoke insert,update,delete on public.sales,public.sale_items,public.debt_payments,public.stock_movements from authenticated;
grant select on public.sales,public.sale_items,public.debt_payments,public.stock_movements to authenticated;
grant execute on function public.create_sale(text,uuid,bigint,jsonb) to authenticated;
grant execute on function public.change_stock(uuid,text,numeric,text,bigint) to authenticated;
grant execute on function public.pay_debt(uuid,bigint,text) to authenticated;
grant execute on function public.create_product(text,text,bigint,bigint,numeric,numeric) to authenticated;
