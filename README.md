<!DOCTYPE html>
<html lang="en" class="h-full bg-slate-900 text-slate-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <meta name="theme-color" content="#0f172a">
    <title>Styve - Business Suite (Supabase Cloud Sync)</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Canvas Confetti -->
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
    <!-- Supabase JS Client -->
    <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
    <!-- Inter Font -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    fontFamily: { sans: ['"Plus Jakarta Sans"', 'sans-serif'] },
                    colors: { brand: { 500: '#ec4899', 600: '#db2777', 700: '#be185d' } }
                }
            }
        }
    </script>
    <style>
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: rgba(148, 163, 184, 0.2); border-radius: 9999px; }
        .ig-bg-gradient { background: linear-gradient(135deg, #833ab4, #fd1d1d, #fcb045); }
        
        /* Fix scrolling behavior */
        html, body { height: 100%; overflow: auto !important; }
        body { display: flex; flex-direction: row; }
        main { overflow-y: auto !important; -webkit-overflow-scrolling: touch; }

        @keyframes toastIn { from {opacity:0; transform:translateY(12px)} to {opacity:1; transform:none} }
        .toast { animation: toastIn .2s ease-out; }
    </style>
</head>
<body class="bg-slate-950 text-slate-100 min-h-full">

    <!-- LOGIN SCREEN OVERLAY -->
    <div id="login-overlay" class="fixed inset-0 bg-slate-950 z-[100] flex items-center justify-center p-4 hidden">
        <div class="bg-slate-900 border border-slate-800 w-full max-w-md rounded-3xl p-8 space-y-6 shadow-2xl">
            <div class="text-center space-y-2">
                <div class="w-14 h-14 rounded-2xl ig-bg-gradient mx-auto flex items-center justify-center text-white shadow-xl shadow-pink-500/20 text-2xl">
                    <i class="fa-solid fa-store"></i>
                </div>
                <h1 class="text-xl font-bold text-white">Styve Business Suite</h1>
                <p class="text-xs text-slate-400">Sign in securely with your Supabase cloud account</p>
            </div>

            <form id="login-form" onsubmit="handleAuthSubmit(event)" class="space-y-4 text-xs sm:text-sm">
                <div>
                    <label class="block text-slate-400 mb-1 font-semibold">Email Address</label>
                    <input type="email" id="auth-email" required placeholder="you@example.com" class="w-full px-3.5 py-2.5 bg-slate-950 border border-slate-800 rounded-xl focus:outline-none focus:border-pink-500">
                </div>
                <div>
                    <label class="block text-slate-400 mb-1 font-semibold">Password</label>
                    <input type="password" id="auth-password" required placeholder="••••••••" class="w-full px-3.5 py-2.5 bg-slate-950 border border-slate-800 rounded-xl focus:outline-none focus:border-pink-500">
                </div>

                <div id="auth-error" class="text-red-400 text-xs text-center hidden"></div>

                <button type="submit" id="auth-submit-btn" class="w-full py-3 bg-gradient-to-r from-pink-500 to-rose-600 hover:from-pink-600 hover:to-rose-700 text-white font-bold rounded-xl shadow-lg shadow-pink-500/20 transition">
                    Sign In
                </button>

                <div class="text-center pt-2">
                    <button type="button" onclick="toggleAuthMode()" class="text-xs text-pink-400 hover:underline">
                        Need an account? <span id="auth-toggle-text" class="font-bold">Sign Up</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Main Sidebar Navigation -->
    <aside id="sidebar" class="fixed lg:static inset-y-0 left-0 w-64 bg-slate-900 border-r border-slate-800 z-50 flex flex-col transition-transform duration-300 -translate-x-full lg:translate-x-0 shrink-0">
        <div class="p-5 border-b border-slate-800/80 flex items-center justify-between">
            <div class="flex items-center space-x-3">
                <div class="w-10 h-10 rounded-xl ig-bg-gradient flex items-center justify-center text-white shadow-lg shadow-pink-500/20">
                    <i class="fa-solid fa-store text-lg"></i>
                </div>
                <div>
                    <h1 class="font-bold text-base text-white tracking-tight">Styve</h1>
                    <p class="text-[11px] text-slate-400">Skincare & Baby Care</p>
                </div>
            </div>
            <button id="close-mobile-menu" class="lg:hidden text-slate-400 hover:text-white p-1"><i class="fa-solid fa-xmark text-lg"></i></button>
        </div>

        <nav class="flex-1 px-3 py-4 space-y-1 overflow-y-auto">
            <button onclick="switchTab('dashboard')" id="nav-dashboard" class="nav-item active w-full flex items-center space-x-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-300 hover:bg-slate-800/60">
                <i class="fa-solid fa-chart-pie w-5 text-center text-pink-500"></i><span>Dashboard</span>
            </button>
            <button onclick="switchTab('inventory')" id="nav-inventory" class="nav-item w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-300 hover:bg-slate-800/60">
                <div class="flex items-center space-x-3"><i class="fa-solid fa-boxes-stacked w-5 text-center text-amber-500"></i><span>Stock & Inventory</span></div>
                <span id="low-stock-badge" class="hidden bg-amber-500/20 text-amber-400 text-xs font-bold px-2 py-0.5 rounded-full border border-amber-500/30">0</span>
            </button>
            <button onclick="switchTab('orders')" id="nav-orders" class="nav-item w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-300 hover:bg-slate-800/60">
                <div class="flex items-center space-x-3"><i class="fa-solid fa-bag-shopping w-5 text-center text-indigo-500"></i><span>Sales & Orders</span></div>
                <span id="pending-orders-badge" class="bg-indigo-500/20 text-indigo-400 text-xs font-bold px-2 py-0.5 rounded-full border border-indigo-500/30">0</span>
            </button>
            <button onclick="switchTab('inbox')" id="nav-inbox" class="nav-item w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-300 hover:bg-slate-800/60">
                <div class="flex items-center space-x-3"><i class="fa-brands fa-instagram w-5 text-center text-rose-500 text-lg"></i><span>IG Order Inbox</span></div>
                <span class="w-2 h-2 rounded-full bg-rose-500 animate-pulse"></span>
            </button>
            <button onclick="switchTab('analytics')" id="nav-analytics" class="nav-item w-full flex items-center space-x-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-300 hover:bg-slate-800/60">
                <i class="fa-solid fa-chart-line w-5 text-center text-emerald-500"></i><span>Analytics & Profit</span>
            </button>
        </nav>

        <div class="p-4 border-t border-slate-800/80 bg-slate-900/50 space-y-3">
            <div class="bg-slate-800/50 rounded-xl p-3 border border-slate-700/50 flex items-center justify-between">
                <div>
                    <span class="text-[10px] text-slate-400 block">Cloud Status</span>
                    <span id="sync-status" class="text-xs font-bold text-emerald-400"><i class="fa-solid fa-circle text-[8px] mr-1"></i>Connected</span>
                </div>
                <button onclick="handleLogout()" class="px-2.5 py-1.5 bg-slate-700 hover:bg-slate-600 text-white rounded-lg text-xs font-semibold">Sign Out</button>
            </div>
        </div>
    </aside>

    <!-- Main Content Area -->
    <div class="flex-1 flex flex-col min-w-0 min-h-screen">
        <header class="h-16 bg-slate-900/80 backdrop-blur border-b border-slate-800 px-4 sm:px-6 flex items-center justify-between shrink-0 sticky top-0 z-30">
            <div class="flex items-center space-x-3">
                <button id="open-mobile-menu" class="lg:hidden text-slate-400 hover:text-white p-2 rounded-lg bg-slate-800"><i class="fa-solid fa-bars text-lg"></i></button>
                <h2 id="page-title" class="text-lg font-bold text-white">Dashboard Overview</h2>
            </div>
            <div class="flex items-center space-x-3">
                <button onclick="openNewOrderModal()" class="px-3.5 py-2 bg-gradient-to-r from-pink-500 to-rose-600 text-white text-xs sm:text-sm font-semibold rounded-xl shadow-lg shadow-pink-500/20 transition flex items-center space-x-2">
                    <i class="fa-solid fa-plus text-xs"></i><span>Log Order</span>
                </button>
                <button onclick="openAddProductModal()" class="px-3.5 py-2 bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs sm:text-sm font-semibold rounded-xl border border-slate-700 transition hidden sm:flex items-center space-x-2">
                    <i class="fa-solid fa-box text-xs text-amber-400"></i><span>Add Product</span>
                </button>
            </div>
        </header>

        <main class="flex-1 p-4 sm:p-6 lg:p-8 space-y-6">
            <!-- Tabs content views -->
            <section id="tab-dashboard" class="tab-content space-y-6">
                <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
                    <div class="bg-slate-900 rounded-2xl p-4 sm:p-5 border border-slate-800">
                        <p class="text-xs font-semibold text-slate-400 uppercase">Total Revenue</p>
                        <h3 id="stat-revenue" class="text-xl sm:text-2xl font-bold text-white mt-1">MVR 0.00</h3>
                        <span id="stat-profit-gross" class="text-xs text-emerald-400 mt-2 block">Net Profit: MVR 0</span>
                    </div>
                    <div class="bg-slate-900 rounded-2xl p-4 sm:p-5 border border-slate-800">
                        <p class="text-xs font-semibold text-slate-400 uppercase">Total Sales</p>
                        <h3 id="stat-orders" class="text-xl sm:text-2xl font-bold text-white mt-1">0 Orders</h3>
                        <span id="stat-pending-orders" class="text-xs text-slate-400 mt-2 block">0 Pending</span>
                    </div>
                    <div class="bg-slate-900 rounded-2xl p-4 sm:p-5 border border-slate-800">
                        <p class="text-xs font-semibold text-slate-400 uppercase">Stock Health</p>
                        <h3 id="stat-low-stock-count" class="text-xl sm:text-2xl font-bold text-white mt-1">0 Items Low</h3>
                        <span class="text-xs text-amber-400 mt-2 block">Requires attention</span>
                    </div>
                    <div class="bg-slate-900 rounded-2xl p-4 sm:p-5 border border-slate-800">
                        <p class="text-xs font-semibold text-slate-400 uppercase">Avg Profit Margin</p>
                        <h3 id="stat-avg-margin" class="text-xl sm:text-2xl font-bold text-white mt-1">0%</h3>
                        <span class="text-xs text-pink-400 mt-2 block">Across catalog</span>
                    </div>
                </div>
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div class="lg:col-span-2 bg-slate-900 rounded-2xl p-5 border border-slate-800">
                        <h3 class="font-bold text-base text-white mb-4"><i class="fa-solid fa-clock-rotate-left text-pink-500 mr-2"></i>Recent Orders</h3>
                        <table class="w-full text-left text-xs"><tbody id="recent-orders-tbody" class="divide-y divide-slate-800"></tbody></table>
                    </div>
                    <div class="bg-slate-900 rounded-2xl p-5 border border-slate-800">
                        <h3 class="font-bold text-base text-white mb-4"><i class="fa-solid fa-triangle-exclamation text-amber-500 mr-2"></i>Stock Alerts</h3>
                        <div id="dashboard-stock-alerts" class="space-y-3"></div>
                    </div>
                </div>
            </section>

            <section id="tab-inventory" class="tab-content hidden space-y-6">
                <div class="flex gap-4 justify-between bg-slate-900 p-4 rounded-2xl border border-slate-800 flex-wrap">
                    <input type="text" id="inventory-search" placeholder="Search inventory..." onkeyup="renderInventory()" class="px-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-sm flex-1">
                    <button onclick="openAddProductModal()" class="px-4 py-2 bg-amber-500 text-slate-950 text-xs font-bold rounded-xl">Add Product</button>
                </div>
                <div class="bg-slate-900 rounded-2xl border border-slate-800 overflow-x-auto">
                    <table class="w-full text-left text-sm">
                        <thead class="bg-slate-800 text-slate-400 text-[11px] uppercase">
                            <tr><th class="p-4">SKU & Item</th><th class="p-4">Category</th><th class="p-4">Cost</th><th class="p-4">Price</th><th class="p-4 text-center">Stock</th><th class="p-4 text-right">Actions</th></tr>
                        </thead>
                        <tbody id="inventory-table-body" class="divide-y divide-slate-800"></tbody>
                    </table>
                </div>
            </section>

            <section id="tab-orders" class="tab-content hidden space-y-6">
                <div class="bg-slate-900 rounded-2xl border border-slate-800 overflow-x-auto">
                    <table class="w-full text-left text-sm">
                        <thead class="bg-slate-800 text-slate-400 text-[11px] uppercase">
                            <tr><th class="p-4">Order ID</th><th class="p-4">Instagram & Address</th><th class="p-4">Items</th><th class="p-4">Total</th><th class="p-4">Status</th><th class="p-4 text-right">Action</th></tr>
                        </thead>
                        <tbody id="orders-table-body" class="divide-y divide-slate-800"></tbody>
                    </table>
                </div>
            </section>

            <section id="tab-inbox" class="tab-content hidden flex flex-col lg:flex-row gap-4">
                <div class="w-full lg:w-80 bg-slate-900 rounded-2xl border border-slate-800 overflow-y-auto max-h-[300px] lg:max-h-[600px]" id="inbox-chats-list"></div>
                <div class="flex-1 bg-slate-900 rounded-2xl border border-slate-800 flex flex-col min-h-[400px]">
                    <div class="p-4 border-b border-slate-800 flex justify-between items-center">
                        <h4 id="chat-handle" class="font-bold text-white">Select a chat</h4>
                        <button onclick="convertChatToOrder()" id="convert-to-order-btn" class="hidden px-3 py-1.5 bg-pink-500 text-white rounded-xl text-xs font-bold">Convert to Order</button>
                    </div>
                    <div id="chat-messages-container" class="flex-1 p-4 overflow-y-auto space-y-3"></div>
                    <form onsubmit="sendChatMessage(event)" class="p-3 border-t border-slate-800 flex gap-2">
                        <input type="text" id="chat-input-text" placeholder="Type message..." class="flex-1 px-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-sm" disabled>
                        <button type="submit" class="px-4 py-2 bg-rose-500 text-white rounded-xl" disabled id="chat-send-btn"><i class="fa-solid fa-paper-plane"></i></button>
                    </form>
                </div>
            </section>

            <section id="tab-analytics" class="tab-content hidden space-y-6">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <div class="bg-slate-900 p-5 rounded-2xl border border-slate-800 h-80"><canvas id="chart-monthly-sales"></canvas></div>
                    <div class="bg-slate-900 p-5 rounded-2xl border border-slate-800 h-80"><canvas id="chart-top-products"></canvas></div>
                </div>
            </section>
        </main>
    </div>

    <!-- Modals -->
    <div id="product-modal" class="fixed inset-0 bg-black/70 backdrop-blur-sm z-50 flex items-center justify-center p-4 hidden">
        <div class="bg-slate-900 border border-slate-800 w-full max-w-md rounded-2xl p-6 space-y-4">
            <h3 class="font-bold text-lg text-white">Product Item</h3>
            <form id="product-form" onsubmit="saveProduct(event)" class="space-y-3 text-sm">
                <input type="hidden" id="prod-id">
                <input type="text" id="prod-sku" required placeholder="SKU Code" class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl">
                <input type="text" id="prod-name" required placeholder="Product Name" class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl">
                <select id="prod-category" class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl"><option>Skincare</option><option>Baby Care</option><option>Gift Sets</option></select>
                <div class="grid grid-cols-3 gap-2">
                    <input type="number" id="prod-stock" placeholder="Stock" required class="px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl">
                    <input type="number" step="0.01" id="prod-cost" placeholder="Cost" required class="px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl">
                    <input type="number" step="0.01" id="prod-price" placeholder="Price" required class="px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl">
                </div>
                <div class="flex justify-end gap-2 pt-2"><button type="button" onclick="closeProductModal()" class="px-4 py-2 bg-slate-800 rounded-xl">Cancel</button><button type="submit" class="px-4 py-2 bg-pink-500 text-white rounded-xl font-bold">Save</button></div>
            </form>
        </div>
    </div>

    <div id="order-modal" class="fixed inset-0 bg-black/70 backdrop-blur-sm z-50 flex items-center justify-center p-4 hidden">
        <div class="bg-slate-900 border border-slate-800 w-full max-w-md rounded-2xl p-6 space-y-4">
            <h3 class="font-bold text-lg text-white">Log Order</h3>
            <form id="order-form" onsubmit="saveOrder(event)" class="space-y-3 text-sm">
                <input type="text" id="order-ig" placeholder="@ig_handle" required class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl">
                <input type="text" id="order-phone" placeholder="Phone" required class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl">
                <input type="text" id="order-address" placeholder="Delivery Address" required class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl">
                <select id="order-product-select" class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl"></select>
                <input type="number" id="order-product-qty" value="1" min="1" class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl">
                <div class="flex justify-end gap-2"><button type="button" onclick="closeOrderModal()" class="px-4 py-2 bg-slate-800 rounded-xl">Cancel</button><button type="submit" class="px-4 py-2 bg-indigo-500 text-white rounded-xl font-bold">Create Order</button></div>
            </form>
        </div>
    </div>

    <script>
        // --- SUPABASE CONFIGURATION ---
        const SUPABASE_URL = 'YOUR_SUPABASE_URL_HERE';
        const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY_HERE';
        
        let supabaseClient = null;
        try {
            supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
        } catch(e) { console.error("Supabase init error", e); }

        let products = [];
        let orders = [];
        let chats = [];
        let activeChatId = null;
        let isSignUpMode = false;

        async function checkUserSession() {
            if (!supabaseClient) { document.getElementById('login-overlay').classList.remove('hidden'); return; }
            const { data: { session } } = await supabaseClient.auth.getSession();
            if (!session) {
                document.getElementById('login-overlay').classList.remove('hidden');
            } else {
                document.getElementById('login-overlay').classList.add('hidden');
                loadCloudData();
            }
        }

        function toggleAuthMode() {
            isSignUpMode = !isSignUpMode;
            document.getElementById('auth-toggle-text').textContent = isSignUpMode ? 'Sign In' : 'Sign Up';
            document.getElementById('auth-submit-btn').textContent = isSignUpMode ? 'Create Account' : 'Sign In';
        }

        async function handleAuthSubmit(e) {
            e.preventDefault();
            const email = document.getElementById('auth-email').value.trim();
            const password = document.getElementById('auth-password').value;
            const errEl = document.getElementById('auth-error');
            errEl.classList.add('hidden');

            let res = isSignUpMode ? await supabaseClient.auth.signUp({ email, password }) : await supabaseClient.auth.signInWithPassword({ email, password });

            if (res.error) {
                errEl.textContent = res.error.message;
                errEl.classList.remove('hidden');
            } else {
                if (isSignUpMode) {
                    alert("Account created! Check your email if verification is required, or sign in.");
                    toggleAuthMode();
                } else {
                    document.getElementById('login-overlay').classList.add('hidden');
                    loadCloudData();
                }
            }
        }

        async function handleLogout() {
            await supabaseClient.auth.signOut();
            location.reload();
        }

        async function loadCloudData() {
            try {
                const [pRes, oRes, cRes] = await Promise.all([
                    supabaseClient.from('products').select('*'),
                    supabaseClient.from('orders').select('*'),
                    supabaseClient.from('chats').select('*')
                ]);

                products = pRes.data && pRes.data.length ? pRes.data : getDefaultProducts();
                orders = oRes.data || [];
                chats = cRes.data && cRes.data.length ? cRes.data : getDefaultChats();
                
                if (!pRes.data || pRes.data.length === 0) saveAllCloud();
                
                activeChatId = chats[0]?.id || null;
                refreshAll();
            } catch (err) {
                console.error("Error loading cloud data", err);
            }
        }

        async function saveAllCloud() {
            try {
                if (products.length) await supabaseClient.from('products').upsert(products);
                if (orders.length) await supabaseClient.from('orders').upsert(orders);
                if (chats.length) await supabaseClient.from('chats').upsert(chats);
            } catch (e) { console.error("Sync error", e); }
        }

        function getDefaultProducts() {
            return [
                { id: 101, sku: 'SKIN-GLOW-01', name: 'Hydrating Glow Serum 30ml', category: 'Skincare', stock: 18, cost: 140.00, price: 320.00 },
                { id: 102, sku: 'SKIN-CLEAN-02', name: 'Gentle Foaming Cleanser 150ml', category: 'Skincare', stock: 4, cost: 95.00, price: 240.00 },
                { id: 103, sku: 'BABY-BALM-01', name: 'Organic Baby Diaper Balm 100g', category: 'Baby Care', stock: 2, cost: 80.00, price: 195.00 }
            ];
        }

        function getDefaultChats() {
            return [
                { id: 'chat-1', handle: '@mariyam_nook', avatar_text: 'MN', messages: [{ sender: 'them', text: 'Hello! Is the Balm in stock?' }], prefill_cart: [103] }
            ];
        }

        function toast(msg) {
            const el = document.createElement('div');
            el.className = `toast bg-slate-800 border border-emerald-500/40 text-emerald-300 rounded-xl px-4 py-3 text-sm shadow-xl fixed bottom-4 right-4 z-[200]`;
            el.textContent = msg;
            document.body.appendChild(el);
            setTimeout(() => el.remove(), 3000);
        }

        function refreshAll() {
            saveAllCloud();
            renderDashboard();
            renderInventory();
            renderOrders();
        }

        function switchTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(el => el.classList.add('hidden'));
            document.querySelectorAll('.nav-item').forEach(el => el.classList.remove('bg-slate-800', 'text-white'));
            document.getElementById(`tab-${tabId}`).classList.remove('hidden');
            document.getElementById(`nav-${tabId}`).classList.add('bg-slate-800', 'text-white');
            if (tabId === 'dashboard') renderDashboard();
            if (tabId === 'inventory') renderInventory();
            if (tabId === 'orders') renderOrders();
            if (tabId === 'inbox') renderInbox();
            if (tabId === 'analytics') renderAnalytics();
        }

        function renderDashboard() {
            const rev = orders.reduce((s, o) => o.status !== 'Cancelled' ? s + o.total : s, 0);
            document.getElementById('stat-revenue').textContent = `MVR ${rev.toFixed(2)}`;
            document.getElementById('stat-orders').textContent = `${orders.length} Orders`;
            document.getElementById('stat-low-stock-count').textContent = `${products.filter(p => p.stock <= 5).length} Items Low`;
            
            const tbody = document.getElementById('recent-orders-tbody');
            tbody.innerHTML = orders.slice(0, 5).map(o => `<tr><td class="p-3 font-bold">${o.ig_handle || o.igHandle}</td><td class="p-3">MVR ${o.total}</td><td class="p-3">${o.status}</td></tr>`).join('') || `<tr><td colspan="3" class="p-4 text-center text-slate-500">No orders yet</td></tr>`;
        }

        function renderInventory() {
            const tbody = document.getElementById('inventory-table-body');
            tbody.innerHTML = products.map(p => `
                <tr class="hover:bg-slate-800/40">
                    <td class="p-4"><div class="font-bold">${p.name}</div><div class="text-xs text-slate-400">${p.sku}</div></td>
                    <td class="p-4">${p.category}</td>
                    <td class="p-4">MVR ${p.cost}</td>
                    <td class="p-4 font-bold">MVR ${p.price}</td>
                    <td class="p-4 text-center"><span class="px-2 py-1 rounded font-bold ${p.stock <= 5 ? 'bg-amber-500/20 text-amber-400' : 'bg-emerald-500/20 text-emerald-400'}">${p.stock}</span></td>
                    <td class="p-4 text-right"><button onclick="deleteProduct(${p.id})" class="text-rose-400 hover:underline">Delete</button></td>
                </tr>
            `).join('');
        }

        function renderOrders() {
            const tbody = document.getElementById('orders-table-body');
            tbody.innerHTML = orders.map(o => `
                <tr class="hover:bg-slate-800/40">
                    <td class="p-4 font-mono font-bold">${o.id}</td>
                    <td class="p-4">${o.ig_handle || o.igHandle}<div class="text-xs text-slate-400">${o.address}</div></td>
                    <td class="p-4">${(o.items || []).map(i => i.name).join(', ')}</td>
                    <td class="p-4 font-bold">MVR ${o.total}</td>
                    <td class="p-4">${o.status}</td>
                    <td class="p-4 text-right"><button onclick="deleteOrder('${o.id}')" class="text-rose-400">Delete</button></td>
                </tr>
            `).join('');
        }

        function renderInbox() {
            const list = document.getElementById('inbox-chats-list');
            list.innerHTML = chats.map(c => `
                <div onclick="selectChat('${c.id}')" class="p-4 cursor-pointer hover:bg-slate-800 border-b border-slate-800 ${c.id === activeChatId ? 'bg-slate-800' : ''}">
                    <div class="font-bold text-sm">${c.handle}</div>
                </div>
            `).join('');
            if (activeChatId) renderActiveChat();
        }

        function selectChat(id) { activeChatId = id; renderInbox(); }

        function renderActiveChat() {
            const chat = chats.find(c => c.id === activeChatId);
            if (!chat) return;
            document.getElementById('chat-handle').textContent = chat.handle;
            document.getElementById('convert-to-order-btn').classList.remove('hidden');
            document.getElementById('chat-input-text').disabled = false;
            document.getElementById('chat-send-btn').disabled = false;
            
            document.getElementById('chat-messages-container').innerHTML = (chat.messages || []).map(m => `
                <div class="flex ${m.sender === 'me' ? 'justify-end' : 'justify-start'}">
                    <div class="p-3 rounded-xl text-xs max-w-[75%] ${m.sender === 'me' ? 'bg-pink-600 text-white' : 'bg-slate-800 text-slate-200'}">${m.text}</div>
                </div>
            `).join('');
        }

        function sendChatMessage(e) {
            e.preventDefault();
            const input = document.getElementById('chat-input-text');
            const txt = input.value.trim();
            if (!txt || !activeChatId) return;
            const chat = chats.find(c => c.id === activeChatId);
            chat.messages.push({ sender: 'me', text: txt });
            input.value = '';
            saveAllCloud();
            renderActiveChat();
        }

        function convertChatToOrder() {
            const chat = chats.find(c => c.id === activeChatId);
            if (!chat) return;
            const newOrder = {
                id: `ORD-${Math.floor(1000 + Math.random() * 9000)}`,
                date: new Date().toISOString().split('T')[0],
                ig_handle: chat.handle,
                phone: '7770000',
                address: 'Malé, Maldives',
                items: [{ name: 'Sample Item', qty: 1, price: 250 }],
                total: 250,
                status: 'Pending',
                payment: 'BML Transfer'
            };
            orders.unshift(newOrder);
            saveAllCloud();
            toast("Converted chat to order!");
            switchTab('orders');
        }

        function openAddProductModal() { document.getElementById('product-modal').classList.remove('hidden'); }
        function closeProductModal() { document.getElementById('product-modal').classList.add('hidden'); }
        
        async function saveProduct(e) {
            e.preventDefault();
            const p = {
                id: Date.now(),
                sku: document.getElementById('prod-sku').value,
                name: document.getElementById('prod-name').value,
                category: document.getElementById('prod-category').value,
                stock: parseInt(document.getElementById('prod-stock').value),
                cost: parseFloat(document.getElementById('prod-cost').value),
                price: parseFloat(document.getElementById('prod-price').value)
            };
            products.push(p);
            await saveAllCloud();
            closeProductModal();
            refreshAll();
            toast("Product saved to cloud!");
        }

        async function deleteProduct(id) {
            products = products.filter(p => p.id !== id);
            await supabaseClient.from('products').delete().eq('id', id);
            refreshAll();
        }

        async function deleteOrder(id) {
            orders = orders.filter(o => o.id !== id);
            await supabaseClient.from('orders').delete().eq('id', id);
            refreshAll();
        }

        function renderAnalytics() {
            const ctx = document.getElementById('chart-monthly-sales').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    datasets: [{ label: 'Revenue (MVR)', data: [1200, 2400, 3100, 4500, 5200, 6800], borderColor: '#10b981', fill: true, backgroundColor: 'rgba(16,185,129,0.05)' }]
                },
                options: { responsive: true, maintainAspectRatio: false }
            });
        }

        document.addEventListener('DOMContentLoaded', checkUserSession);
    </script>
</body>
</html>
