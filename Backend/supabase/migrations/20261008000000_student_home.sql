-- ============================================================
-- Student Home Page backend: categories + vendors
-- ============================================================

create extension if not exists "pgcrypto";

-- ---------- categories ----------
create table if not exists public.categories (
  id          uuid primary key default gen_random_uuid(),
  name        text not null unique,
  sort_order  integer not null default 0,
  created_at  timestamptz not null default now()
);

-- ---------- vendors ----------
create table if not exists public.vendors (
  id            uuid primary key default gen_random_uuid(),
  name          text not null,
  category      text not null
                  references public.categories(name) on update cascade,
  rating        numeric(2,1) not null default 0
                  check (rating >= 0 and rating <= 5),
  avg_price     integer not null default 0 check (avg_price >= 0),
  prep_time     text not null,
  has_delivery  boolean not null default false,
  has_pickup    boolean not null default true,
  is_open       boolean not null default true,
  image_url     text,
  is_active     boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index if not exists vendors_category_idx on public.vendors (category);
create index if not exists vendors_active_idx   on public.vendors (is_active);

-- keep updated_at fresh
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists vendors_set_updated_at on public.vendors;
create trigger vendors_set_updated_at
before update on public.vendors
for each row execute function public.set_updated_at();

-- ---------- Row Level Security (read-only for the app) ----------
alter table public.categories enable row level security;
alter table public.vendors    enable row level security;

drop policy if exists "categories are readable" on public.categories;
create policy "categories are readable"
  on public.categories for select
  to anon, authenticated
  using (true);

drop policy if exists "active vendors are readable" on public.vendors;
create policy "active vendors are readable"
  on public.vendors for select
  to anon, authenticated
  using (is_active = true);

-- No insert/update/delete policies => the app cannot modify this data.