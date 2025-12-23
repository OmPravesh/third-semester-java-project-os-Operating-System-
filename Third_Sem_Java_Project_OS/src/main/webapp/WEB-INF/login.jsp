<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - OS Project</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 400px;
        }
        .logo {
            text-align: center;
            font-size: 2.5rem;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="logo">OS PROJECT</div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="login" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username"
                       required placeholder="Enter username">
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password"
                       required placeholder="Enter password">
            </div>
            <button type="submit" class="btn btn-primary w-100">Sign In</button>
        </form>

        <div class="text-center mt-3">
            <small>Demo credentials: admin / admin123</small>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>