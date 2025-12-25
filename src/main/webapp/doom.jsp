<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("name") == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>WebOS Doom: Haunted House</title>
    <style>
        body { margin: 0; overflow: hidden; background: #111; font-family: 'Courier New', monospace; user-select: none; }

        /* UI Overlay */
        #ui-layer {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            pointer-events: none;
            display: flex; flex-direction: column; justify-content: space-between;
            z-index: 10;
        }

        /* Top Bar */
        .top-bar {
            pointer-events: auto;
            display: flex; align-items: center; padding: 20px;
            background: linear-gradient(to bottom, rgba(0,0,0,0.8), transparent);
        }
        .back-btn {
            color: #fff; text-decoration: none; font-size: 1.2rem;
            display: flex; align-items: center; gap: 8px; font-weight: bold; cursor: pointer;
            text-transform: uppercase; letter-spacing: 2px; text-shadow: 0 0 5px #ff0000;
        }
        .back-btn:hover { color: #ff0000; }

        /* HUD */
        #hud-top {
            display: flex; justify-content: flex-end; padding: 0 20px; flex: 1;
            font-size: 1.8rem; color: #fff; font-weight: bold;
        }
        .stat-box { display: flex; gap: 15px; align-items: center; margin-left: 30px; }

        .health-container {
            position: relative; width: 300px; height: 30px; background: #330000; border: 2px solid #fff;
        }
        .health-fill { width: 100%; height: 100%; background: #ff0000; transition: width 0.2s; }
        .health-text {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem; text-shadow: 1px 1px 2px black; color: white;
        }

        #crosshair {
            position: absolute; top: 50%; left: 50%;
            width: 6px; height: 6px; background: #00ff00;
            box-shadow: 0 0 8px #00ff00;
            transform: translate(-50%, -50%);
            pointer-events: none;
            border-radius: 50%;
            border: 1px solid white;
        }

        #weapon-info {
            position: absolute; bottom: 30px; right: 30px;
            text-align: right; color: #ffcc00; text-shadow: 0 0 5px #ffcc00;
        }
        .weapon-name { font-size: 2.5rem; font-weight: 800; text-transform: uppercase; letter-spacing: 3px; }
        .ammo-count { font-size: 1.5rem; color: #aaa; margin-top: 5px; }

        .overlay-screen {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.85);
            display: flex; flex-direction: column; justify-content: center; align-items: center;
            pointer-events: auto; z-index: 100;
        }
        h1 { font-size: 5rem; margin: 0; color: #cc0000; font-family: 'Impact', sans-serif; letter-spacing: 5px; text-shadow: 0 0 30px #cc0000; }
        p { font-size: 1.2rem; color: #ccc; margin-bottom: 30px; }
        .btn {
            background: #cc0000; color: #fff; padding: 15px 40px;
            font-size: 1.5rem; border: 2px solid #ff0000; font-weight: bold; cursor: pointer;
            text-transform: uppercase; transition: all 0.2s;
        }
        .btn:hover { background: #ff0000; box-shadow: 0 0 20px #ff0000; transform: scale(1.05); }

        #damage-overlay {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: radial-gradient(circle, transparent 20%, rgba(255,0,0,0.6) 90%);
            opacity: 0; transition: opacity 0.1s; pointer-events: none; z-index: 5;
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
</head>
<body>

    <div id="damage-overlay"></div>
    <div id="crosshair"></div>

    <div id="ui-layer">
        <div class="top-bar">
            <a href="game.jsp" class="back-btn">◄ EXIT</a>
            <div id="hud-top">
                <div class="stat-box">
                    <span>HP</span>
                    <div class="health-container">
                        <div class="health-fill" id="hp-bar"></div>
                        <div class="health-text" id="hp-text">100%</div>
                    </div>
                </div>
                <div class="stat-box">
                    KILLS: <span id="score" style="color: #fff">0</span>
                </div>
            </div>
        </div>
        <div id="weapon-info">
            <div class="weapon-name" id="weapon-name">PLASMA RIFLE</div>
            <div class="ammo-count">∞</div>
        </div>
    </div>

    <div id="blocker" class="overlay-screen">
        <h1>HAUNTED</h1>
        <p>Use <b>W, A, S, D</b> to Move • Mouse to Look • Click to Shoot</p>
        <button class="btn" id="play-btn">CLICK TO START</button>
    </div>

    <div id="death-screen" class="overlay-screen" style="display:none;">
        <h1>YOU DIED</h1>
        <p id="final-score">Score: 0</p>
        <button class="btn" onclick="location.reload()">TRY AGAIN</button>
    </div>

    <script>
        // --- 1. PROCEDURAL TEXTURES ---
        function createTexture(type) {
            const canvas = document.createElement('canvas');
            canvas.width = 512; canvas.height = 512;
            const ctx = canvas.getContext('2d');

            if(type === 'wood') {
                ctx.fillStyle = '#4e342e'; ctx.fillRect(0,0,512,512);
                ctx.fillStyle = '#5d4037'; for(let i=0; i<30; i++) ctx.fillRect(Math.random()*512, 0, Math.random()*40, 512);
                ctx.strokeStyle = '#3e2723'; ctx.lineWidth = 2; for(let i=0; i<=512; i+=64) { ctx.beginPath(); ctx.moveTo(i,0); ctx.lineTo(i,512); ctx.stroke(); }
            }
            else if(type === 'brick') {
                ctx.fillStyle = '#5d4037'; ctx.fillRect(0,0,512,512);
                ctx.fillStyle = '#6d4c41';
                for(let y=0; y<512; y+=64) { for(let x=0; x<512; x+=128) { let offset = (y/64)%2===0?0:64; ctx.fillRect(x+offset+2, y+2, 124, 60); } }
            }
            else if(type === 'concrete') {
                ctx.fillStyle = '#555'; ctx.fillRect(0,0,512,512);
                for(let i=0; i<500; i++) { ctx.fillStyle = Math.random()>0.5?'#666':'#444'; ctx.fillRect(Math.random()*512, Math.random()*512, 3, 3); }
            }
            const tex = new THREE.CanvasTexture(canvas);
            tex.wrapS = THREE.RepeatWrapping; tex.wrapT = THREE.RepeatWrapping;
            return tex;
        }

        const texWood = createTexture('wood'); texWood.repeat.set(8, 8);
        const texBrick = createTexture('brick');
        const texCeiling = createTexture('concrete'); texCeiling.repeat.set(8, 8);

        // --- 2. SETUP ---
        const PLAYER_HEIGHT = 1.6;
        const MOVE_SPEED = 8.0;
        let gameActive = false;
        let score = 0;
        let health = 100;
        let lastTime = performance.now();

        // Physics Objects
        const velocity = new THREE.Vector3();
        const controls = { w:false, a:false, s:false, d:false };

        const scene = new THREE.Scene();
        scene.background = new THREE.Color(0x1a1a1a);
        scene.fog = new THREE.FogExp2(0x1a1a1a, 0.025);

        // Use Object3D as player container to keep camera upright
        const player = new THREE.Object3D();
        scene.add(player);

        const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 100);
        camera.position.y = PLAYER_HEIGHT;
        player.add(camera);

        const renderer = new THREE.WebGLRenderer({ antialias: true });
        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.shadowMap.enabled = true;
        document.body.appendChild(renderer.domElement);

        // --- 3. LIGHTING ---
        const ambientLight = new THREE.AmbientLight(0xffffff, 0.6);
        scene.add(ambientLight);

        const flashLight = new THREE.SpotLight(0xffffff, 1.2, 60, 0.6, 0.5, 1);
        flashLight.position.set(0, 0, 0);
        flashLight.castShadow = true;
        camera.add(flashLight);

        const hallLight = new THREE.PointLight(0xffcc00, 0.8, 40);
        hallLight.position.set(0, 4, 0);
        scene.add(hallLight);

        // --- 4. ENVIRONMENT ---
        const walls = [];
        const wallBox = new THREE.Box3();
        const playerBox = new THREE.Box3();

        // Floor/Ceil
        const floor = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), new THREE.MeshStandardMaterial({ map: texWood, roughness: 0.8 }));
        floor.rotation.x = -Math.PI / 2;
        floor.receiveShadow = true;
        scene.add(floor);

        const ceil = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), new THREE.MeshStandardMaterial({ map: texCeiling, roughness: 0.9 }));
        ceil.rotation.x = Math.PI / 2;
        ceil.position.y = 5;
        scene.add(ceil);

        // Walls
        const wallGeo = new THREE.BoxGeometry(4, 5, 4);
        const wallMat = new THREE.MeshStandardMaterial({ map: texBrick });

        // Boundaries
        function addWall(x, z, w, d) {
            const b = new THREE.Mesh(new THREE.BoxGeometry(w, 5, d), wallMat);
            b.position.set(x, 2.5, z);
            scene.add(b);
            walls.push(b);
        }
        addWall(0, -50, 100, 2); addWall(0, 50, 100, 2); addWall(-50, 0, 2, 100); addWall(50, 0, 2, 100);

        // Maze
        for(let i=0; i<40; i++) {
            let x = (Math.random() - 0.5) * 80;
            let z = (Math.random() - 0.5) * 80;
            if(Math.abs(x) < 8 && Math.abs(z) < 8) x += 15;
            const wall = new THREE.Mesh(wallGeo, wallMat);
            wall.position.set(x, 2.5, z);
            wall.castShadow = true;
            scene.add(wall);
            walls.push(wall);
        }

        // --- 5. WEAPON & ZOMBIES ---
        const weapons = { 1: {name:"PLASMA RIFLE", color:0x00ffff, damage:34, rate:120, pellets:1}, 2: {name:"SHOTGUN", color:0xffaa00, damage:15, rate:800, pellets:8} };
        let currentWeapon = weapons[1];
        let lastShot = 0;

        const gunGroup = new THREE.Group();
        const gunBody = new THREE.Mesh(new THREE.BoxGeometry(0.15, 0.2, 0.7), new THREE.MeshStandardMaterial({ color: 0x222 }));
        const gunBarrel = new THREE.Mesh(new THREE.CylinderGeometry(0.04, 0.04, 0.7), new THREE.MeshStandardMaterial({ color: 0x111 }));
        gunBarrel.rotation.x = Math.PI/2; gunBarrel.position.set(0, 0.05, -0.1);
        gunGroup.add(gunBody); gunGroup.add(gunBarrel);
        gunGroup.position.set(0.3, -0.35, -0.6);
        camera.add(gunGroup);

        const muzzleLight = new THREE.PointLight(0xffff00, 0, 5);
        muzzleLight.position.set(0, 0.1, -0.8);
        gunGroup.add(muzzleLight);

        const zombies = [];
        const zombieMat = new THREE.MeshStandardMaterial({ color: 0x556b2f });
        const shirtMat = new THREE.MeshStandardMaterial({ color: 0x3d4c53 });
        const eyeMat = new THREE.MeshBasicMaterial({ color: 0xff0000 });

        function spawnZombie() {
            if (!gameActive) return;
            const angle = Math.random() * Math.PI * 2;
            const radius = 30 + Math.random() * 20;
            const x = Math.cos(angle) * radius + player.position.x;
            const z = Math.sin(angle) * radius + player.position.z;

            const zGroup = new THREE.Group();

            // Body parts
            const torso = new THREE.Mesh(new THREE.BoxGeometry(0.6, 0.8, 0.3), shirtMat); torso.position.y = 1.3;
            const head = new THREE.Mesh(new THREE.BoxGeometry(0.4, 0.4, 0.4), zombieMat); head.position.y = 1.9;
            const lArm = new THREE.Mesh(new THREE.BoxGeometry(0.15, 0.7, 0.15), zombieMat); lArm.position.set(-0.4, 1.4, 0.3); lArm.rotation.x = -1.5;
            const rArm = new THREE.Mesh(new THREE.BoxGeometry(0.15, 0.7, 0.15), zombieMat); rArm.position.set(0.4, 1.4, 0.3); rArm.rotation.x = -1.5;

            zGroup.add(torso); zGroup.add(head); zGroup.add(lArm); zGroup.add(rArm);

            // Eyes
            const eye1 = new THREE.Mesh(new THREE.PlaneGeometry(0.08, 0.05), eyeMat); eye1.position.set(0.1, 1.95, 0.21); zGroup.add(eye1);
            const eye2 = new THREE.Mesh(new THREE.PlaneGeometry(0.08, 0.05), eyeMat); eye2.position.set(-0.1, 1.95, 0.21); zGroup.add(eye2);

            zGroup.position.set(x, 0, z);
            zGroup.userData = { health: 100, speed: 2 + Math.random(), box: new THREE.Box3() };
            scene.add(zGroup);
            zombies.push(zGroup);
        }

        // --- 6. CONTROLS ---
        const onKeyDown = (e) => {
            switch(e.code) {
                case 'KeyW': controls.w = true; break;
                case 'KeyA': controls.a = true; break;
                case 'KeyS': controls.s = true; break;
                case 'KeyD': controls.d = true; break;
                case 'Digit1': switchWeapon(1); break;
                case 'Digit2': switchWeapon(2); break;
            }
        };
        const onKeyUp = (e) => {
            switch(e.code) {
                case 'KeyW': controls.w = false; break;
                case 'KeyA': controls.a = false; break;
                case 'KeyS': controls.s = false; break;
                case 'KeyD': controls.d = false; break;
            }
        };
        document.addEventListener('keydown', onKeyDown);
        document.addEventListener('keyup', onKeyUp);

        // Pointer Lock & Mouse Look
        const blocker = document.getElementById('blocker');
        document.getElementById('play-btn').addEventListener('click', () => { document.body.requestPointerLock(); });

        document.addEventListener('pointerlockchange', () => {
            if (document.pointerLockElement === document.body) {
                blocker.style.display = 'none';
                if(!gameActive && health > 0) startGame();
            } else {
                if(health > 0) blocker.style.display = 'flex';
            }
        });

        let mouseX = 0;
        let mouseY = 0;

        document.addEventListener('mousemove', (e) => {
            if (document.pointerLockElement) {
                mouseX -= e.movementX * 0.002;
                mouseY -= e.movementY * 0.002;
                mouseY = Math.max(-Math.PI/2, Math.min(Math.PI/2, mouseY));
            }
        });

        document.addEventListener('mousedown', () => { if(document.pointerLockElement) fireWeapon(); });

        // --- 7. GAME LOGIC ---
        function startGame() {
            gameActive = true;
            if(zombies.length === 0) for(let i=0; i<3; i++) spawnZombie();
        }

        function switchWeapon(id) {
            currentWeapon = weapons[id];
            document.getElementById('weapon-name').innerText = currentWeapon.name;
            document.getElementById('weapon-name').style.color = '#' + currentWeapon.color.toString(16);
        }

        function fireWeapon() {
            if(!gameActive) return;
            const now = performance.now();
            if(now - lastShot < currentWeapon.rate) return;
            lastShot = now;

            // Recoil
            gunGroup.position.z += 0.2;
            muzzleLight.color.setHex(currentWeapon.color);
            muzzleLight.intensity = 3;
            setTimeout(() => muzzleLight.intensity = 0, 50);

            const ray = new THREE.Raycaster();
            for(let i=0; i<currentWeapon.pellets; i++) {
                const spread = new THREE.Vector2((Math.random()-0.5)*0.05, (Math.random()-0.5)*0.05);
                ray.setFromCamera(spread, camera);
                const hits = ray.intersectObjects(zombies, true);
                if(hits.length > 0) {
                    let z = hits[0].object;
                    while(z.parent && z.parent.type !== 'Scene') z = z.parent;
                    if(z.userData.health) {
                        z.userData.health -= currentWeapon.damage;
                        // Flash red
                        z.children.forEach(c => { if(c.material && c.material.emissive) c.material.emissive.setHex(0xff0000); });
                        setTimeout(() => z.children.forEach(c => { if(c.material && c.material.emissive) c.material.emissive.setHex(0x000000); }), 100);

                        // Pushback
                        const push = z.position.clone().sub(player.position).normalize().multiplyScalar(0.8);
                        z.position.add(push);

                        if(z.userData.health <= 0) killZombie(z);
                    }
                }
            }
        }

        function killZombie(z) {
            scene.remove(z);
            zombies.splice(zombies.indexOf(z), 1);
            score++;
            document.getElementById('score').innerText = score;
        }

        function hurtPlayer(amt) {
            health -= amt;
            document.getElementById('hp-text').innerText = Math.max(0, Math.floor(health)) + '%';
            document.getElementById('hp-bar').style.width = Math.max(0, health) + '%';
            const overlay = document.getElementById('damage-overlay');
            overlay.style.opacity = 0.8;
            setTimeout(() => overlay.style.opacity = 0, 300);
            if(health <= 0) gameOver();
        }

        function gameOver() {
            gameActive = false;
            document.exitPointerLock();
            document.getElementById('death-screen').style.display = 'flex';
            document.getElementById('final-score').innerText = "Score: " + score;
        }

        // --- 8. FIXED PHYSICS & COLLISION ---
        function checkCollision(pos, radius) {
            const pBox = new THREE.Box3();
            pBox.setFromCenterAndSize(pos, new THREE.Vector3(radius*2, 2, radius*2));

            for (let w of walls) {
                wallBox.setFromObject(w);
                if (pBox.intersectsBox(wallBox)) return true;
            }
            return false;
        }

        function animate() {
            requestAnimationFrame(animate);
            const time = performance.now();
            const delta = Math.min((time - lastTime) / 1000, 0.1);
            lastTime = time;

            if (gameActive) {
                // --- CAMERA ROTATION (UPRIGHT FIX) ---
                // Player container only rotates on Y axis (left/right)
                player.rotation.y = mouseX;
                // Camera inside container rotates on X axis (up/down) - stays upright
                camera.rotation.x = mouseY;
                camera.rotation.z = 0; // Force no tilt

                // --- SIMPLE PLAYER MOVEMENT ---
                // Apply friction
                velocity.x *= 0.9;
                velocity.z *= 0.9;

                // Get forward direction from player rotation (Y axis only)
                const forward = new THREE.Vector3(0, 0, -1);
                forward.applyAxisAngle(new THREE.Vector3(0, 1, 0), player.rotation.y);

                // Get right direction
                const right = new THREE.Vector3(1, 0, 0);
                right.applyAxisAngle(new THREE.Vector3(0, 1, 0), player.rotation.y);

                // Reset movement
                const move = new THREE.Vector3();

                // Apply controls with natural movement
                if (controls.w) { // Forward - natural forward movement
                    move.add(forward.multiplyScalar(MOVE_SPEED * delta));
                    forward.normalize();
                }
                if (controls.s) { // Backward
                    move.sub(forward.multiplyScalar(MOVE_SPEED * delta));
                    forward.normalize();
                }
                if (controls.d) { // Right strafe
                    move.add(right.multiplyScalar(MOVE_SPEED * delta));
                }
                if (controls.a) { // Left strafe
                    move.sub(right.multiplyScalar(MOVE_SPEED * delta));
                }

                // Store old position
                const oldPos = player.position.clone();

                // Apply X movement first
                player.position.x += move.x;
                if (checkCollision(player.position, 0.4)) {
                    player.position.x = oldPos.x;
                }

                // Apply Z movement
                player.position.z += move.z;
                if (checkCollision(player.position, 0.4)) {
                    player.position.z = oldPos.z;
                }

                // Update velocity for weapon sway
                velocity.x = move.x / delta;
                velocity.z = move.z / delta;

                // Simple head bobbing when moving
                if (controls.w || controls.a || controls.s || controls.d) {
                    camera.position.y = PLAYER_HEIGHT + Math.sin(time * 0.015) * 0.03;
                } else {
                    camera.position.y = PLAYER_HEIGHT;
                }

                // Weapon Sway
                gunGroup.position.z += ( -0.6 - gunGroup.position.z ) * 0.1;
                gunGroup.rotation.z = -velocity.x * 0.0002;

                // --- ZOMBIE LOGIC ---
                zombies.forEach((z, i) => {
                    // Update Zombie Box
                    z.userData.box.setFromObject(z);

                    // Move towards player
                    z.lookAt(player.position.x, 0, player.position.z);
                    const zDir = new THREE.Vector3(0,0,1).applyQuaternion(z.quaternion);
                    const moveDist = z.userData.speed * delta;

                    const oldPos = z.position.clone();
                    z.position.addScaledVector(zDir, moveDist);

                    // Wall Collision for Zombies
                    if(checkCollision(z.position, 0.5)) {
                        z.position.copy(oldPos); // Stop at wall
                    }

                    // Separation (Don't stack)
                    for(let j=0; j<zombies.length; j++) {
                        if(i !== j) {
                            const dist = z.position.distanceTo(zombies[j].position);
                            if(dist < 1.0) {
                                const push = z.position.clone().sub(zombies[j].position).normalize().multiplyScalar(0.05);
                                z.position.add(push);
                            }
                        }
                    }

                    // Player Hit
                    const distToPlayer = z.position.distanceTo(player.position);
                    if(distToPlayer < 1.2) {
                        hurtPlayer(0.5);
                    }
                });

                // Spawner
                if(zombies.length < 3 + (score/10) && zombies.length < 15) {
                    if(Math.random() < 0.005) spawnZombie();
                }
            }

            renderer.render(scene, camera);
        }

        window.addEventListener('resize', () => {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        });

        animate();
    </script>
</body>
</html>