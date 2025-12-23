<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.model.User, com.project.model.PaymentTransaction" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    List<PaymentTransaction> transactions = (List<PaymentTransaction>) request.getAttribute("transactions");
    if (transactions == null) transactions = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction History</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .history-container {
            padding: 20px;
        }
        .back-btn {
            display: inline-block;
            margin-bottom: 20px;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .back-btn:hover {
            background: #764ba2;
        }
        .table-container {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: #667eea;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: bold;
        }
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
        tr:hover {
            background: #f9f9f9;
        }
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-completed {
            background: #d4edda;
            color: #155724;
        }
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        .status-failed {
            background: #f8d7da;
            color: #721c24;
        }
        .amount {
            font-weight: bold;
            color: #667eea;
        }
        .amount.withdraw,
        .amount.transfer {
            color: #dc3545;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-card h4 {
            margin: 0 0 10px 0;
            color: #666;
            font-size: 14px;
        }
        .stat-card .value {
            font-size: 28px;
            font-weight: bold;
            color: #667eea;
        }
    </style>
</head>
<body>
<div class="navbar">
    <div class="navbar-container">
        <a href="dashboard" class="navbar-logo">Payment History</a>
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

<div class="history-container">
    <a href="digital-payment" class="back-btn">← Back to Payment</a>
    
    <h1>📋 Transaction History</h1>

    <div class="stats-container">
        <div class="stat-card">
            <h4>Total Transactions</h4>
            <div class="value"><%= transactions.size() %></div>
        </div>
        <div class="stat-card">
            <h4>Account Balance</h4>
            <div class="value">$<%= String.format("%.2f", user.getBalance()) %></div>
        </div>
    </div>

    <% if (transactions.isEmpty()) { %>
        <div class="table-container">
            <div class="no-data">
                <p>No transactions found. Start by making a deposit or transfer.</p>
            </div>
        </div>
    <% } else { %>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Transaction ID</th>
                        <th>Type</th>
                        <th>Amount</th>
                        <th>Method</th>
                        <th>Status</th>
                        <th>Description</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (PaymentTransaction trans : transactions) { %>
                        <tr>
                            <td><%= trans.getTransactionId() %></td>
                            <td><%= trans.getTransactionType() %></td>
                            <td class="amount <%= trans.getTransactionType().equals("Deposit") ? "" : "withdraw" %>">
                                <%= trans.getTransactionType().equals("Deposit") ? "+" : "-" %>$<%= String.format("%.2f", trans.getAmount()) %>
                            </td>
                            <td><%= trans.getPaymentMethod() %></td>
                            <td>
                                <span class="status-badge status-<%= trans.getStatus().toLowerCase() %>">
                                    <%= trans.getStatus() %>
                                </span>
                            </td>
                            <td><%= trans.getDescription() %></td>
                            <td><%= trans.getTransactionDate() %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>

<footer>
    <p>&copy; 2025 Third Semester Java Project. All rights reserved.</p>
</footer>

<script src="js/main.js"></script>
</body>
</html>
