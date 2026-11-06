# ShopStyve storefront

This is an isolated, static customer storefront. It lives in `/storefront` on the `shopstyve-storefront` branch; the existing Styve dashboard source and `main` branch are not changed.

## Netlify setup

1. Sign in to your Netlify account and choose **Add new project → Import an existing project → GitHub**.
2. Select `hilleyapp/styve` and choose the `shopstyve-storefront` branch.
3. Set the **Publish directory** to `storefront`. Leave the build command blank (plain static HTML).
4. Set the site name to `shopstyve`. Netlify must confirm that `shopstyve.netlify.app` is available; if already claimed, choose another site name.
5. Publish. Customers do not need Netlify accounts.

## Backend

The storefront calls the separate Supabase Edge Function `storefront-api`. It returns only customer-facing product fields, validates prices and stock on the server, writes online orders to the separate `storefront_orders` table, and supports order tracking by order number + phone number.

Online orders are intentionally stored separately from the existing Styve dashboard data. The existing `styve-sync` function and `styve_app_state` row are not modified. A later, separately approved dashboard integration can display these online orders inside Styve.

## Payment and delivery

Cash on delivery and bank transfer are offered. Bank details are not embedded in the public page; they can be shared after the order is confirmed. Delivery charges are stated as confirmed by the seller before finalisation because no delivery-fee rules have been configured yet.
