<!DOCTYPE html>
<html lang="en" class="h-full bg-slate-900 text-slate-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <meta name="theme-color" content="#0f172a">
    <title>Styve - Business Suite</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Canvas Confetti -->
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
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
        
        html, body { height: 100%; overflow: auto !important; }
        body { display: flex; flex-direction: row; }
        main { overflow-y: auto !important; -webkit-overflow-scrolling: touch; }

        @keyframes toastIn { from {opacity:0; transform:translateY(12px)} to {opacity:1; transform:none} }
        .toast { animation: toastIn .2s ease-out; }
        button:focus-visible, select:focus-visible, input:focus-visible { outline: 2px solid #ec4899; outline-offset: 2px; }
    </style>
</head>
<body class="bg-slate-950 text-slate-100 min-h-full">

    <!-- Mobile Sidebar Backdrop -->
    <div id="sidebar-backdrop" class="fixed inset-0 bg-black/60 backdrop-blur-sm z-40 hidden lg:hidden"></div>

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
            <button onclick="switchTab('dashboard')" id="nav-dashboard" class="nav-item active w-full flex items-center space-x-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-300 hover:bg-slate-800/60 transition">
                <i class="fa-solid fa-chart-pie w-5 text-center text-pink-500"></i><span>Dashboard</span>
            </button>
            <button onclick="switchTab('inventory')" id="nav-inventory" class="nav-item w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-300 hover:bg-slate-800/60 transition">
                <div class="flex items-center space-x-3"><i class="fa-solid fa-boxes-stacked w-5 text-center text-amber-500"></i><span>Stock & Inventory</span></div>
                <span id="low-stock-badge" class="hidden bg-amber-500/20 text-amber-400 text-xs font-bold px-2 py-0.5 rounded-full border border-amber-500/30">0</span>
            </button>
            <button onclick="switchTab('orders')" id="nav-orders" class="nav-item w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-300 hover:bg-slate-800/60 transition">
                <div class="flex items-center space-x-3"><i class="fa-solid fa-bag-shopping w-5 text-center text-indigo-500"></i><span>Sales & Orders</span></div>
                <span id="pending-orders-badge" class="bg-indigo-500/20 text-indigo-400 text-xs font-bold px-2 py-0.5 rounded-full border border-indigo-500/30">0</span>
            </button>
            <button onclick="switchTab('inbox')" id="nav-inbox" class="nav-item w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-300 hover:bg-slate-800/60 transition">
                <div class="flex items-center space-x-3"><i class="fa-brands fa-instagram w-5 text-center text-rose-500 text-lg"></i><span>IG Order Inbox</span></div>
                <span class="w-2 h-2 rounded-full bg-rose-500 animate-pulse"></span>
            </button>
            <button onclick="switchTab('analytics')" id="nav-analytics" class="nav-item w-full flex items-center space-x-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-300 hover:bg-slate-800/60 transition">
                <i class="fa-solid fa-chart-line w-5 text-center text-emerald-500"></i><span>Analytics & Profit</span>
            </button>
        </nav>

        <div class="p-4 border-t border-slate-800/80 bg-slate-900/50 space-y-3">
            <div class="bg-slate-800/50 rounded-xl p-3 border border-slate-700/50">
                <div class="flex items-center justify-between text-xs text-slate-400 mb-1">
                    <span>Active Currency</span>
                    <span class="font-bold text-white bg-slate-700 px-1.5 py-0.5 rounded">MVR (Rf)</span>
                </div>
                <div class="text-[11px] text-slate-500">Maldivian Rufiyaa Shop</div>
            </div>

            <button onclick="resetFullApp()" class="w-full py-2 px-3 bg-red-500/10 hover:bg-red-500/20 text-red-400 text-xs font-bold rounded-xl border border-red-500/30 transition flex items-center justify-center gap-2">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <span>Reset Entire App</span>
            </button>
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
                <button onclick="openNewOrderModal()" class="px-3.5 py-2 bg-gradient-to-r from-pink-500 to-rose-600 hover:from-pink-600 hover:to-rose-700 text-white text-xs sm:text-sm font-semibold rounded-xl shadow-lg shadow-pink-500/20 transition flex items-center space-x-2">
                    <i class="fa-solid fa-plus text-xs"></i><span>Log Order</span>
                </button>
                <button onclick="openAddProductModal()" class="px-3.5 py-2 bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs sm:text-sm font-semibold rounded-xl border border-slate-700 transition hidden sm:flex items-center space-x-2">
                    <i class="fa-solid fa-box text-xs text-amber-400"></i><span>Add Product</span>
                </button>
            </div>
        </header>

        <main class="flex-1 p-4 sm:p-6 lg:p-8 space-y-6">
            <!-- 1. DASHBOARD TAB -->
            <section id="tab-dashboard" class="tab-content space-y-6">
                <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
                    <div class="bg-slate-900 rounded-2xl p-4 sm:p-5 border border-slate-800 shadow-sm">
                        <p class="text-xs font-semibold text-slate-400 uppercase">Total Revenue</p>
                        <h3 id="stat-revenue" class="text-xl sm:text-2xl font-bold text-white mt-1">MVR 0.00</h3>
                        <span id="stat-profit-gross" class="text-xs text-emerald-400 mt-2 block">Net Profit: MVR 0</span>
                    </div>
                    <div class="bg-slate-900 rounded-2xl p-4 sm:p-5 border border-slate-800 shadow-sm">
                        <p class="text-xs font-semibold text-slate-400 uppercase">Total Sales</p>
                        <h3 id="stat-orders" class="text-xl sm:text-2xl font-bold text-white mt-1">0 Orders</h3>
                        <span id="stat-pending-orders" class="text-xs text-slate-400 mt-2 block">0 Pending</span>
                    </div>
                    <div class="bg-slate-900 rounded-2xl p-4 sm:p-5 border border-slate-800 shadow-sm">
                        <p class="text-xs font-semibold text-slate-400 uppercase">Stock Health</p>
                        <h3 id="stat-low-stock-count" class="text-xl sm:text-2xl font-bold text-white mt-1">0 Items Low</h3>
                        <span class="text-xs text-amber-400 mt-2 block">Requires attention</span>
                    </div>
                    <div class="bg-slate-900 rounded-2xl p-4 sm:p-5 border border-slate-800 shadow-sm">
                        <p class="text-xs font-semibold text-slate-400 uppercase">Avg Profit Margin</p>
                        <h3 id="stat-avg-margin" class="text-xl sm:text-2xl font-bold text-white mt-1">0%</h3>
                        <span class="text-xs text-pink-400 mt-2 block">Across catalog</span>
                    </div>
                </div>
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div class="lg:col-span-2 bg-slate-900 rounded-2xl p-5 border border-slate-800 flex flex-col shadow-sm">
                        <div class="flex items-center justify-between mb-4">
                            <h3 class="font-bold text-base text-white flex items-center gap-2"><i class="fa-solid fa-clock-rotate-left text-pink-500"></i>Recent Instagram Orders</h3>
                            <button onclick="switchTab('orders')" class="text-xs text-pink-400 hover:text-pink-300 font-semibold transition">View All</button>
                        </div>
                        <div class="overflow-x-auto flex-1">
                            <table class="w-full text-left text-xs">
                                <thead class="bg-slate-800/60 text-slate-400 uppercase font-semibold">
                                    <tr><th class="px-3 py-2.5 rounded-l-lg">Customer</th><th class="px-3 py-2.5">Items</th><th class="px-3 py-2.5">Total</th><th class="px-3 py-2.5">Status</th><th class="px-3 py-2.5 rounded-r-lg">Action</th></tr>
                                </thead>
                                <tbody id="recent-orders-tbody" class="divide-y divide-slate-800"></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="bg-slate-900 rounded-2xl p-5 border border-slate-800 flex flex-col shadow-sm">
                        <h3 class="font-bold text-base text-white mb-4 flex items-center gap-2"><i class="fa-solid fa-triangle-exclamation text-amber-500"></i>Stock Alert Center</h3>
                        <div id="dashboard-stock-alerts" class="space-y-3 flex-1 overflow-y-auto max-h-[300px] pr-1"></div>
                    </div>
                </div>
            </section>

            <!-- 2. INVENTORY TAB -->
            <section id="tab-inventory" class="tab-content hidden space-y-6">
                <div class="flex gap-4 justify-between bg-slate-900 p-4 rounded-2xl border border-slate-800 flex-wrap items-center shadow-sm">
                    <div class="relative flex-1 min-w-[240px]">
                        <i class="fa-solid fa-magnifying-glass absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-500"></i>
                        <input type="text" id="inventory-search" placeholder="Search by SKU or Product Name..." onkeyup="renderInventory()" class="w-full pl-10 pr-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-sm focus:outline-none focus:border-pink-500">
                    </div>
                    <button onclick="openAddProductModal()" class="px-4 py-2 bg-amber-500 hover:bg-amber-600 text-slate-950 text-xs font-bold rounded-xl transition flex items-center gap-1.5 shadow-md"><i class="fa-solid fa-plus"></i> Add Product</button>
                </div>
                <div class="bg-slate-900 rounded-2xl border border-slate-800 overflow-hidden shadow-sm">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left text-sm">
                            <thead class="bg-slate-800/80 text-slate-400 text-[11px] uppercase font-semibold">
                                <tr><th class="p-4">SKU & Item</th><th class="p-4">Category</th><th class="p-4">Cost</th><th class="p-4">Price</th><th class="p-4 text-center">Stock</th><th class="p-4 text-right">Actions</th></tr>
                            </thead>
                            <tbody id="inventory-table-body" class="divide-y divide-slate-800"></tbody>
                        </table>
                    </div>
                </div>
            </section>

            <!-- 3. ORDERS TAB -->
            <section id="tab-orders" class="tab-content hidden space-y-6">
                <div class="flex gap-4 justify-between bg-slate-900 p-4 rounded-2xl border border-slate-800 items-center flex-wrap shadow-sm">
                    <div class="relative flex-1 min-w-[240px]">
                        <i class="fa-solid fa-magnifying-glass absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-500"></i>
                        <input type="text" id="order-search" placeholder="Search orders..." onkeyup="renderOrders()" class="w-full pl-10 pr-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-sm focus:outline-none focus:border-indigo-500">
                    </div>
                    <button onclick="openNewOrderModal()" class="px-4 py-2 bg-indigo-500 hover:bg-indigo-600 text-white text-xs font-bold rounded-xl transition flex items-center gap-1.5 shadow-md"><i class="fa-solid fa-cart-plus"></i> Log Order</button>
                </div>
                <div class="bg-slate-900 rounded-2xl border border-slate-800 overflow-hidden shadow-sm">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left text-sm">
                            <thead class="bg-slate-800/80 text-slate-400 text-[11px] uppercase font-semibold">
                                <tr><th class="p-4">Order ID & Date</th><th class="p-4">Instagram & Address</th><th class="p-4">Items Ordered</th><th class="p-4">Total</th><th class="p-4">Status</th><th class="p-4 text-right">Action</th></tr>
                            </thead>
                            <tbody id="orders-table-body" class="divide-y divide-slate-800"></tbody>
                        </table>
                    </div>
                </div>
            </section>

            <!-- 4. INBOX SIMULATOR TAB -->
            <section id="tab-inbox" class="tab-content hidden flex flex-col lg:flex-row gap-4 h-[calc(100vh-140px)]">
                <div class="w-full lg:w-80 bg-slate-900 rounded-2xl border border-slate-800 overflow-y-auto shrink-0 shadow-sm" id="inbox-chats-list"></div>
                <div class="flex-1 bg-slate-900 rounded-2xl border border-slate-800 flex flex-col overflow-hidden shadow-sm">
                    <div class="p-4 border-b border-slate-800 flex justify-between items-center bg-slate-900/50">
                        <h4 id="chat-handle" class="font-bold text-white text-sm">Select a chat</h4>
                        <button onclick="convertChatToOrder()" id="convert-to-order-btn" class="hidden px-3.5 py-2 bg-gradient-to-r from-pink-500 to-rose-600 text-white rounded-xl text-xs font-bold shadow-md transition flex items-center gap-1.5"><i class="fa-solid fa-bolt"></i> Convert to Order</button>
                    </div>
                    <div id="chat-messages-container" class="flex-1 p-4 overflow-y-auto space-y-3 bg-slate-950/40"></div>
                    <form onsubmit="sendChatMessage(event)" class="p-3 border-t border-slate-800 flex gap-2 bg-slate-900">
                        <input type="text" id="chat-input-text" placeholder="Type message..." class="flex-1 px-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-sm focus:outline-none focus:border-rose-500" disabled>
                        <button type="submit" class="px-4 py-2 bg-rose-500 hover:bg-rose-600 text-white rounded-xl text-xs font-semibold transition" disabled id="chat-send-btn"><i class="fa-solid fa-paper-plane"></i></button>
                    </form>
                </div>
            </section>

            <!-- 5. ANALYTICS TAB -->
            <section id="tab-analytics" class="tab-content hidden space-y-6">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <div class="bg-slate-900 p-5 rounded-2xl border border-slate-800 h-80 shadow-sm"><canvas id="chart-monthly-sales"></canvas></div>
                    <div class="bg-slate-900 p-5 rounded-2xl border border-slate-800 h-80 shadow-sm"><canvas id="chart-top-products"></canvas></div>
                </div>
            </section>
        </main>
    </div>

    <!-- TOAST NOTIFICATION CONTAINER -->
    <div id="toast-container" class="fixed bottom-4 right-4 z-[200] flex flex-col gap-2 items-end pointer-events-none"></div>

    <!-- CUSTOM CONFIRM DIALOG MODAL -->
    <div id="confirm-modal" class="fixed inset-0 bg-black/70 backdrop-blur-sm z-[150] flex items-center justify-center p-4 hidden">
        <div class="bg-slate-900 border border-slate-800 w-full max-w-sm rounded-2xl p-6 space-y-4 shadow-2xl">
            <div class="flex items-start gap-3">
                <div class="w-10 h-10 shrink-0 rounded-full bg-red-500/15 text-red-400 flex items-center justify-center"><i class="fa-solid fa-triangle-exclamation"></i></div>
                <p id="confirm-text" class="text-sm text-slate-200 pt-1"></p>
            </div>
            <div class="flex justify-end gap-2 pt-2">
                <button id="confirm-cancel" class="px-4 py-2 bg-slate-800 hover:bg-slate-700 text-slate-300 rounded-xl text-xs font-semibold transition">Cancel</button>
                <button id="confirm-ok" class="px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded-xl text-xs font-bold transition">Confirm</button>
            </div>
        </div>
    </div>

    <!-- MODAL 1: PRODUCT MODAL -->
    <div id="product-modal" class="fixed inset-0 bg-black/70 backdrop-blur-sm z-50 flex items-center justify-center p-4 hidden">
        <div class="bg-slate-900 border border-slate-800 w-full max-w-md rounded-2xl p-6 space-y-4 shadow-2xl">
            <div class="flex justify-between items-center border-b border-slate-800 pb-3">
                <h3 id="product-modal-title" class="font-bold text-lg text-white">Add Product</h3>
                <button onclick="closeProductModal()" class="text-slate-400 hover:text-white"><i class="fa-solid fa-xmark text-lg"></i></button>
            </div>
            <form id="product-form" onsubmit="saveProduct(event)" class="space-y-3.5 text-sm">
                <input type="hidden" id="prod-id">
                <div><label class="block text-slate-400 mb-1 text-xs font-semibold">SKU Code</label><input type="text" id="prod-sku" required placeholder="SKU-001" class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl focus:outline-none focus:border-pink-500"></div>
                <div><label class="block text-slate-400 mb-1 text-xs font-semibold">Product Name</label><input type="text" id="prod-name" required placeholder="Baby Gentle Wash" class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl focus:outline-none focus:border-pink-500"></div>
                <div><label class="block text-slate-400 mb-1 text-xs font-semibold">Category</label><select id="prod-category" class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl focus:outline-none focus:border-pink-500"><option>Skincare</option><option>Baby Care</option><option>Gift Sets</option></select></div>
                <div class="grid grid-cols-3 gap-2">
                    <div><label class="block text-slate-400 mb-1 text-xs font-semibold">Stock</label><input type="number" id="prod-stock" min="0" required class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl focus:outline-none focus:border-pink-500"></div>
                    <div><label class="block text-slate-400 mb-1 text-xs font-semibold">Cost (Rf)</label><input type="number" step="0.01" id="prod-cost" required class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl focus:outline-none focus:border-pink-500"></div>
                    <div><label class="block text-slate-400 mb-1 text-xs font-semibold">Price (Rf)</label><input type="number" step="0.01" id="prod-price" required class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl focus:outline-none focus:border-pink-500"></div>
                </div>
                <div class="flex justify-end gap-2 pt-3 border-t border-slate-800"><button type="button" onclick="closeProductModal()" class="px-4 py-2 bg-slate-800 text-slate-300 rounded-xl font-semibold transition">Cancel</button><button type="submit" class="px-4 py-2 bg-pink-500 hover:bg-pink-600 text-white rounded-xl font-bold transition shadow-md">Save Product</button></div>
            </form>
        </div>
    </div>

    <!-- MODAL 2: ORDER MODAL -->
    <div id="order-modal" class="fixed inset-0 bg-black/70 backdrop-blur-sm z-50 flex items-center justify-center p-4 hidden">
        <div class="bg-slate-900 border border-slate-800 w-full max-w-lg rounded-2xl p-6 space-y-4 shadow-2xl max-h-[90vh] overflow-y-auto">
            <div class="flex justify-between items-center border-b border-slate-800 pb-3">
                <h3 class="font-bold text-lg text-white">Log Instagram Order</h3>
                <button onclick="closeOrderModal()" class="text-slate-400 hover:text-white"><i class="fa-solid fa-xmark text-lg"></i></button>
            </div>
            <form id="order-form" onsubmit="saveOrder(event)" class="space-y-4 text-sm">
                <div class="grid grid-cols-2 gap-3">
                    <div><label class="block text-slate-400 mb-1 text-xs font-semibold">Instagram Handle</label><input type="text" id="order-ig" required placeholder="@username" class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl focus:outline-none focus:border-indigo-500"></div>
                    <div><label class="block text-slate-400 mb-1 text-xs font-semibold">Phone Number</label><input type="text" id="order-phone" required placeholder="777XXXX" class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl focus:outline-none focus:border-indigo-500"></div>
                </div>
                <div><label class="block text-slate-400 mb-1 text-xs font-semibold">Delivery Address / Notes</label><input type="text" id="order-address" required placeholder="e.g. H. Sunshine, Malé" class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl focus:outline-none focus:border-indigo-500"></div>

                <div class="p-3 bg-slate-950 rounded-xl border border-slate-800 space-y-3">
                    <label class="block text-slate-300 font-bold text-xs">Add Products to Cart</label>
                    <div class="grid grid-cols-12 gap-2">
                        <select id="order-product-select" class="col-span-7 px-3 py-2 bg-slate-900 border border-slate-800 rounded-xl text-xs focus:outline-none"></select>
                        <input type="number" id="order-product-qty" min="1" value="1" class="col-span-3 px-3 py-2 bg-slate-900 border border-slate-800 rounded-xl text-xs text-center focus:outline-none">
                        <button type="button" onclick="addItemToOrderCart()" class="col-span-2 bg-indigo-500 hover:bg-indigo-600 text-white font-bold rounded-xl text-xs transition">Add</button>
                    </div>
                    <div id="order-cart-items" class="space-y-1 pt-1"><p class="text-slate-500 text-xs italic">No items added yet.</p></div>
                    <div class="flex justify-between items-center pt-2 border-t border-slate-800 text-xs">
                        <span class="text-slate-400 font-semibold">Grand Total:</span>
                        <span id="order-grand-total" class="font-bold text-white text-base">MVR 0.00</span>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div><label class="block text-slate-400 mb-1 text-xs font-semibold">Status</label><select id="order-status" class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl focus:outline-none"><option>Pending</option><option>Paid</option><option>Packed</option><option>Shipped</option></select></div>
                    <div><label class="block text-slate-400 mb-1 text-xs font-semibold">Payment</label><select id="order-payment" class="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl focus:outline-none"><option>BML Transfer</option><option>MIB Transfer</option><option>Cash on Delivery</option></select></div>
                </div>

                <div class="flex justify-end gap-2 pt-3 border-t border-slate-800"><button type="button" onclick="closeOrderModal()" class="px-4 py-2 bg-slate-800 text-slate-300 rounded-xl font-semibold transition">Cancel</button><button type="submit" class="px-4 py-2 bg-indigo-500 hover:bg-indigo-600 text-white rounded-xl font-bold transition shadow-md">Complete Order</button></div>
            </form>
        </div>
    </div>

    <script>
        // --- INITIAL STATE & LOCAL STORAGE PERSISTENCE ---
        const initialProducts = [
            { id: 101, sku: 'SKIN-GLOW-01', name: 'Hydrating Glow Serum 30ml', category: 'Skincare', stock: 18, cost: 140.00, price: 320.00 },
            { id: 102, sku: 'SKIN-CLEAN-02', name: 'Gentle Foaming Cleanser 150ml', category: 'Skincare', stock: 4, cost: 95.00, price: 240.00 },
            { id: 103, sku: 'BABY-BALM-01', name: 'Organic Baby Diaper Balm 100g', category: 'Baby Care', stock: 2, cost: 80.00, price: 195.00 }
        ];

        const initialOrders = [
            {
                id: 'ORD-1001',
                date: '2026-11-02',
                igHandle: '@aishath_skincare',
                phone: '7789123',
                address: 'H. Sunbeam 4th Floor, Malé',
                items: [{ productId: 101, name: 'Hydrating Glow Serum 30ml', qty: 1, price: 320.00 }],
                total: 320.00,
                status: 'Shipped',
                payment: 'BML Transfer'
            }
        ];

        const initialChats = [
            {
                id: 'chat-1',
                handle: '@mariyam_nook',
                avatarText: 'MN',
                messages: [{ sender: 'them', text: 'Hello! Is the Balm in stock?' }],
                prefillCart: [103]
            }
        ];

        function loadKey(key, fallback) {
            try { const v = JSON.parse(localStorage.getItem(key)); return Array.isArray(v) && v.length ? v : fallback; }
            catch (e) { return fallback; }
        }

        let products = loadKey('ig_products', initialProducts);
        let orders = loadKey('ig_orders', initialOrders);
        let chats = loadKey('ig_chats', initialChats);
        let activeChatId = chats[0]?.id || null;
        let orderCart = [];

        function saveState() {
            try {
                localStorage.setItem('ig_products', JSON.stringify(products));
                localStorage.setItem('ig_orders', JSON.stringify(orders));
                localStorage.setItem('ig_chats', JSON.stringify(chats));
                updateBadges();
            } catch (e) { console.error("Storage error", e); }
        }

        // Interactive Toast with Optional Undo Action
        function toast(msg, undoCallback = null) {
            const container = document.getElementById('toast-container');
            const el = document.createElement('div');
            el.className = `toast pointer-events-auto bg-slate-800 border border-emerald-500/40 text-emerald-300 rounded-xl px-4 py-3 text-sm shadow-xl flex items-center gap-3`;
            el.innerHTML = `<i class="fa-solid fa-circle-check"></i><span class="flex-1 text-slate-100">${msg}</span>`;
            if (undoCallback) {
                const undoBtn = document.createElement('button');
                undoBtn.className = 'text-pink-400 hover:text-pink-300 font-bold text-xs uppercase underline';
                undoBtn.textContent = 'Undo';
                undoBtn.onclick = () => { undoCallback(); el.remove(); };
                el.appendChild(undoBtn);
            }
            container.appendChild(el);
            setTimeout(() => el.remove(), undoCallback ? 7000 : 3500);
        }

        // Custom Confirmation Dialog Modal
        function confirmDialog(msg, onOk) {
            const m = document.getElementById('confirm-modal');
            document.getElementById('confirm-text').textContent = msg;
            const okBtn = document.getElementById('confirm-ok');
            const cancelBtn = document.getElementById('confirm-cancel');
            const close = () => m.classList.add('hidden');
            okBtn.onclick = () => { close(); onOk(); };
            cancelBtn.onclick = close;
            m.classList.remove('hidden');
        }

        function resetFullApp() {
            confirmDialog("Reset all products, orders, and chats to default state?", () => {
                localStorage.clear();
                products = [...initialProducts];
                orders = [...initialOrders];
                chats = [...initialChats];
                saveState();
                refreshAll();
                toast("App reset to default state");
            });
        }

        function refreshAll() {
            saveState();
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

        function updateBadges() {
            const lowStockCount = products.filter(p => p.stock <= 5).length;
            const lowBadge = document.getElementById('low-stock-badge');
            if (lowStockCount > 0) { lowBadge.textContent = lowStockCount; lowBadge.classList.remove('hidden'); } else { lowBadge.classList.add('hidden'); }
            document.getElementById('pending-orders-badge').textContent = orders.filter(o => o.status === 'Pending' || o.status === 'Paid').length;
        }

        function renderDashboard() {
            const totalRev = orders.reduce((s, o) => o.status !== 'Cancelled' ? s + o.total : s, 0);
            let totalProfit = 0;
            orders.forEach(ord => {
                if(ord.status !== 'Cancelled') {
                    ord.items.forEach(item => {
                        const prod = products.find(p => p.id === item.productId);
                        const cost = prod ? prod.cost : (item.price * 0.5);
                        totalProfit += (item.price - cost) * item.qty;
                    });
                }
            });

            document.getElementById('stat-revenue').textContent = `MVR ${totalRev.toFixed(2)}`;
            document.getElementById('stat-orders').textContent = `${orders.filter(o => o.status !== 'Cancelled').length} Orders`;
            document.getElementById('stat-profit-gross').textContent = `Net Profit: MVR ${totalProfit.toFixed(2)}`;
            document.getElementById('stat-pending-orders').textContent = `${orders.filter(o => o.status === 'Pending' || o.status === 'Paid').length} Pending`;
            document.getElementById('stat-low-stock-count').textContent = `${products.filter(p => p.stock <= 5).length} Items Low`;
            document.getElementById('stat-avg-margin').textContent = totalRev > 0 ? `${((totalProfit / totalRev) * 100).toFixed(1)}%` : '0%';

            const tbody = document.getElementById('recent-orders-tbody');
            tbody.innerHTML = orders.slice(0, 5).map(o => `
                <tr class="hover:bg-slate-800/40 transition">
                    <td class="px-3 py-3 font-semibold text-white">${o.igHandle}<div class="text-[10px] text-slate-400 font-normal">${o.date}</div></td>
                    <td class="px-3 py-3 text-slate-300">${o.items.length} item(s)</td>
                    <td class="px-3 py-3 font-bold text-white">MVR ${o.total.toFixed(2)}</td>
                    <td class="px-3 py-3"><span class="px-2 py-0.5 rounded text-[10px] font-bold bg-indigo-500/20 text-indigo-400">${o.status}</span></td>
                    <td class="px-3 py-3"><button onclick="switchTab('orders')" class="text-pink-400 hover:underline">View</button></td>
                </tr>
            `).join('') || `<tr><td colspan="5" class="p-4 text-center text-slate-500">No orders yet</td></tr>`;

            const lowStockItems = products.filter(p => p.stock <= 5);
            const alertBox = document.getElementById('dashboard-stock-alerts');
            alertBox.innerHTML = lowStockItems.length ? lowStockItems.map(item => `
                <div class="p-3 bg-slate-950 rounded-xl border border-amber-500/30 flex justify-between items-center text-xs">
                    <div><h4 class="font-bold text-white">${item.name}</h4><span class="text-[10px] text-slate-400">Stock: ${item.stock} left</span></div>
                    <button onclick="quickStockAdd(${item.id})" class="text-pink-400 font-bold hover:underline">+5 Stock</button>
                </div>
            `).join('') : `<div class="text-xs text-slate-500 text-center py-6">All stock levels are healthy!</div>`;
        }

        function quickStockAdd(id) {
            products = products.map(p => p.id === id ? { ...p, stock: p.stock + 5 } : p);
            refreshAll();
            toast("Added +5 units to stock");
        }

        function renderInventory() {
            const search = (document.getElementById('inventory-search').value || '').toLowerCase();
            const tbody = document.getElementById('inventory-table-body');
            const filtered = products.filter(p => p.name.toLowerCase().includes(search) || p.sku.toLowerCase().includes(search));

            tbody.innerHTML = filtered.map(p => `
                <tr class="hover:bg-slate-800/40 transition">
                    <td class="p-4"><div class="font-bold text-white">${p.name}</div><div class="text-xs text-slate-400 font-mono">${p.sku}</div></td>
                    <td class="p-4"><span class="px-2 py-1 bg-slate-800 text-slate-300 rounded-lg text-xs">${p.category}</span></td>
                    <td class="p-4 text-slate-300">MVR ${p.cost.toFixed(2)}</td>
                    <td class="p-4 font-bold text-white">MVR ${p.price.toFixed(2)}</td>
                    <td class="p-4 text-center"><span class="px-2 py-1 rounded-full text-xs font-bold ${p.stock <= 5 ? 'bg-amber-500/20 text-amber-400' : 'bg-emerald-500/20 text-emerald-400'}">${p.stock} units</span></td>
                    <td class="p-4 text-right space-x-2">
                        <button onclick="adjustStock(${p.id}, 1)" class="px-2 py-1 bg-slate-800 hover:bg-slate-700 rounded text-xs font-bold transition">+</button>
                        <button onclick="deleteProduct(${p.id})" class="text-rose-400 hover:text-rose-300 text-xs transition"><i class="fa-solid fa-trash"></i></button>
                    </td>
                </tr>
            `).join('') || `<tr><td colspan="6" class="p-8 text-center text-slate-500">No products found.</td></tr>`;
        }

        function adjustStock(id, qty) {
            products = products.map(p => p.id === id ? { ...p, stock: Math.max(0, p.stock + qty) } : p);
            refreshAll();
        }

        function renderOrders() {
            const search = (document.getElementById('order-search').value || '').toLowerCase();
            const tbody = document.getElementById('orders-table-body');
            const filtered = orders.filter(o => o.id.toLowerCase().includes(search) || o.igHandle.toLowerCase().includes(search));

            tbody.innerHTML = filtered.map(o => `
                <tr class="hover:bg-slate-800/40 transition">
                    <td class="p-4 font-mono font-bold text-white">${o.id}<div class="text-xs text-slate-400 font-normal">${o.date}</div></td>
                    <td class="p-4"><div class="font-bold text-pink-400">${o.igHandle}</div><div class="text-xs text-slate-400">${o.address}</div></td>
                    <td class="p-4 text-xs text-slate-300">${(o.items || []).map(i => `• ${i.name} (x${i.qty})`).join('<br>')}</td>
                    <td class="p-4 font-bold text-white">MVR ${o.total.toFixed(2)}</td>
                    <td class="p-4"><select onchange="updateOrderStatus('${o.id}', this.value)" class="bg-slate-950 border border-slate-800 rounded px-2 py-1 text-xs font-semibold focus:outline-none"><option ${o.status==='Pending'?'selected':''}>Pending</option><option ${o.status==='Paid'?'selected':''}>Paid</option><option ${o.status==='Packed'?'selected':''}>Packed</option><option ${o.status==='Shipped'?'selected':''}>Shipped</option><option ${o.status==='Cancelled'?'selected':''}>Cancelled</option></select></td>
                    <td class="p-4 text-right"><button onclick="deleteOrder('${o.id}')" class="text-rose-400 hover:text-rose-300 transition"><i class="fa-solid fa-trash"></i></button></td>
                </tr>
            `).join('') || `<tr><td colspan="6" class="p-8 text-center text-slate-500">No orders found.</td></tr>`;
        }

        function updateOrderStatus(id, status) {
            orders = orders.map(o => o.id === id ? { ...o, status } : o);
            refreshAll();
            toast("Order status updated");
        }

        function renderInbox() {
            const list = document.getElementById('inbox-chats-list');
            list.innerHTML = chats.map(c => `
                <div onclick="selectChat('${c.id}')" class="p-4 cursor-pointer hover:bg-slate-800/60 border-b border-slate-800 transition ${c.id === activeChatId ? 'bg-slate-800 border-l-4 border-rose-500' : ''}">
                    <div class="font-bold text-sm text-white">${c.handle}</div>
                    <div class="text-xs text-slate-400 truncate mt-0.5">${c.messages[c.messages.length - 1]?.text || ''}</div>
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
                    <div class="p-3 rounded-2xl text-xs sm:text-sm max-w-[75%] ${m.sender === 'me' ? 'bg-gradient-to-r from-rose-500 to-pink-600 text-white shadow-md' : 'bg-slate-800 text-slate-200 border border-slate-700/60'}">${m.text}</div>
                </div>
            `).join('');
            const container = document.getElementById('chat-messages-container');
            container.scrollTop = container.scrollHeight;
        }

        function sendChatMessage(e) {
            e.preventDefault();
            const input = document.getElementById('chat-input-text');
            const txt = input.value.trim();
            if (!txt || !activeChatId) return;
            const chat = chats.find(c => c.id === activeChatId);
            chat.messages.push({ sender: 'me', text: txt });
            input.value = '';
            saveState();
            renderActiveChat();
        }

        function openNewOrderModal() {
            orderCart = [];
            renderOrderCart();
            const sel = document.getElementById('order-product-select');
            sel.innerHTML = products.map(p => `<option value="${p.id}">${p.name} (MVR ${p.price} | Stock: ${p.stock})</option>`).join('');
            document.getElementById('order-form').reset();
            document.getElementById('order-modal').classList.remove('hidden');
        }

        function closeOrderModal() { document.getElementById('order-modal').classList.add('hidden'); }

        function addItemToOrderCart() {
            const pId = parseInt(document.getElementById('order-product-select').value);
            const qty = parseInt(document.getElementById('order-product-qty').value) || 1;
            const prod = products.find(p => p.id === pId);
            if (!prod) return;

            const existing = orderCart.find(i => i.productId === pId);
            if (existing) { existing.qty += qty; } else { orderCart.push({ productId: prod.id, name: prod.name, qty, price: prod.price }); }
            renderOrderCart();
        }

        function renderOrderCart() {
            const container = document.getElementById('order-cart-items');
            let total = 0;
            if (!orderCart.length) {
                container.innerHTML = `<p class="text-slate-500 text-xs italic">No items added yet.</p>`;
            } else {
                container.innerHTML = orderCart.map((item) => {
                    total += item.price * item.qty;
                    return `<div class="flex justify-between items-center text-xs bg-slate-900 p-2 rounded-lg border border-slate-800 text-slate-200"><span>${item.name} <strong class="text-pink-400">x${item.qty}</strong></span><span class="font-bold">MVR ${(item.price * item.qty).toFixed(2)}</span></div>`;
                }).join('');
            }
            document.getElementById('order-grand-total').textContent = `MVR ${total.toFixed(2)}`;
        }

        function saveOrder(e) {
            e.preventDefault();
            if (!orderCart.length) { toast("Add at least one product to the order!"); return; }
            const newOrder = {
                id: `ORD-${Math.floor(1000 + Math.random() * 9000)}`,
                date: new Date().toISOString().split('T')[0],
                igHandle: document.getElementById('order-ig').value,
                phone: document.getElementById('order-phone').value,
                address: document.getElementById('order-address').value,
                items: [...orderCart],
                total: orderCart.reduce((s, i) => s + (i.price * i.qty), 0),
                status: document.getElementById('order-status').value,
                payment: document.getElementById('order-payment').value
            };
            orders.unshift(newOrder);
            closeOrderModal();
            refreshAll();
            confetti({ particleCount: 40, spread: 60, origin: { y: 0.7 } });
            toast("Order successfully logged!");
        }

        function convertChatToOrder() {
            const chat = chats.find(c => c.id === activeChatId);
            if (!chat) return;
            openNewOrderModal();
            document.getElementById('order-ig').value = chat.handle;
            if (chat.prefillCart) {
                chat.prefillCart.forEach(pId => {
                    const prod = products.find(p => p.id === pId);
                    if (prod) orderCart.push({ productId: prod.id, name: prod.name, qty: 1, price: prod.price });
                });
                renderOrderCart();
            }
        }

        function openAddProductModal() {
            document.getElementById('product-form').reset();
            document.getElementById('prod-id').value = '';
            document.getElementById('product-modal').classList.remove('hidden');
        }

        function closeProductModal() { document.getElementById('product-modal').classList.add('hidden'); }

        function saveProduct(e) {
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
            closeProductModal();
            refreshAll();
            toast("Product saved successfully!");
        }

        function deleteProduct(id) {
            const idx = products.findIndex(p => p.id === id);
            if (idx < 0) return;
            const [removed] = products.splice(idx, 1);
            refreshAll();
            toast(`Deleted "${removed.name}"`, () => { products.splice(idx, 0, removed); refreshAll(); });
        }

        function deleteOrder(id) {
            const idx = orders.findIndex(o => o.id === id);
            if (idx < 0) return;
            const [removed] = orders.splice(idx, 1);
            refreshAll();
            toast(`Deleted order ${removed.id}`, () => { orders.splice(idx, 0, removed); refreshAll(); });
        }

        function renderAnalytics() {
            const ctx1 = document.getElementById('chart-monthly-sales').getContext('2d');
            new Chart(ctx1, {
                type: 'line',
                data: {
                    labels: ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    datasets: [{ label: 'Sales Revenue (MVR)', data: [2400, 3800, 4200, 5100, 6800, 8400], borderColor: '#10b981', fill: true, backgroundColor: 'rgba(16,185,129,0.08)', tension: 0.4 }]
                },
                options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
            });

            const ctx2 = document.getElementById('chart-top-products').getContext('2d');
            new Chart(ctx2, {
                type: 'bar',
                data: {
                    labels: products.slice(0, 4).map(p => p.name),
                    datasets: [{ label: 'Stock Level', data: products.slice(0, 4).map(p => p.stock), backgroundColor: '#ec4899', borderRadius: 6 }]
                },
                options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
            });
        }

        document.getElementById('open-mobile-menu')?.addEventListener('click', () => {
            document.getElementById('sidebar').classList.remove('-translate-x-full');
            document.getElementById('sidebar-backdrop').classList.remove('hidden');
        });
        document.getElementById('close-mobile-menu')?.addEventListener('click', () => {
            document.getElementById('sidebar').classList.add('-translate-x-full');
            document.getElementById('sidebar-backdrop').classList.add('hidden');
        });
        document.getElementById('sidebar-backdrop')?.addEventListener('click', () => {
            document.getElementById('sidebar').classList.add('-translate-x-full');
            document.getElementById('sidebar-backdrop').classList.add('hidden');
        });

        document.addEventListener('DOMContentLoaded', () => {
            refreshAll();
        });
    </script>
</body>
</html>
