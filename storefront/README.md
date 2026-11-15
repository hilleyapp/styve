# ShopStyve customer storefront PWA

The isolated customer storefront is published from this `storefront/` directory on the `shopstyve-storefront` branch.

## Installable app
- iPhone: open the live storefront in Safari → Share → Add to Home Screen.
- Android: open in Chrome → Install app / Add to Home screen.
- The web app manifest and service worker provide standalone launch and cached app-shell support. Live product data, checkout and order tracking still require an internet connection.

## Backend integration
Uses the existing Supabase Edge Function `storefront-api` for customer-facing product data, order creation and order tracking. Orders remain in `storefront_orders`, and the Styve Business Dashboard reads and manages those orders through the existing `styve-sync` integration. No dashboard source or database schema is changed by this PWA update.

## Existing shop rules
Bank transfer checkout, one unit per product, stock-aware Sold Out labels, and guest checkout are retained. Server-side stock and price validation remains authoritative.
