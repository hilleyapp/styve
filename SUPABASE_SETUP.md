# Styve cloud database setup

Styve will use Supabase Auth plus a private JSONB state row per shop owner. This keeps the existing app data model intact while enabling the same shop data on multiple signed-in devices.

## 1. Create a Supabase project
1. Open https://supabase.com/dashboard and create a project.
2. Save the database password securely; do not send it to anyone.
3. Open **Project Settings → API** and copy the **Project URL** and **anon/public key** (or publishable key).

## 2. Create the private table
1. Open **SQL Editor → New query**.
2. Paste and run the contents of `supabase/schema.sql`.
3. In **Authentication → Providers**, ensure Email is enabled.
4. In **Authentication → URL Configuration**, add the deployed Styve URL as a Site URL and allowed redirect URL:
   `https://hilleyapp.github.io/styve/`

## 3. Send the browser-safe configuration
Provide the Project URL and anon/public (publishable) key so they can be added to Styve. These values are intended for browser use when Row Level Security is enabled. **Never provide the service_role/secret key, database password, or personal access token.**

## Data model and security
- The table stores the app's products, orders, Instagram inbox, and expenses together as one JSON document per authenticated owner.
- Row Level Security ensures a signed-in account can only read or change its own row.
- Realtime publication is enabled for cross-device updates.
- Existing browser localStorage remains untouched until the cloud connection is configured and a safe first-sync migration is performed.
