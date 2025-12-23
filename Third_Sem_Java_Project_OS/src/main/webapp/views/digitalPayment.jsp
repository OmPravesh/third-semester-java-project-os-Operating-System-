<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.project.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Digital Payment System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .payment-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        .payment-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .payment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.2);
        }
        .payment-card h3 {
            margin-top: 0;
            color: #667eea;
        }
        .balance-card {
            grid-column: 1 / -1;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-align: center;
        }
        .balance-card h2 {
            margin: 0;
            font-size: 36px;
        }
        .balance-label {
            font-size: 14px;
            opacity: 0.9;
            margin-top: 5px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 5px rgba(102,126,234,0.3);
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.3s;
        }
        .btn-submit:hover {
            background: #764ba2;
        }
        .alert {
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 5px;
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .alert.success {
            background: #d4edda;
            color: #155724;
            border-color: #c3e6cb;
        }
    </style>
</head>
<body>
<div class="navbar">
    <div class="navbar-container">
        <a href="dashboard" class="navbar-logo">Digital Payment</a>
        <ul class="nav-menu">
            <li><a href="dashboard">Dashboard</a></li>
            <li><a href="games">Games</a></li>
            <li><a href="chat">Chat</a></li>
            <li><a href="digital-payment" class="active">Payments</a></li>
            <li><a href="stock">Stock Market</a></li>
            <li><a href="login" onclick="event.preventDefault(); fetch('login', {method: 'DELETE'}).then(() => window.location.href='login')">Logout</a></li>
        </ul>
    </div>
</div>

<div class="container">
    <h1>💳 Digital Payment System</h1>
    
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert"><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="payment-container">
        <div class="balance-card">
            <div class="balance-label">Your Current Balance</div>
            <h2>$<%= String.format("%.2f", user.getBalance()) %></h2>
        </div>

        <div class="payment-card">
            <h3>💰 Deposit Funds</h3>
            <form method="POST" action="digital-payment">
                <input type="hidden" name="action" value="deposit">
                <div class="form-group">
                    <label for="depositAmount">Amount ($)</label>
                    <input type="number" id="depositAmount" name="amount" min="1" step="0.01" required>
                </div>
                <div class="form-group">
                    <label for="depositMethod">Payment Method</label>
                    <select id="depositMethod" name="paymentMethod" required>
                        <option value="Credit Card">Credit Card</option>
                        <option value="Debit Card">Debit Card</option>
                        <option value="Digital Wallet">Digital Wallet</option>
                        <option value="Bank Transfer">Bank Transfer</option>
                    </select>
                </div>
                <button type="submit" class="btn-submit">Deposit Now</button>
            </form>
        </div>

        <div class="payment-card">
            <h3>🏦 Withdraw Funds</h3>
            <form method="POST" action="digital-payment">
                <input type="hidden" name="action" value="withdraw">
                <div class="form-group">
                    <label for="withdrawAmount">Amount ($)</label>
                    <input type="number" id="withdrawAmount" name="amount" min="1" step="0.01" required>
                </div>
                <div class="form-group">
                    <label for="withdrawMethod">Payment Method</label>
                    <select id="withdrawMethod" name="paymentMethod" required>
                        <option value="Bank Account">Bank Account</option>
                        <option value="Digital Wallet">Digital Wallet</option>
                        <option value="Check">Check</option>
                    </select>
                </div>
                <button type="submit" class="btn-submit">Withdraw Now</button>
            </form>
        </div>

        <div class="payment-card">
            <h3>📤 Transfer Money</h3>
            <form method="POST" action="digital-payment">
                <input type="hidden" name="action" value="transfer">
                <div class="form-group">
                    <label for="recipient">Recipient Username</label>
                    <input type="text" id="recipient" name="recipient" placeholder="Enter username" required>
                </div>
                <div class="form-group">
                    <label for="transferAmount">Amount ($)</label>
                    <input type="number" id="transferAmount" name="amount" min="1" step="0.01" required>
                </div>
                <button type="submit" class="btn-submit">Send Money</button>
            </form>
        </div>

        <div class="payment-card" style="grid-column: 1 / -1;">
            <h3>📋 View Transaction History</h3>
            <p style="margin: 0; color: #666;">Check all your past transactions and account activity.</p>
            <a href="digital-payment?action=history" style="display: inline-block; margin-top: 10px; padding: 10px 20px; background: #667eea; color: white; text-decoration: none; border-radius: 5px;">View History</a>
        </div>
    </div>
</div>

<footer>
    <p>&copy; 2025 Third Semester Java Project. All rights reserved.</p>
</footer>

<script src="js/main.js"></script>
</body>
</html>
