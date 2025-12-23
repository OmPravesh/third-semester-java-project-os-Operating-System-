<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - OS Project</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --dark-bg: #121212;
            --card-bg: #1e1e1e;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--dark-bg);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-container {
            width: 100%;
            max-width: 420px;
            padding: 20px;
        }

        .login-card {
            background: var(--card-bg);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .app-logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo-icon {
            background: var(--primary-gradient);
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 2rem;
            color: white;
        }

        .logo-text {
            font-size: 2rem;
            font-weight: bold;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .form-control {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            padding: 12px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            transition: all 0.3s;
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.15);
            border-color: #667eea;
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
            color: white;
        }

        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.5);
        }

        .btn-login {
            background: var(--primary-gradient);
            border: none;
            color: white;
            padding: 12px;
            border-radius: 10px;
            font-weight: 600;
            width: 100%;
            margin-top: 10px;
            transition: transform 0.3s;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            color: white;
        }

        .error-message {
            background: rgba(220, 53, 69, 0.2);
            border: 1px solid rgba(220, 53, 69, 0.5);
            color: #f8d7da;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }

        .demo-credentials {
            margin-top: 25px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            text-align: center;
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.9rem;
        }

        .input-group-text {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: rgba(255, 255, 255, 0.7);
        }

        .form-label {
            color: rgba(255, 255, 255, 0.9);
            font-weight: 500;
            margin-bottom: 8px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="app-logo">
                <div class="logo-icon">
                    <i class="fas fa-desktop"></i>
                </div>
                <h1 class="logo-text">OS Project</h1>
                <p class="text-center text-muted mt-2">Third Semester Project</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="login" method="post">
                <div class="mb-3">
                    <label for="username" class="form-label">
                        <i class="fas fa-user me-2"></i>Username
                    </label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-at"></i>
                        </span>
                        <input type="text" class="form-control" id="username"
                               name="username" required
                               placeholder="Enter your username">
                    </div>
                </div>

                <div class="mb-4">
                    <label for="password" class="form-label">
                        <i class="fas fa-lock me-2"></i>Password
                    </label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-key"></i>
                        </span>
                        <input type="password" class="form-control" id="password"
                               name="password" required
                               placeholder="Enter your password">
                    </div>
                </div>

                <button type="submit" class="btn btn-login">
                    <i class="fas fa-sign-in-alt me-2"></i>Sign In
                </button>
            </form>

            <div class="demo-credentials">
                <p class="mb-1"><strong>Demo Credentials:</strong></p>
                <p class="mb-0">Username: <code>admin</code></p>
                <p class="mb-0">Password: <code>admin123</code></p>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Focus on username field on page load
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('username').focus();
        });

        // Show/hide password
        document.getElementById('password').addEventListener('keyup', function(e) {
            if (e.key === 'Enter') {
                document.querySelector('form').submit();
            }
        });
    </script>
</body>
</html>