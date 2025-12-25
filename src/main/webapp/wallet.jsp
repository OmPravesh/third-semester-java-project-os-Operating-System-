<%@ page import="java.sql.*" %>
<%@ page import="com.webos.utils.DatabaseUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Wallet | Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary-blue: #003087; /* PayPal Dark Blue */
            --accent-blue: #0070ba;  /* PayPal Light Blue */
            --bg-color: #f5f7fa;
            --text-dark: #2c2e2f;
            --text-muted: #6c7378;
            --border-color: #eaeced;
            --white: #ffffff;
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Open Sans', sans-serif;
            background-color: var(--bg-color);
            margin: 0;
            padding: 0;
            color: var(--text-dark);
            height: 100vh;
            display: flex;
        }

        /* --- SIDEBAR --- */
        .sidebar {
            width: 260px;
            background: var(--primary-blue);
            color: white;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
        }

        .brand {
            height: 70px;
            display: flex;
            align-items: center;
            padding: 0 25px;
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: 0.5px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .brand i { margin-right: 10px; font-style: italic; }

        .nav-links {
            padding: 20px 0;
            flex: 1;
        }

        .nav-item {
            display: flex;
            align-items: center;
            padding: 15px 25px;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: all 0.2s;
            font-weight: 600;
        }
        .nav-item:hover, .nav-item.active {
            background: rgba(0,0,0,0.2);
            color: white;
            border-left: 4px solid var(--accent-blue);
        }
        .nav-item i { width: 25px; margin-right: 10px; text-align: center; }

        /* --- MAIN CONTENT --- */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }

        /* Header */
        .header {
            height: 70px;
            background: white;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 40px;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            color: var(--primary-blue);
        }
        .avatar {
            width: 40px; height: 40px;
            background: var(--bg-color);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: var(--text-muted);
        }

        /* Dashboard Grid */
        .container {
            padding: 40px;
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
        }

        .balance-card {
            background: var(--white);
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            text-align: center;
            margin-bottom: 30px;
            border: 1px solid var(--border-color);
        }

        .balance-label { font-size: 0.9rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; }
        .balance-amount { font-size: 3rem; font-weight: 300; color: var(--text-dark); margin: 10px 0; }

        /* Action Grid */
        .action-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }

        /* Send Money Form */
        .card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            border: 1px solid var(--border-color);
        }

        .card-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: var(--text-dark);
            display: flex; align-items: center; gap: 10px;
        }

        .form-group { margin-bottom: 20px; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 0.9rem; color: var(--text-dark); }

        .form-input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ced4da;
            border-radius: 8px;
            font-size: 1rem;
            transition: border 0.2s;
        }
        .form-input:focus { border-color: var(--accent-blue); outline: none; }

        .btn-send {
            width: 100%;
            background: var(--primary-blue);
            color: white;
            border: none;
            padding: 14px;
            border-radius: 50px; /* Pill Shape */
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-send:hover { background: var(--accent-blue); }

        /* Alerts */
        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
            text-align: center;
            font-weight: 600;
        }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        /* Recent Activity (Placeholder) */
        .activity-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid var(--border-color);
        }
        .activity-item:last-child { border-bottom: none; }
        .act-icon { width: 40px; height: 40px; border-radius: 50%; background: #eef2f5; display: flex; align-items: center; justify-content: center; color: var(--primary-blue); }

        @media (max-width: 768px) {
            body { flex-direction: column; }
            .sidebar { width: 100%; height: auto; }
            .action-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <%
        // Logic to fetch user and balance
        String user = (String) session.getAttribute("name");
        double balance = 0.00;

        if(user != null) {
            try {
                Connection con = DatabaseUtil.getConnection();
                PreparedStatement pst = con.prepareStatement("SELECT balance FROM users WHERE username=?");
                pst.setString(1, user);
                ResultSet rs = pst.executeQuery();
                if(rs.next()) {
                    balance = rs.getDouble("balance");
                }
                con.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
        } else {
            user = "Guest"; // Fallback
        }
    %>

    <nav class="sidebar">
        <div class="brand">
            <i class="fab fa-paypal"></i> PayApp
        </div>
        <div class="nav-links">
            <a href="#" class="nav-item active"><i class="fas fa-home"></i> Dashboard</a>
            <a href="wallet.jsp" class="nav-item"><i class="fas fa-wallet"></i> Wallet</a>
            <a href="#" class="nav-item"><i class="fas fa-history"></i> Activity</a>
            <a href="index.jsp" class="nav-item"><i class="fas fa-arrow-left"></i> Back to OS</a>
        </div>
    </nav>

    <div class="main-content">
        <header class="header">
            <div style="font-size:0.9rem; color:var(--text-muted);">Welcome back!</div>
            <div class="user-profile">
                <span><%= user %></span>
                <div class="avatar"><i class="fas fa-user"></i></div>
            </div>
        </header>

        <div class="container">
            <div class="balance-card">
                <div class="balance-label">PayPal Balance</div>
                <div class="balance-amount">$<%= String.format("%.2f", balance) %></div>
                <div style="color: var(--accent-blue); font-weight: 600; cursor: pointer;">
                    Transfer Funds
                </div>
            </div>

            <div class="action-grid">
                <div class="card">
                    <div class="card-title"><i class="fas fa-paper-plane"></i> Send Money</div>

                    <form action="wallet" method="post">
                        <div class="form-group">
                            <label class="form-label">Send to</label>
                            <div style="position:relative;">
                                <i class="fas fa-search" style="position:absolute; left:15px; top:14px; color:#ccc;"></i>
                                <input type="text" name="recipient" class="form-input" style="padding-left:40px;" placeholder="Name, @username, email" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Amount</label>
                            <div style="display:flex; align-items:center;">
                                <span style="font-size:1.5rem; margin-right:10px;">$</span>
                                <input type="number" step="0.01" name="amount" class="form-input" placeholder="0.00" style="font-size:1.5rem; font-weight:300;" required>
                            </div>
                        </div>

                        <button type="submit" class="btn-send">Send Now</button>
                    </form>

                    <%
                        String status = (String) request.getAttribute("status");
                        if("success".equals(status)) {
                    %>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i> Money sent successfully!
                        </div>
                    <% } else if("failed".equals(status)) { %>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i> Transaction failed. Check balance or username.
                        </div>
                    <% } %>
                </div>

                <div class="card">
                    <div class="card-title">Recent Activity</div>
                    <div class="activity-list">
                        <div class="activity-item">
                            <div style="display:flex; align-items:center; gap:10px;">
                                <div class="act-icon"><i class="fas fa-shopping-bag"></i></div>
                                <div>
                                    <div style="font-weight:600;">eBay Purchase</div>
                                    <div style="font-size:0.8rem; color:#888;">Oct 24</div>
                                </div>
                            </div>
                            <div style="font-weight:600;">-$24.00</div>
                        </div>
                        <div class="activity-item">
                            <div style="display:flex; align-items:center; gap:10px;">
                                <div class="act-icon"><i class="fas fa-user"></i></div>
                                <div>
                                    <div style="font-weight:600;">Payment from John</div>
                                    <div style="font-size:0.8rem; color:#888;">Oct 21</div>
                                </div>
                            </div>
                            <div style="font-weight:600; color:green;">+$50.00</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>