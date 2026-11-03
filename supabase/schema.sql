-- Styve cloud database (one private state document per signed-in shop owner)
-- Run this in Supabase Dashboard -> SQL Editor.
create table if not exists public.styve_app_state (
  owner_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.styve_app_state enable row level security;

drop policy if exists "Shop owners can read their own Styve data" on public.styve_app_state;
create policy "Shop owners can read their own Styve data"
  on public.styve_app_state for select
  to authenticated
  using (auth.uid() = owner_id);

drop policy if exists "Shop owners can create their own Styve data" on public.styve_app_state;
create policy "Shop owners can create their own Styve data"
  on public.styve_app_state for insert
  to authenticated
  with check (auth.uid() = owner_id);

drop policy if exists "Shop owners can update their own Styve data" on public.styve_app_state;
create policy "Shop owners can update their own Styve data"
  on public.styve_app_state for update
  to authenticated
  using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

-- Realtime is used by Styve to receive updates made on another signed-in device.
do $$
begin
  alter publication supabase_realtime add table public.styve_app_state;
exception
  when duplicate_object then null;
  when undefined_object then
    raise notice 'supabase_realtime publication not found; enable Realtime for styve_app_state in the dashboard.';
end $$;

grant select, insert, update on public.styve_app_state to authenticated;
