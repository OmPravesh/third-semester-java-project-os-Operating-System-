<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Notes App</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/views/common/navbar.jsp" />

    <div class="container">
        <div class="header-section">
            <h1><i class="fas fa-sticky-note me-2"></i>My Notes</h1>
            <button onclick="document.getElementById('newNoteModal').style.display='block'" class="btn btn-primary">
                <i class="fas fa-plus"></i> New Note
            </button>
        </div>

        <div class="grid">
            <c:forEach var="note" items="${notes}">
                <div class="card">
                    <div style="display:flex; justify-content:space-between; align-items:center;">
                        <h3>${note.title}</h3>
                        <form action="notes" method="post" style="margin:0;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${note.id}">
                            <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Delete this note?')">
                                <i class="fas fa-trash"></i>
                            </button>
                        </form>
                    </div>
                    <p>${note.content}</p>
                    <small class="text-muted">${note.createdAt}</small>
                </div>
            </c:forEach>
            <c:if test="${empty notes}">
                <div class="card full-width text-center">
                    <p>No notes found. Create one!</p>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Simple Modal -->
    <div id="newNoteModal" class="modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5);">
        <div class="modal-content" style="background:white; margin:10% auto; padding:20px; width:50%; border-radius:8px;">
            <h2>New Note</h2>
            <form action="notes" method="post">
                <input type="hidden" name="action" value="create">
                <div class="mb-3">
                    <label>Title</label>
                    <input type="text" name="title" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Content</label>
                    <textarea name="content" class="form-control" rows="5" required></textarea>
                </div>
                <button type="submit" class="btn btn-success">Save</button>
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('newNoteModal').style.display='none'">Cancel</button>
            </form>
        </div>
    </div>
</body>
</html>
