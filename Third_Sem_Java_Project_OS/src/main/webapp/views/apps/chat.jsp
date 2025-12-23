<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Team Chat</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script>
        // Auto-refresh chat every 3 seconds
        setInterval(function() {
            location.reload(); 
        }, 5000); 
    </script>
</head>
<body>
    <jsp:include page="/views/common/navbar.jsp" />
    
    <div class="container">
        <div class="card" style="max-width: 600px; margin: 0 auto; height: 80vh; display: flex; flex-direction: column;">
            <div class="card-header border-bottom">
                <h3>💬 Global Chat</h3>
            </div>
            
            <div class="chat-box" style="flex: 1; overflow-y: auto; padding: 15px; background: #f8f9fa;">
                <c:forEach var="msg" items="${chatMessages}">
                    <div style="background: white; padding: 8px 12px; border-radius: 8px; margin-bottom: 8px; box-shadow: 0 1px 2px rgba(0,0,0,0.1);">
                        ${msg}
                    </div>
                </c:forEach>
            </div>
            
            <div class="card-footer" style="padding: 15px; border-top: 1px solid #eee;">
                <form action="chat" method="post" style="display: flex; gap: 10px;">
                    <input type="text" name="message" class="form-control" placeholder="Type a message..." style="flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 4px;" required autofocus>
                    <button type="submit" class="btn btn-primary">Send</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>