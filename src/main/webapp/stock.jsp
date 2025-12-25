<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>ProTrader | Market Intelligence</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            /* Theme Colors */
            --bg-body: #0b0e11;
            --bg-sidebar: #15191e;
            --bg-card: #1e2329;
            --border: #2b3139;
            --text-primary: #eaecef;
            --text-secondary: #848e9c;

            /* Finance Colors */
            --up: #0ecb81;
            --up-bg: rgba(14, 203, 129, 0.15);
            --down: #f6465d;
            --down-bg: rgba(246, 70, 93, 0.15);
            --accent: #fcd535;
        }

        * { box-sizing: border-box; outline: none; }

        body {
            margin: 0;
            padding: 0;
            background-color: var(--bg-body);
            color: var(--text-primary);
            font-family: 'Inter', sans-serif;
            height: 100vh;
            display: flex;
            overflow: hidden;
        }

        /* --- SIDEBAR --- */
        .sidebar {
            width: 280px;
            background-color: var(--bg-sidebar);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            z-index: 100;
        }

        .logo-area {
            height: 60px;
            display: flex;
            align-items: center;
            padding: 0 20px;
            border-bottom: 1px solid var(--border);
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--text-primary);
            letter-spacing: -0.5px;
        }
        .logo-area i { color: var(--accent); margin-right: 10px; }

        .search-box {
            padding: 15px;
            border-bottom: 1px solid var(--border);
        }
        .search-input {
            width: 100%;
            background: var(--bg-body);
            border: 1px solid var(--border);
            padding: 10px 12px;
            border-radius: 6px;
            color: var(--text-primary);
            font-size: 0.9rem;
        }
        .search-input::placeholder { color: var(--text-secondary); }

        .stock-list {
            flex: 1;
            overflow-y: auto;
            padding: 5px 0;
        }

        .stock-card {
            padding: 12px 20px;
            cursor: pointer;
            border-left: 3px solid transparent;
            transition: all 0.2s;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .stock-card:hover { background-color: rgba(255,255,255,0.03); }
        .stock-card.active {
            background-color: rgba(255,255,255,0.05);
            border-left-color: var(--accent);
        }

        .s-info h4 { margin: 0; font-size: 0.95rem; font-weight: 600; }
        .s-info p { margin: 4px 0 0 0; font-size: 0.75rem; color: var(--text-secondary); }

        .s-price { text-align: right; }
        .s-val { display: block; font-size: 0.9rem; font-weight: 500; font-family: 'Roboto Mono', monospace; }
        .s-chg { font-size: 0.75rem; font-weight: 500; }

        .text-up { color: var(--up); }
        .text-down { color: var(--down); }

        /* --- MAIN CONTENT --- */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }

        /* Top Header */
        header {
            height: 60px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 30px;
            background: var(--bg-sidebar);
        }
        .breadcrumbs { font-size: 0.9rem; color: var(--text-secondary); }
        .breadcrumbs span { color: var(--text-primary); font-weight: 500; }

        .actions { display: flex; gap: 10px; }
        .btn {
            background: var(--bg-card);
            border: 1px solid var(--border);
            color: var(--text-secondary);
            padding: 6px 14px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.85rem;
            transition: 0.2s;
        }
        .btn:hover { color: var(--text-primary); border-color: var(--text-secondary); }
        .btn-primary { background: var(--accent); color: #000; border: none; font-weight: 600; }
        .btn-primary:hover { opacity: 0.9; border: none; }

        /* Dashboard Grid */
        .dashboard {
            padding: 30px;
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
        }

        .stock-header {
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
        }

        .main-symbol { font-size: 2rem; font-weight: 700; margin: 0; display: flex; align-items: center; gap: 15px; }
        .badge { font-size: 0.8rem; background: var(--bg-card); padding: 4px 8px; border-radius: 4px; color: var(--text-secondary); font-weight: 400; border: 1px solid var(--border); }
        .company-name { color: var(--text-secondary); font-size: 1rem; margin-top: 5px; }

        .price-hero { text-align: right; }
        .big-price { font-size: 2.2rem; font-weight: 700; letter-spacing: -1px; }
        .price-pill {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 12px; border-radius: 20px;
            font-size: 0.9rem; font-weight: 600; margin-top: 5px;
        }
        .bg-up { background: var(--up-bg); color: var(--up); }
        .bg-down { background: var(--down-bg); color: var(--down); }

        /* Chart Card */
        .card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 20px;
        }
        .card-body { padding: 20px; }
        .chart-container { position: relative; height: 400px; width: 100%; }

        /* Fundamentals Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .stat-item {
            background: var(--bg-card);
            border: 1px solid var(--border);
            padding: 20px;
            border-radius: 8px;
        }
        .stat-label { font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 8px; }
        .stat-val { font-size: 1.1rem; font-weight: 600; }

        /* Scrollbar */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: var(--bg-body); }
        ::-webkit-scrollbar-thumb { background: #333; border-radius: 3px; }
        ::-webkit-scrollbar-thumb:hover { background: #444; }

    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="logo-area">
            <i class="fas fa-chart-line"></i> FinTrader Pro
        </div>
        <div class="search-box">
            <input type="text" class="search-input" placeholder="Search stocks, ETFs..." />
        </div>
        <div class="stock-list" id="watchlist">
            </div>
    </aside>

    <main class="main-content">
        <header>
            <div class="breadcrumbs">Markets > Stocks > <span id="bread-sym">AAPL</span></div>
            <div class="actions">
                <button class="btn" id="btn-pause"><i class="fas fa-pause"></i> Pause</button>
                <button class="btn" id="btn-reset"><i class="fas fa-sync"></i> Reset</button>
                <button class="btn btn-primary">Buy Stock</button>
            </div>
        </header>

        <div class="dashboard">
            <div class="stock-header">
                <div>
                    <h1 class="main-symbol">
                        <span id="disp-sym">AAPL</span>
                        <span class="badge">NASDAQ</span>
                    </h1>
                    <div class="company-name" id="disp-name">Apple Inc.</div>
                </div>
                <div class="price-hero">
                    <div class="big-price" id="disp-price">0.00</div>
                    <div id="disp-badge" class="price-pill bg-up">
                        <i class="fas fa-arrow-up" id="disp-icon"></i>
                        <span id="disp-pct">0.00%</span>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="mainChart"></canvas>
                    </div>
                </div>
            </div>

            <h3 style="margin-bottom:15px; font-weight:500; color:var(--text-secondary);">Key Fundamentals</h3>
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-label">Market Cap</div>
                    <div class="stat-val" id="stat-mcap">-</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">P/E Ratio</div>
                    <div class="stat-val" id="stat-pe">-</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">52W High</div>
                    <div class="stat-val" id="stat-high">-</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">52W Low</div>
                    <div class="stat-val" id="stat-low">-</div>
                </div>
            </div>
        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            // --- 1. CONFIGURATION & DATA ---
            const stocks = [
                { sym: 'AAPL', name: 'Apple Inc.', price: 175.00, pe: 29.5, mcap: '2.8T', high: 198.23, low: 124.17 },
                { sym: 'MSFT', name: 'Microsoft Corp.', price: 330.50, pe: 34.2, mcap: '2.5T', high: 366.78, low: 213.43 },
                { sym: 'GOOGL', name: 'Alphabet Inc.', price: 139.00, pe: 24.8, mcap: '1.7T', high: 151.00, low: 88.00 },
                { sym: 'AMZN', name: 'Amazon.com', price: 129.00, pe: 105.1, mcap: '1.3T', high: 145.86, low: 81.43 },
                { sym: 'NVDA', name: 'NVIDIA Corp.', price: 460.00, pe: 110.5, mcap: '1.1T', high: 502.66, low: 108.13 },
                { sym: 'TSLA', name: 'Tesla Inc.', price: 240.00, pe: 70.4, mcap: '780B', high: 313.80, low: 101.81 },
                { sym: 'META', name: 'Meta Platforms', price: 305.00, pe: 35.1, mcap: '800B', high: 326.20, low: 88.09 },
                { sym: 'NFLX', name: 'Netflix Inc.', price: 410.00, pe: 42.0, mcap: '180B', high: 485.00, low: 280.00 }
            ];

            // Simulation State
            let activeSym = stocks[0].sym;
            let isPaused = false;
            const history = {};
            const maxPoints = 50;

            // Initialize History for all stocks
            stocks.forEach(s => {
                s.startPrice = s.price;
                s.currentPrice = s.price;
                history[s.sym] = Array(maxPoints).fill(s.price);
            });

            // --- 2. CHART SETUP ---
            const ctx = document.getElementById('mainChart').getContext('2d');

            // Gradient Setup
            const gradientUp = ctx.createLinearGradient(0, 0, 0, 400);
            gradientUp.addColorStop(0, 'rgba(14, 203, 129, 0.4)');
            gradientUp.addColorStop(1, 'rgba(14, 203, 129, 0)');

            const gradientDown = ctx.createLinearGradient(0, 0, 0, 400);
            gradientDown.addColorStop(0, 'rgba(246, 70, 93, 0.4)');
            gradientDown.addColorStop(1, 'rgba(246, 70, 93, 0)');

            // Chart Instance
            const chart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: Array(maxPoints).fill(''),
                    datasets: [{
                        data: history[activeSym],
                        borderColor: '#0ecb81',
                        backgroundColor: gradientUp,
                        borderWidth: 2,
                        pointRadius: 0,
                        pointHoverRadius: 6,
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    // Key change for natural movement: Enable animation
                    animation: {
                        duration: 1000, // 1 second glide
                        easing: 'linear'
                    },
                    interaction: { mode: 'index', intersect: false },
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            mode: 'index',
                            intersect: false,
                            backgroundColor: '#1e2329',
                            titleColor: '#848e9c',
                            bodyColor: '#eaecef',
                            borderColor: '#2b3139',
                            borderWidth: 1,
                            callbacks: {
                                label: function(context) {
                                    return '$' + context.parsed.y.toFixed(2);
                                }
                            }
                        }
                    },
                    scales: {
                        x: { display: false },
                        y: {
                            position: 'right',
                            grid: { color: '#2b3139', drawBorder: false },
                            ticks: { color: '#848e9c' }
                        }
                    }
                }
            });

            // --- 3. HELPER FUNCTIONS ---
            function getStock(sym) { return stocks.find(s => s.sym === sym); }

            function formatPrice(num) { return num.toFixed(2); }

            function gaussianRandom() {
                let u = 0, v = 0;
                while(u === 0) u = Math.random();
                while(v === 0) v = Math.random();
                return Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
            }

            // --- 4. RENDER FUNCTIONS ---

            function renderSidebar() {
                const list = document.getElementById('watchlist');
                list.innerHTML = '';

                stocks.forEach(s => {
                    const diff = s.currentPrice - s.startPrice;
                    const isUp = diff >= 0;

                    const el = document.createElement('div');
                    // JSP Escape Fix: Backslashes added
                    el.className = `stock-card \${s.sym === activeSym ? 'active' : ''}`;
                    el.onclick = () => changeStock(s.sym);
                    el.innerHTML = `
                        <div class="s-info">
                            <h4>\${s.sym}</h4>
                            <p>\${s.name}</p>
                        </div>
                        <div class="s-price">
                            <span class="s-val">$\${formatPrice(s.currentPrice)}</span>
                            <span class="s-chg \${isUp ? 'text-up' : 'text-down'}">
                                \${isUp ? '+' : ''}\${((diff/s.startPrice)*100).toFixed(2)}%
                            </span>
                        </div>
                    `;
                    list.appendChild(el);
                });
            }

            function updateMainView() {
                const s = getStock(activeSym);

                // Text Updates
                document.getElementById('bread-sym').innerText = s.sym;
                document.getElementById('disp-sym').innerText = s.sym;
                document.getElementById('disp-name').innerText = s.name;

                // Stats Updates
                document.getElementById('stat-mcap').innerText = s.mcap;
                document.getElementById('stat-pe').innerText = s.pe;
                document.getElementById('stat-high').innerText = '$' + s.high;
                document.getElementById('stat-low').innerText = '$' + s.low;

                // Price Math
                const diff = s.currentPrice - s.startPrice;
                const pct = (diff / s.startPrice) * 100;
                const isUp = diff >= 0;

                // Price Colors
                const priceEl = document.getElementById('disp-price');
                priceEl.innerText = '$' + formatPrice(s.currentPrice);
                priceEl.style.color = isUp ? 'var(--up)' : 'var(--down)';

                const badge = document.getElementById('disp-badge');
                // JSP Escape Fix: Backslashes added
                badge.className = `price-pill \${isUp ? 'bg-up' : 'bg-down'}`;

                document.getElementById('disp-icon').className = isUp ? 'fas fa-arrow-up' : 'fas fa-arrow-down';
                document.getElementById('disp-pct').innerText = Math.abs(pct).toFixed(2) + '%';

                // Chart Update
                const data = history[activeSym];
                const color = isUp ? '#0ecb81' : '#f6465d';
                const bg = isUp ? gradientUp : gradientDown;

                chart.data.datasets[0].data = data;
                chart.data.datasets[0].borderColor = color;
                chart.data.datasets[0].backgroundColor = bg;

                // Scaling
                const min = Math.min(...data);
                const max = Math.max(...data);
                const pad = (max - min) * 0.1;
                chart.options.scales.y.min = min - pad;
                chart.options.scales.y.max = max + pad;

                chart.update(); // Allowed animation
            }

            function changeStock(sym) {
                activeSym = sym;
                renderSidebar(); // Update active highlights
                updateMainView();
            }

            // --- 5. SIMULATION LOOP (SLOWED DOWN) ---
            function runSimulation() {
                if(!isPaused) {
                    stocks.forEach(s => {
                        // Volatility adjusted for slower ticks
                        const vol = (s.sym === activeSym) ? 0.003 : 0.001;
                        const change = s.currentPrice * vol * gaussianRandom();
                        s.currentPrice += change;

                        if(s.currentPrice < 1) s.currentPrice = 1;

                        const h = history[s.sym];
                        h.push(s.currentPrice);
                        h.shift();
                    });

                    renderSidebar();
                    updateMainView();
                }
            }

            // Change: Use setInterval instead of RequestAnimationFrame for natural 1.5s tick
            setInterval(runSimulation, 1500); // 1500ms = 1.5 Seconds

            // --- 6. CONTROLS ---
            document.getElementById('btn-pause').onclick = function() {
                isPaused = !isPaused;
                this.innerHTML = isPaused ? '<i class="fas fa-play"></i> Resume' : '<i class="fas fa-pause"></i> Pause';
            };

            document.getElementById('btn-reset').onclick = function() {
                stocks.forEach(s => {
                    s.currentPrice = s.startPrice;
                    history[s.sym] = Array(maxPoints).fill(s.startPrice);
                });
                updateMainView();
            };

            // Start
            renderSidebar();
            updateMainView();
            // Loop is handled by setInterval now
        });
    </script>
</body>
</html>