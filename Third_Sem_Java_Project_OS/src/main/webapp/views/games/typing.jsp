<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Typing Speed Test</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .typing-area { font-size: 1.5rem; letter-spacing: 1px; margin-bottom: 20px; color: var(--text-secondary); }
        .highlight { color: var(--google-blue); background: #e8f0fe; }
        .error { color: var(--google-red); text-decoration: underline; }
    </style>
</head>
<body>
    <jsp:include page="/views/common/navbar.jsp" />
    
    <div class="container text-center">
        <div class="card" style="max-width: 800px; margin: 0 auto;">
            <h2>Typing Speed Test</h2>
            <div class="row" style="display: flex; justify-content: space-around; margin: 20px 0;">
                <div>Time: <span id="timer">60</span>s</div>
                <div>WPM: <span id="wpm">0</span></div>
                <div>Accuracy: <span id="accuracy">100</span>%</div>
            </div>
            
            <div class="typing-area" id="text-display">
                Click start to begin typing...
            </div>
            
            <textarea id="input-field" class="form-control" rows="3" disabled 
                      style="width: 100%; padding: 10px; font-size: 1.2rem;"></textarea>
            
            <button class="btn btn-primary mt-2" onclick="startGame()">Start Test</button>
        </div>
    </div>

<script>
    const textDisplay = document.getElementById('text-display');
    const inputField = document.getElementById('input-field');
    const quotes = [
        "The quick brown fox jumps over the lazy dog.",
        "To be or not to be, that is the question.",
        "Java is a high-level, class-based, object-oriented programming language."
    ];
    let timeLeft = 60;
    let timer = null;
    let charIndex = 0;

    function startGame() {
        const quote = quotes[Math.floor(Math.random() * quotes.length)];
        textDisplay.innerHTML = '';
        quote.split('').forEach(char => {
            let span = document.createElement('span');
            span.innerText = char;
            textDisplay.appendChild(span);
        });
        
        inputField.value = '';
        inputField.disabled = false;
        inputField.focus();
        timeLeft = 60;
        charIndex = 0;
        
        clearInterval(timer);
        timer = setInterval(updateTimer, 1000);
    }

    inputField.addEventListener('input', () => {
        const arrayQuote = textDisplay.querySelectorAll('span');
        const arrayValue = inputField.value.split('');
        
        let correct = true;
        arrayQuote.forEach((charSpan, index) => {
            const char = arrayValue[index];
            if (char == null) {
                charSpan.classList.remove('highlight');
                charSpan.classList.remove('error');
                correct = false;
            } else if (char === charSpan.innerText) {
                charSpan.classList.add('highlight');
                charSpan.classList.remove('error');
            } else {
                charSpan.classList.add('error');
                charSpan.classList.remove('highlight');
                correct = false;
            }
        });
    });

    function updateTimer() {
        if (timeLeft > 0) {
            timeLeft--;
            document.getElementById('timer').innerText = timeLeft;
        } else {
            clearInterval(timer);
            inputField.disabled = true;
            alert("Time's up!");
        }
    }
</script>
</body>
</html>