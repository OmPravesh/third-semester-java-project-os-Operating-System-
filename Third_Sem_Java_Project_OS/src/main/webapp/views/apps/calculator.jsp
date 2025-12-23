<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Calculator</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .calc-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; max-width: 300px; margin: 0 auto; }
        .calc-btn { padding: 20px; font-size: 1.2rem; background: #f0f0f0; border: none; border-radius: 4px; cursor: pointer; }
        .calc-btn:hover { background: #e0e0e0; }
        .span-2 { grid-column: span 2; }
        .output { grid-column: 1 / -1; background: #202124; color: white; padding: 20px; text-align: right; font-size: 2rem; border-radius: 4px; margin-bottom: 10px; }
        .op { background-color: var(--google-blue); color: white; }
    </style>
</head>
<body>
    <jsp:include page="/views/common/navbar.jsp" />
    <div class="container text-center">
        <div class="card" style="display:inline-block;">
            <h3>Calculator</h3>
            <div class="calc-grid">
                <div class="output" id="display">0</div>
                <button class="calc-btn span-2" onclick="clearDisplay()">AC</button>
                <button class="calc-btn" onclick="del()">DEL</button>
                <button class="calc-btn op" onclick="append('/')">/</button>
                <button class="calc-btn" onclick="append('7')">7</button>
                <button class="calc-btn" onclick="append('8')">8</button>
                <button class="calc-btn" onclick="append('9')">9</button>
                <button class="calc-btn op" onclick="append('*')">*</button>
                <button class="calc-btn" onclick="append('4')">4</button>
                <button class="calc-btn" onclick="append('5')">5</button>
                <button class="calc-btn" onclick="append('6')">6</button>
                <button class="calc-btn op" onclick="append('-')">-</button>
                <button class="calc-btn" onclick="append('1')">1</button>
                <button class="calc-btn" onclick="append('2')">2</button>
                <button class="calc-btn" onclick="append('3')">3</button>
                <button class="calc-btn op" onclick="append('+')">+</button>
                <button class="calc-btn span-2" onclick="append('0')">0</button>
                <button class="calc-btn" onclick="append('.')">.</button>
                <button class="calc-btn op" onclick="calculate()">=</button>
            </div>
        </div>
    </div>
<script>
    let display = document.getElementById('display');
    function append(val) { 
        if(display.innerText === '0') display.innerText = '';
        display.innerText += val; 
    }
    function clearDisplay() { display.innerText = '0'; }
    function del() { display.innerText = display.innerText.slice(0, -1) || '0'; }
    function calculate() { try { display.innerText = eval(display.innerText); } catch { display.innerText = 'Error'; } }
</script>
</body>
</html>