<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("name");
    if (username == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hill Climb Racing | WebOS</title>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.4.0/p5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/box2dweb/2.1.a.3/Box2D.min.js"></script>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>

    <style>
        body {
            margin: 0; padding: 0;
            background: #2c3e50;
            overflow: hidden;
            font-family: 'Segoe UI', sans-serif;
            color: white;
            user-select: none;
        }
        #game-container {
            position: relative;
            width: 100vw;
            height: 100vh;
        }
        .ui-layer {
            position: absolute;
            top: 20px; left: 20px;
            pointer-events: none;
            z-index: 10;
        }
        .stat-box {
            background: rgba(0,0,0,0.6);
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 1.5rem;
            font-weight: bold;
            text-shadow: 2px 2px 0 #000;
            border: 2px solid rgba(255,255,255,0.2);
        }
        .back-btn {
            position: absolute;
            top: 20px; right: 20px;
            background: #e74c3c;
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            font-weight: bold;
            border-radius: 5px;
            pointer-events: all;
            box-shadow: 0 4px 0 #c0392b;
            transition: transform 0.1s;
        }
        .back-btn:active { transform: translateY(4px); box-shadow: 0 0 0; }

        .controls-hint {
            position: absolute;
            bottom: 20px; width: 100%;
            text-align: center;
            font-size: 1.2rem;
            color: rgba(255,255,255,0.7);
            text-shadow: 1px 1px 2px black;
            pointer-events: none;
        }

        #game-over {
            display: none;
            position: absolute;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(0,0,0,0.9);
            padding: 40px;
            text-align: center;
            border: 4px solid #fff;
            border-radius: 10px;
            z-index: 20;
        }
        button.restart {
            background: #27ae60; color: white; border: none;
            padding: 15px 30px; font-size: 1.2rem; font-weight: bold;
            cursor: pointer; margin-top: 20px; border-radius: 5px;
        }
    </style>
