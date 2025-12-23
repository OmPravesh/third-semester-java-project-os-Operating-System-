<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Stock Market</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .stock-card { display: flex; justify-content: space-between; align-items: center; padding: 15px; border-bottom: 1px solid #eee; }
        .price-up { color: var(--google-green); }
        .price-down { color: var(--google-red); }
        .balance-card { background: var(--google-blue); color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <jsp:include page="/views/common/navbar.jsp" />
    
    <div class="container">
        <div class="row" style="display:flex; gap: 20px;">
            <div style="flex: 2;">
                <div class="card">
                    <h3>📈 Market Watch</h3>
                    <c:if test="${not empty error}"><div style="color:red; margin-bottom:10px;">${error}</div></c:if>
                    <c:if test="${not empty message}"><div style="color:green; margin-bottom:10px;">${message}</div></c:if>
                    
                    <c:forEach var="entry" items="${stocks}">
                        <div class="stock-card">
                            <div>
                                <strong>${entry.key}</strong><br>
                                <span class="text-secondary">Vol: High</span>
                            </div>
                            <div class="text-right">
                                <h4 class="price-up">$${entry.value}</h4>
                            </div>
                            <div>
                                <form action="${pageContext.request.contextPath}/stockMarket" method="post" style="display:inline;">
                                    <input type="hidden" name="symbol" value="${entry.key}">
                                    <input type="number" name="quantity" value="1" min="1" style="width:50px; padding:5px;">
                                    <button type="submit" name="action" value="buy" class="btn btn-success" style="padding: 5px 10px; font-size: 0.8rem;">Buy</button>
                                    <button type="submit" name="action" value="sell" class="btn btn-danger" style="padding: 5px 10px; font-size: 0.8rem;">Sell</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div style="flex: 1;">
                <div class="card balance-card">
                    <small>Available Balance</small>
                    <h1>$${sessionScope.user.balance}</h1>
                </div>
                
                <div class="card">
                    <h3>💼 Your Portfolio</h3>
                    <c:if test="${empty sessionScope.portfolio}">
                        <p class="text-secondary">You don't own any stocks yet.</p>
                    </c:if>
                    <ul style="list-style: none; padding: 0;">
                        <c:forEach var="p" items="${sessionScope.portfolio}">
                            <c:if test="${p.value > 0}">
                                <li style="padding: 10px 0; border-bottom: 1px solid #eee;">
                                    <strong>${p.key}</strong>: ${p.value} shares
                                </li>
                            </c:if>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</body>
</html>