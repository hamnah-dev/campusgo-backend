insert into public.categories (name, sort_order) values
  ('Fast Food', 1),
  ('Pizza',     2),
  ('Desi',      3),
  ('Drinks',    4),
  ('Desserts',  5),
  ('Healthy',   6)
on conflict (name) do nothing;

insert into public.vendors
  (name, category, rating, avg_price, prep_time, has_delivery, has_pickup, is_open, image_url)
values
  ('Campus Café',  'Fast Food', 4.8, 850,  '15–20 min', true,  true, true,
   'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=800&q=80'),
  ('Spice Corner', 'Desi',      4.6, 650,  '20–25 min', true,  true, true,
   'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=800&q=80'),
  ('Pizza Point',  'Pizza',     4.7, 1100, '20–30 min', true,  true, true,
   'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=800&q=80'),
  ('Chill Station','Drinks',    4.5, 400,  '5–10 min',  false, true, true,
   'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=800&q=80'),
  ('Sweet Spot',   'Desserts',  4.9, 550,  '10–15 min', true,  true, false,
   'https://images.unsplash.com/photo-1551024506-0bccd828d307?auto=format&fit=crop&w=800&q=80'),
  ('Green Bowl',   'Healthy',   4.7, 750,  '10–15 min', false, true, true,
   'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80');