</head>
<body>

    <div id="game-container">
        <a href="game.jsp" class="back-btn">EXIT</a>

        <div class="ui-layer">
            <div class="stat-box">DIST: <span id="dist">0</span>m</div>
        </div>

        <div id="game-over">
            <h1 style="color:#e74c3c; font-size:3rem; margin:0;">CRASHED</h1>
            <p style="font-size:1.5rem;">Driver Down</p>
            <button class="restart" onclick="location.reload()">TRY AGAIN</button>
        </div>

        <div class="controls-hint">
            <i class="fas fa-arrow-left"></i> BRAKE/TILT &nbsp;&nbsp;&nbsp; <i class="fas fa-arrow-right"></i> GAS/TILT
        </div>
    </div>

    <script>
        // --- BOX2D ALIASES ---
        var b2Vec2 = Box2D.Common.Math.b2Vec2;
        var b2BodyDef = Box2D.Dynamics.b2BodyDef;
        var b2Body = Box2D.Dynamics.b2Body;
        var b2FixtureDef = Box2D.Dynamics.b2FixtureDef;
        var b2World = Box2D.Dynamics.b2World;
        var b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape;
        var b2CircleShape = Box2D.Collision.Shapes.b2CircleShape;
        var b2RevoluteJointDef = Box2D.Dynamics.Joints.b2RevoluteJointDef;

        // --- GAME CONFIG ---
        var world;
        var SCALE = 30; // Pixels per meter
        var car;
        var ground;
        var terrainPoints = [];
        var gameOver = false;
        var cameraX = 0;
        var score = 0;

        // --- P5.js SETUP ---
        function setup() {
            let canvas = createCanvas(windowWidth, windowHeight);
            canvas.parent('game-container');

            // 1. Initialize Box2D World
            world = new b2World(new b2Vec2(0, 10), true); // Gravity 10 down

            // 2. Generate Infinite Ground
            ground = new Ground();

            // 3. Create Car
            car = new Car(200, 300);
        }

        // --- P5.js DRAW LOOP ---
        function draw() {
            background(135, 206, 235); // Sky Blue

            if(!gameOver) {
                // Physics Step
                world.Step(1/60, 10, 10);
                world.ClearForces();

                car.update();
                ground.update(cameraX); // Extend ground if needed
            }

            // Camera Logic
            let carPos = car.getBodyPosition();
            // Smooth lerp camera
            cameraX = lerp(cameraX, carPos.x * SCALE - width/3, 0.1);

            push();
            translate(-cameraX, 0);

            // Render
            ground.show();
            car.show();

            pop();

            // UI Update
            score = Math.floor(Math.max(score, carPos.x));
            document.getElementById('dist').innerText = score;
        }

        function windowResized() { resizeCanvas(windowWidth, windowHeight); }

        function keyPressed() {
            if(keyCode === RIGHT_ARROW) car.motorOn(true);
            if(keyCode === LEFT_ARROW) car.motorOn(false);
        }

        function keyReleased() {
            if(keyCode === RIGHT_ARROW || keyCode === LEFT_ARROW) car.motorOff();
        }

        // --- CLASSES ---

        class Car {
            constructor(x, y) {
                this.wheels = [];

                // Chassis Definition (From Car.js)
                let bodyDef = new b2BodyDef();
                bodyDef.type = b2Body.b2_dynamicBody;
                bodyDef.position.Set(x / SCALE, y / SCALE);
                this.chassis = world.CreateBody(bodyDef);

                // Shape
                let fixDef = new b2FixtureDef();
                fixDef.density = 1.0;
                fixDef.friction = 0.5;
                fixDef.restitution = 0.1;
                fixDef.shape = new b2PolygonShape();
                fixDef.shape.SetAsBox(60 / SCALE, 20 / SCALE); // 120x40 pixels
                this.chassis.CreateFixture(fixDef);

                // Cabin
                let cabinFix = new b2FixtureDef();
                cabinFix.density = 0.5;
                cabinFix.shape = new b2PolygonShape();
                let center = new b2Vec2(-10/SCALE, -30/SCALE);
                cabinFix.shape.SetAsOrientedBox(30/SCALE, 20/SCALE, center, 0);
                this.chassis.CreateFixture(cabinFix);

                // Add Driver
                this.driver = new Driver(x, y-50, this.chassis);

                // Wheels (Rear, Front)
                this.wheels.push(new Wheel(x - 45, y + 25, 20, this.chassis));
                this.wheels.push(new Wheel(x + 45, y + 25, 20, this.chassis));
            }

            motorOn(forward) {
                if(gameOver) return;
                let speed = forward ? -20 : 20;
                let torque = forward ? 800 : 600;

                // Apply motor to wheels
                this.wheels.forEach(w => {
                    w.joint.EnableMotor(true);
                    w.joint.SetMotorSpeed(speed);
                    w.joint.SetMaxMotorTorque(torque);
                });

                // Apply rotation torque for mid-air control (Tilt)
                let tilt = forward ? -20 : 20;
                this.chassis.ApplyTorque(tilt);
            }

            motorOff() {
                this.wheels.forEach(w => w.joint.EnableMotor(false));
            }

            update() {
                // Death check: If chassis flips too far or Driver touches ground
                let angle = this.chassis.GetAngle();
                // Simple flip check
                if(Math.abs(angle) > 2.5 && this.isTouchingGround()) {
                    triggerGameOver();
                }
            }

            isTouchingGround() {
                // Simplified contact check
                let pos = this.chassis.GetPosition();
                let gH = ground.getHeightAt(pos.x);
                return (pos.y > gH - 1);
            }

            getBodyPosition() { return this.chassis.GetPosition(); }

            show() {
                let pos = this.chassis.GetPosition();
                let angle = this.chassis.GetAngle();

                push();
                translate(pos.x * SCALE, pos.y * SCALE);
                rotate(angle);

                // Draw Chassis
                fill(231, 76, 60); stroke(0); strokeWeight(2);
                rectMode(CENTER);
                rect(0, 0, 120, 40, 5); // Body
                fill(192, 57, 43);
                rect(-10, -30, 60, 40, 5); // Cabin

                pop();

                this.driver.show();
                this.wheels.forEach(w => w.show());
            }
        }

        class Wheel {
            constructor(x, y, r, chassisBody) {
                this.r = r;

                let bodyDef = new b2BodyDef();
                bodyDef.type = b2Body.b2_dynamicBody;
                bodyDef.position.Set(x / SCALE, y / SCALE);
                this.body = world.CreateBody(bodyDef);

                let fixDef = new b2FixtureDef();
                fixDef.density = 0.8;
                fixDef.friction = 3.0; // High friction like in Wheel.js
                fixDef.restitution = 0.2;
                fixDef.shape = new b2CircleShape(r / SCALE);
                this.body.CreateFixture(fixDef);

                // Joint connecting wheel to car
                let jointDef = new b2RevoluteJointDef();
                jointDef.Initialize(chassisBody, this.body, this.body.GetWorldCenter());
                // jointDef.enableMotor = true; // Enabled later
                this.joint = world.CreateJoint(jointDef);
            }

            show() {
                let pos = this.body.GetPosition();
                let angle = this.body.GetAngle();
                push();
                translate(pos.x * SCALE, pos.y * SCALE);
                rotate(angle);
                fill(50); stroke(200); strokeWeight(2);
                ellipse(0, 0, this.r * 2);
                line(-this.r, 0, this.r, 0); // Spokes
                line(0, -this.r, 0, this.r);
                pop();
            }
        }

        class Driver {
            constructor(x, y, chassisBody) {
                // Head Body
                let bodyDef = new b2BodyDef();
                bodyDef.type = b2Body.b2_dynamicBody;
                bodyDef.position.Set(x / SCALE, y / SCALE);
                this.head = world.CreateBody(bodyDef);

                let circle = new b2CircleShape(15 / SCALE);
                let fix = new b2FixtureDef();
                fix.density = 0.1;
                this.head.CreateFixture(fix, circle);

                // Joint to Car
                let jointDef = new b2RevoluteJointDef();
                jointDef.Initialize(chassisBody, this.head, this.head.GetWorldCenter());
                // Add soft limits (neck stiffness)
                jointDef.enableLimit = true;
                jointDef.lowerAngle = -0.5;
                jointDef.upperAngle = 0.5;
                world.CreateJoint(jointDef);
            }
            show() {
                let pos = this.head.GetPosition();
                push();
                translate(pos.x * SCALE, pos.y * SCALE);
                rotate(this.head.GetAngle());
                fill(255, 200, 150); stroke(0);
                ellipse(0, 0, 30); // Head
                pop();
            }
        }

        class Ground {
            constructor() {
                this.body = world.CreateBody(new b2BodyDef()); // Static body
                this.points = [];
                this.startX = 0;
                this.generate(0, 50); // Initial chunk
            }

            generate(startIdx, count) {
                let noiseScale = 0.05;
                for(let i=0; i<count; i++) {
                    let x = (startIdx + i) * 40; // 40px spacing
                    // Perlin noise for terrain height
                    let n = noise((startIdx + i) * noiseScale);
                    let y = map(n, 0, 1, height/2, height - 50);

                    // Add peaks (like Ground.js randomization)
                    y += Math.sin((startIdx + i)*0.1) * 30;

                    this.points.push({x: x, y: y});
                }
                this.updateFixtures();
            }

            updateFixtures() {
                // Clear old fixtures (simplified: just add new ones for now)
                // In a robust engine, we destroy old ones to save memory.

                let len = this.points.length;
                if(len < 2) return;

                // Create edge shapes for the last added segment
                let p1 = this.points[len-2];
                let p2 = this.points[len-1];

                let fix = new b2FixtureDef();
                fix.friction = 1.0;
                fix.shape = new b2PolygonShape();

                // Box2DWeb Edge approximation using thin polygon
                let v1 = new b2Vec2(p1.x/SCALE, p1.y/SCALE);
                let v2 = new b2Vec2(p2.x/SCALE, p2.y/SCALE);
                fix.shape.SetAsEdge(v1, v2);

                this.body.CreateFixture(fix);
            }

            update(camX) {
                // Generate more terrain as we move right
                let lastPt = this.points[this.points.length-1];
                if(lastPt.x < camX + width + 500) {
                    this.generate(this.points.length, 20);
                }
            }

            getHeightAt(xM) {
                // Simple interpolation to find ground height at meter X
                let x = xM * SCALE;
                let idx = Math.floor(x / 40);
                if(idx < 0 || idx >= this.points.length-1) return 100;
                return this.points[idx].y / SCALE;
            }

            show() {
                fill(46, 204, 113); stroke(39, 174, 96); strokeWeight(4);
                beginShape();
                vertex(this.points[0].x, height*2);
                for(let p of this.points) {
                    vertex(p.x, p.y);
                }
                vertex(this.points[this.points.length-1].x, height*2);
                endShape(CLOSE);
            }
        }

        function triggerGameOver() {
            if(gameOver) return;
            gameOver = true;
            document.getElementById('game-over').style.display = 'block';
        }

    </script>
</body>
</html>