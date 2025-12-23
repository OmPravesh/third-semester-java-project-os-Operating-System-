<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Settings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <jsp:include page="/views/common/navbar.jsp" />
    <div class="container">
        <div class="card">
            <h3>⚙️ Application Settings</h3>
            <form action="updateSettings" method="post">
                <div class="form-group mt-2">
                    <label><strong>Theme Preference</strong></label><br>
                    <label><input type="radio" name="theme" value="light" checked> Light Mode</label>
                    <label class="ml-2"><input type="radio" name="theme" value="dark"> Dark Mode (Beta)</label>
                </div>
                
                <div class="form-group mt-2">
                    <label><strong>Notifications</strong></label><br>
                    <label><input type="checkbox" name="email_notif" checked> Email Notifications</label><br>
                    <label><input type="checkbox" name="sound" checked> Game Sounds</label>
                </div>

                <div class="form-group mt-2">
                    <label><strong>Account</strong></label><br>
                    <button type="button" class="btn btn-danger">Reset Game Progress</button>
                </div>

                <button type="submit" class="btn btn-primary mt-2">Save Changes</button>
            </form>
        </div>
    </div>
</body>
</html>