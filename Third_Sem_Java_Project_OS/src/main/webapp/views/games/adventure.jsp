<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Adventure Quest</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .story-text { font-size: 1.2rem; line-height: 1.6; min-height: 150px; }
        .choices { display: grid; gap: 10px; }
        .stats { display: flex; gap: 20px; font-weight: bold; margin-bottom: 20px; color: var(--text-secondary); }
    </style>
</head>
<body>
    <jsp:include page="/views/common/navbar.jsp" />
    
    <div class="container">
        <div class="card" style="max-width: 700px; margin: 0 auto;">
            <div class="card-header border-bottom">
                <h3>Adventure Quest: The Cursed Castle</h3>
            </div>
            
            <div class="stats">
                <span style="color:var(--google-red)">❤️ Health: <span id="health">100</span></span>
                <span style="color:var(--google-yellow)">💰 Gold: <span id="gold">10</span></span>
            </div>
            
            <div class="story-text" id="story">
                Loading story...
            </div>
            
            <div class="choices" id="choices">
                </div>
        </div>
    </div>

<script>
    let state = { health: 100, gold: 10, hasSword: false, hasKey: false };

    const scenes = {
        start: {
            text: "You stand at a crossroads. A path leads to a dense <b>Forest</b>, another to a bustling <b>Village</b>.",
            choices: [
                { text: "Enter the Forest 🌲", next: "forest" },
                { text: "Go to the Village 🏘️", next: "village" }
            ]
        },
        forest: {
            text: "The forest is dark. You find a rusty key in the mud!",
            action: () => state.hasKey = true,
            choices: [
                { text: "Go deeper", next: "deepForest" },
                { text: "Return", next: "start" }
            ]
        },
        village: {
            text: "The village is lively. A blacksmith is selling swords for 10 gold.",
            choices: [
                { text: "Buy Sword (10g)", next: "buySword", condition: () => state.gold >= 10 },
                { text: "Go to Castle", next: "castle" }
            ]
        },
        buySword: {
            text: "You bought a steel sword! You feel stronger.",
            action: () => { state.gold -= 10; state.hasSword = true; },
            choices: [{ text: "Back", next: "village" }]
        },
        castle: {
            text: "The castle gate is locked.",
            choices: [
                { text: "Use Key", next: "win", condition: () => state.hasKey },
                { text: "Return", next: "village" }
            ]
        },
        win: {
            text: "<span style='color:green'>You unlocked the gate and found the treasure! YOU WIN!</span>",
            choices: [{ text: "Play Again", next: "start", action: () => reset() }]
        },
        deepForest: {
            text: "A wolf attacks you! You take damage and flee.",
            action: () => state.health -= 30,
            choices: [{ text: "Run to village", next: "village" }]
        }
    };

    function showScene(sceneId) {
        const scene = scenes[sceneId];
        if(scene.action) scene.action();
        
        document.getElementById('health').innerText = state.health;
        document.getElementById('gold').innerText = state.gold;
        document.getElementById('story').innerHTML = scene.text;
        
        const btnContainer = document.getElementById('choices');
        btnContainer.innerHTML = '';
        
        scene.choices.forEach(choice => {
            if(choice.condition && !choice.condition()) return;
            
            const btn = document.createElement('button');
            btn.className = 'btn btn-primary';
            btn.innerText = choice.text;
            btn.onclick = () => showScene(choice.next);
            btnContainer.appendChild(btn);
        });
    }

    function reset() { state = { health: 100, gold: 10, hasSword: false, hasKey: false }; }
    
    showScene('start');
</script>
</body>
</html>