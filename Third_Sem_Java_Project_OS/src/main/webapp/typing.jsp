<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("name");
    if (username == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Hyper Type | WebOS</title>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&family=Fira+Code:wght@400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --glass-border: rgba(255, 255, 255, 0.1);
            --neon-blue: #667eea;
            --neon-green: #00ff88;
            --neon-red: #ff4444;
        }
        body {
            margin: 0; padding: 0;
            font-family: 'Inter', sans-serif;
            height: 100vh;
            background: radial-gradient(circle at 50% 10%, #1e1e2f 0%, #0f172a 100%);
            color: white;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            user-select: none;
        }

        .header {
            padding: 20px 40px;
            display: flex; align-items: center; gap: 15px;
            background: rgba(0,0,0,0.3);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--glass-border);
        }
        .back-btn {
            color: rgba(255,255,255,0.7); text-decoration: none;
            font-weight: 600; display: flex; align-items: center; gap: 8px; transition: 0.2s;
        }
        .back-btn:hover { color: #fff; transform: translateX(-3px); }

        .game-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 20px;
        }

        .wrapper {
            width: 800px;
            max-width: 90%;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 35px;
            backdrop-filter: blur(15px);
            box-shadow: 0 20px 50px rgba(0,0,0,0.5);
        }

        .stats-bar {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .stat-item { text-align: center; }
        .stat-label { font-size: 0.8rem; color: rgba(255,255,255,0.5); text-transform: uppercase; letter-spacing: 1px; }
        .stat-value { font-size: 1.5rem; font-weight: 800; color: white; }

        .typing-text {
            font-family: 'Fira Code', monospace;
            font-size: 1.3rem;
            line-height: 1.8;
            color: rgba(255,255,255,0.4);
            max-height: 250px;
            overflow-y: auto;
            margin-bottom: 30px;
            outline: none;
        }

        .typing-text span { position: relative; transition: color 0.1s; }

        .typing-text span.active::before {
            content: "";
            position: absolute;
            left: 0; bottom: 0;
            height: 2px; width: 100%;
            background: var(--neon-blue);
            animation: blink 1s infinite;
        }

        @keyframes blink { 50% { opacity: 0; } }

        .typing-text span.correct { color: var(--neon-green); }
        .typing-text span.incorrect { color: var(--neon-red); background: rgba(255, 68, 68, 0.1); border-radius: 2px; }

        .input-field {
            position: absolute; z-index: -999; opacity: 0;
        }

        .action-btn {
            background: var(--neon-blue);
            color: white; border: none;
            padding: 12px 30px;
            font-size: 1rem; font-weight: 700;
            border-radius: 8px; cursor: pointer;
            transition: all 0.3s;
            display: block; margin: 0 auto;
        }
        .action-btn:hover { background: #556cd6; transform: scale(1.05); }

    </style>
</head>
<body>
    <div class="header">
        <a href="game.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Back to Arcade</a>
        <span style="margin-left:auto; opacity:0.5; font-size:0.9rem;">Player: <%= username %></span>
    </div>

    <div class="game-container">
        <div class="wrapper">
            <div class="stats-bar">
                <div class="stat-item">
                    <div class="stat-label">Time Left</div>
                    <div class="stat-value"><span id="time">60</span>s</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">Mistakes</div>
                    <div class="stat-value" id="mistake">0</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">WPM</div>
                    <div class="stat-value" id="wpm">0</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">CPM</div>
                    <div class="stat-value" id="cpm">0</div>
                </div>
            </div>

            <div class="typing-text">
                <p id="paragraph"></p>
            </div>

            <input type="text" class="input-field">

            <button class="action-btn">Try Again</button>
        </div>
    </div>

    <script>
        const typingText = document.querySelector(".typing-text p");
        const inpField = document.querySelector(".wrapper .input-field");
        const tryAgainBtn = document.querySelector(".action-btn");
        const timeTag = document.querySelector("#time");
        const mistakeTag = document.querySelector("#mistake");
        const wpmTag = document.querySelector("#wpm");
        const cpmTag = document.querySelector("#cpm");

        let timer,
        maxTime = 60,
        timeLeft = maxTime,
        charIndex = 0,
        mistakes = 0,
        isTyping = 0;

        const paragraphs = [
            "Java is a high-level, class-based, object-oriented programming language that is designed to have as few implementation dependencies as possible.",
            "The concept of a layout manager is to allow you to write code that positions components in a container without having to calculate the exact pixel coordinates.",
            "In computer science, a data structure is a data organization, management, and storage format that enables efficient access and modification.",
            "Technology is best when it brings people together. It allows us to connect in ways that were previously impossible.",
            "Success is not final, failure is not fatal: It is the courage to continue that counts in the long run. Do not give up.",
            "Debugging is twice as hard as writing the code in the first place. Therefore, if you write the code as cleverly as possible, you are, by definition, not smart enough to debug it."
        ];

        function loadParagraph() {
            const ranIndex = Math.floor(Math.random() * paragraphs.length);
            typingText.innerHTML = "";
            paragraphs[ranIndex].split("").forEach(char => {
                let span = `<span>\${char}</span>`;
                typingText.innerHTML += span;
            });
            typingText.querySelectorAll("span")[0].classList.add("active");
            document.addEventListener("keydown", () => inpField.focus());
            typingText.addEventListener("click", () => inpField.focus());
        }

        function initTyping() {
            let characters = typingText.querySelectorAll("span");
            let typedChar = inpField.value.split("")[charIndex];

            if(charIndex < characters.length - 1 && timeLeft > 0) {
                if(!isTyping) {
                    timer = setInterval(initTimer, 1000);
                    isTyping = true;
                }

                if(typedChar == null) {
                    if(charIndex > 0) {
                        charIndex--;
                        if(characters[charIndex].classList.contains("incorrect")) {
                            mistakes--;
                        }
                        characters[charIndex].classList.remove("correct", "incorrect");
                    }
                } else {
                    if(characters[charIndex].innerText === typedChar) {
                        characters[charIndex].classList.add("correct");
                    } else {
                        mistakes++;
                        characters[charIndex].classList.add("incorrect");
                    }
                    charIndex++;
                }

                characters.forEach(span => span.classList.remove("active"));
                if(characters[charIndex]) characters[charIndex].classList.add("active");

                let wpm = Math.round(((charIndex - mistakes)  / 5) / (maxTime - timeLeft) * 60);
                wpm = wpm < 0 || !wpm || wpm === Infinity ? 0 : wpm;

                wpmTag.innerText = wpm;
                mistakeTag.innerText = mistakes;
                cpmTag.innerText = charIndex - mistakes;
            } else {
                clearInterval(timer);
                inpField.value = "";
            }
        }

        function initTimer() {
            if(timeLeft > 0) {
                timeLeft--;
                timeTag.innerText = timeLeft;
                let wpm = Math.round(((charIndex - mistakes)  / 5) / (maxTime - timeLeft) * 60);
                wpmTag.innerText = wpm;
            } else {
                clearInterval(timer);
                inpField.value = "";
                wpmTag.innerText = 0;
            }
        }

        function resetGame() {
            loadParagraph();
            clearInterval(timer);
            timeLeft = maxTime;
            charIndex = mistakes = isTyping = 0;
            inpField.value = "";
            timeTag.innerText = timeLeft;
            wpmTag.innerText = 0;
            mistakeTag.innerText = 0;
            cpmTag.innerText = 0;
        }

        loadParagraph();
        inpField.addEventListener("input", initTyping);
        tryAgainBtn.addEventListener("click", resetGame);
    </script>
</body>
</html>