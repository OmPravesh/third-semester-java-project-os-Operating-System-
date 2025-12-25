<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>iOS Style Calculator</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-color: #000000;
            --calc-bg: #000000;
            --display-text: #ffffff;
            --btn-num-bg: #333333;
            --btn-num-text: #ffffff;
            --btn-op-bg: #ff9f0a; /* Apple Orange */
            --btn-op-text: #ffffff;
            --btn-func-bg: #a5a5a5; /* Apple Light Gray */
            --btn-func-text: #000000;
            --btn-sci-bg: #212121; /* Darker for scientific/memory */
        }

        * { box-sizing: border-box; -webkit-tap-highlight-color: transparent; }

        body {
            margin: 0;
            padding: 0;
            background-color: #f2f2f2; /* Light background outside calculator */
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .wrap {
            width: 100%;
            max-width: 400px;
            padding: 20px;
        }

        /* Header / Back Button Styling */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding: 0 10px;
        }

        a.back {
            color: #007aff; /* Apple Blue */
            text-decoration: none;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        /* Calculator Body - iOS Look */
        .calc {
            background-color: var(--calc-bg);
            border-radius: 40px;
            padding: 20px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.4);
            border: 1px solid #333;
        }

        /* Screen */
        .screen {
            height: 120px;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            align-items: flex-end;
            margin-bottom: 15px;
            padding: 10px 20px;
            word-wrap: break-word;
            word-break: break-all;
        }

        .expr {
            color: #a5a5a5;
            font-size: 1.2rem;
            min-height: 24px;
        }

        .value {
            color: var(--display-text);
            font-size: 4rem;
            font-weight: 300;
            line-height: 1;
        }

        /* Memory Row */
        .mem-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            gap: 10px;
        }

        .mem-btn {
            background: transparent;
            color: #a5a5a5;
            border: 1px solid #333;
            border-radius: 20px;
            padding: 8px 0;
            flex: 1;
            font-size: 0.8rem;
            cursor: pointer;
            transition: all 0.2s;
        }
        .mem-btn:active { background: #333; color: white; }

        /* Keypad Grid */
        .keypad {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
        }

        /* Base Button Style (Circular) */
        .btn {
            aspect-ratio: 1;
            border-radius: 50%;
            border: none;
            font-size: 1.7rem;
            font-weight: 400;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: filter 0.2s;
            user-select: none;

            /* Default to Number Style */
            background-color: var(--btn-num-bg);
            color: var(--btn-num-text);
        }

        .btn:active { filter: brightness(1.3); }

        /* Operator Buttons (Orange) */
        .btn-op, .btn-eq {
            background-color: var(--btn-op-bg);
            color: var(--btn-op-text);
            font-size: 1.8rem;
        }

        /* Top Function Buttons (Light Gray) */
        /* Specific targeting for AC, Backspace, Percent */
        .btn[data-action="clear"],
        .btn[data-action="back"],
        .btn[data-action="percent"] {
            background-color: var(--btn-func-bg);
            color: var(--btn-func-text);
            font-weight: 500;
        }

        /* Scientific / Other Function Buttons (Dark Gray) */
        .btn-func {
            background-color: var(--btn-sci-bg);
            color: white;
            font-size: 1.2rem;
        }

        /* Wide Button (Copy) */
        .btn-wide {
            grid-column: span 4;
            aspect-ratio: auto;
            height: 50px;
            border-radius: 25px;
            font-size: 1rem;
            margin-top: 10px;
            background-color: #212121;
        }

        /* History Panel */
        .history {
            max-height: 0;
            overflow: hidden; /* Hidden by default to keep clean look */
        }
    </style>
</head>
<body>
    <div class="wrap">
        <div class="header">
            <a href="index.jsp" class="back"><i class="fas fa-arrow-left"></i> Back</a>
            <div style="font-weight:600; font-size: 0.9rem; letter-spacing: 1px; color: #888;">CALCULATOR</div>
        </div>

        <div class="calc" role="application" aria-label="Calculator">
            <div class="screen" id="screen">
                <div class="expr" id="expr"></div>
                <div class="value" id="value">0</div>
            </div>

            <div class="mem-row">
                <button class="mem-btn" data-action="mc">MC</button>
                <button class="mem-btn" data-action="mr">MR</button>
                <button class="mem-btn" data-action="mplus">M+</button>
                <button class="mem-btn" data-action="mminus">M-</button>
            </div>

            <div class="keypad">
                <button class="btn" data-action="clear">AC</button>
                <button class="btn" data-action="back"><i class="fas fa-backspace"></i></button>
                <button class="btn" data-action="percent"><i class="fas fa-percent" style="font-size: 0.9rem;"></i></button>
                <button class="btn btn-op" data-value="/"><i class="fas fa-divide"></i></button>

                <button class="btn" data-value="7">7</button>
                <button class="btn" data-value="8">8</button>
                <button class="btn" data-value="9">9</button>
                <button class="btn btn-op" data-value="*"><i class="fas fa-times"></i></button>

                <button class="btn" data-value="4">4</button>
                <button class="btn" data-value="5">5</button>
                <button class="btn" data-value="6">6</button>
                <button class="btn btn-op" data-value="-"><i class="fas fa-minus"></i></button>

                <button class="btn" data-value="1">1</button>
                <button class="btn" data-value="2">2</button>
                <button class="btn" data-value="3">3</button>
                <button class="btn btn-op" data-value="+"><i class="fas fa-plus"></i></button>

                <button class="btn" data-action="sign">&plusmn;</button>
                <button class="btn" data-value="0">0</button>
                <button class="btn" data-value=".">.</button>
                <button class="btn btn-eq" data-action="equals"><i class="fas fa-equals"></i></button>

                <button class="btn btn-func" style="font-size:1.1rem" data-action="sqrt">&radic;</button>
                <button class="btn btn-func" style="font-size:1rem" data-action="square">x<sup>2</sup></button>
                <button class="btn btn-func" style="font-size:1rem" data-action="recip">1/x</button>
                <button class="btn btn-func" style="font-size:1rem" data-action="recip" disabled></button> <button class="btn btn-func" data-value="(">(</button>
                <button class="btn btn-func" data-value=")">)</button>
                <button class="btn btn-wide" id="copy" style="grid-column: span 2; margin-top:0;">
                    <i class="far fa-copy" style="margin-right:8px"></i> Copy
                </button>
            </div>

            <div class="history" id="history" aria-label="History"></div>
        </div>
    </div>

    <script>
        // ... (Keep the existing JavaScript logic exactly as it was) ...
        /* Preference Loader (Preserved functionality) */
        (function applyPreferences(){
            try {
                const theme = localStorage.getItem('webos.theme') || 'dark';
                const accent = localStorage.getItem('webos.accent');
                const root = document.documentElement;

                // If user has a saved accent, override the default
                if(accent) root.style.setProperty('--accent-color', accent);

                // Light mode override logic
                const isDark = theme === 'dark' || (theme === 'system' && window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches);
                if (!isDark) {
                    // Apple Light Mode
                    root.style.setProperty('--calc-bg', '#f2f2f2');
                    root.style.setProperty('--display-text', '#000000');
                    root.style.setProperty('--btn-num-bg', '#ffffff');
                    root.style.setProperty('--btn-num-text', '#000000');
                    root.style.setProperty('--btn-func-bg', '#d4d4d2');
                    root.style.setProperty('--btn-func-text', '#000000');
                    root.style.setProperty('--btn-sci-bg', '#e5e5e5');
                }
            } catch (_) {}
        })();

        const valueEl = document.getElementById('value');
        const exprEl = document.getElementById('expr');
        const historyEl = document.getElementById('history');
        let expr = '';
        let memory = 0;

        function updateScreen() { exprEl.textContent = expr || ''; }
        function append(v) { expr += v; updateScreen(); }
        function back() { expr = expr.slice(0, -1); updateScreen(); }
        function clearAll() { expr = ''; valueEl.textContent = '0'; updateScreen(); }
        function percent() { if (!expr) return; const val = evaluate(expr); if (val == null) return; const p = val / 100; expr = String(p); valueEl.textContent = String(p); updateScreen(); }
        function sign() { if (!expr) return; const val = evaluate(expr); if (val == null) return; const s = -val; expr = String(s); valueEl.textContent = String(s); updateScreen(); }
        function sqrt() { const val = evaluate(expr || valueEl.textContent); if (val == null) return; if (val < 0) { error(); return; } const r = Math.sqrt(val); expr = String(r); valueEl.textContent = String(r); updateScreen(); }
        function square() { const val = evaluate(expr || valueEl.textContent); if (val == null) return; const r = val * val; expr = String(r); valueEl.textContent = String(r); updateScreen(); }
        function recip() { const val = evaluate(expr || valueEl.textContent); if (val == null) return; if (val === 0) { error(); return; } const r = 1 / val; expr = String(r); valueEl.textContent = String(r); updateScreen(); }
        function copyResult() { const t = valueEl.textContent; if (!t) return; navigator.clipboard?.writeText(t).then(() => { const btn = document.getElementById('copy'); const originalText = btn.innerHTML; btn.innerHTML = '<i class="fas fa-check"></i> Copied'; setTimeout(() => btn.innerHTML = originalText, 1500); }); }
        function error() { valueEl.textContent = 'Error'; setTimeout(() => valueEl.textContent = '0', 1000); }
        function equals() { const val = evaluate(expr); if (val == null) { error(); return; } let displayVal = val; if (!Number.isInteger(val)) { displayVal = parseFloat(val.toFixed(8)); } addHistory(expr, displayVal); expr = String(displayVal); valueEl.textContent = String(displayVal); updateScreen(); }
        function addHistory(e, v) { const div = document.createElement('div'); div.className = 'history-item'; div.innerHTML = `<span>${e}</span><strong>${v}</strong>`; div.addEventListener('click', () => { expr = String(v); valueEl.textContent = String(v); updateScreen(); }); historyEl.prepend(div); while (historyEl.children.length > 5) historyEl.removeChild(historyEl.lastChild); }
        function mc(){ memory = 0; }
        function mr(){ expr = String(memory); valueEl.textContent = String(memory); updateScreen(); }
        function mplus(){ const val = evaluate(expr || valueEl.textContent); if (val != null) memory += val; }
        function mminus(){ const val = evaluate(expr || valueEl.textContent); if (val != null) memory -= val; }
        function evaluate(input) { try { if (!input) return 0; const tokens = tokenize(input); const rpn = toRPN(tokens); return evalRPN(rpn); } catch (_) { return null; } }
        function tokenize(s) { const out = []; let num = ''; for (let i = 0; i < s.length; i++) { const c = s[i]; if ('0123456789.'.includes(c)) { num += c; } else if ('+-*/()'.includes(c)) { if (num) { out.push(parseFloat(num)); num = ''; } out.push(c); } else if (c === ' ') { continue; } } if (num) out.push(parseFloat(num)); return out; }
        function toRPN(tokens) { const prec = {'+':1,'-':1,'*':2,'/':2}; const ops = []; const out = []; for (const t of tokens) { if (typeof t === 'number') { out.push(t); } else if (t === '(') { ops.push(t); } else if (t === ')') { while (ops.length && ops[ops.length-1] !== '(') out.push(ops.pop()); ops.pop(); } else { while (ops.length && prec[ops[ops.length-1]] >= prec[t]) out.push(ops.pop()); ops.push(t); } } while (ops.length) out.push(ops.pop()); return out; }
        function evalRPN(rpn) { const st = []; for (const t of rpn) { if (typeof t === 'number') st.push(t); else { const b = st.pop(), a = st.pop(); let r = 0; switch (t) { case '+': r = a + b; break; case '-': r = a - b; break; case '*': r = a * b; break; case '/': r = b === 0 ? (()=>{ throw new Error('div0'); })() : a / b; break; default: throw new Error('op'); } st.push(r); } } if (st.length !== 1) throw new Error('stack'); return st[0]; }

        document.addEventListener('click', (e) => { const b = e.target.closest('button'); if (!b) return; const val = b.getAttribute('data-value'); const action = b.getAttribute('data-action'); if (val) append(val); else if (action) { switch(action){ case 'clear': clearAll(); break; case 'back': back(); break; case 'percent': percent(); break; case 'sign': sign(); break; case 'equals': equals(); break; case 'sqrt': sqrt(); break; case 'square': square(); break; case 'recip': recip(); break; case 'mc': mc(); break; case 'mr': mr(); break; case 'mplus': mplus(); break; case 'mminus': mminus(); break; } } else if (b.id === 'copy') { copyResult(); } });
        document.addEventListener('keydown', (e) => { const k = e.key; if ((k >= '0' && k <= '9') || k === '.' || k === '(' || k === ')') append(k); else if (k === '+' || k === '-' || k === '*' || k === '/') append(k); else if (k === 'Enter' || k === '=') { e.preventDefault(); equals(); } else if (k === 'Backspace') { e.preventDefault(); back(); } else if (k === 'Escape') { clearAll(); } else if (k === '%') { percent(); } });
        updateScreen();
    </script>
</body>
</html>