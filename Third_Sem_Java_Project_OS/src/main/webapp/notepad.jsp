<%@ page import="java.sql.*" %>
<%@ page import="com.webos.utils.DatabaseUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Notes</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --sidebar-bg: #f2f2f7;
            --sidebar-border: #d1d1d6;
            --active-item: #ffe791; /* Apple Notes Yellow Selection */
            --text-color: #1c1c1e;
            --text-muted: #8e8e93;
            --accent-color: #e0a82e;
            --editor-bg: #ffffff;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--editor-bg);
            color: var(--text-color);
            height: 100vh;
            display: flex;
            overflow: hidden;
        }

        /* --- Sidebar (Left Panel) --- */
        .sidebar {
            width: 300px;
            background-color: var(--sidebar-bg);
            border-right: 1px solid var(--sidebar-border);
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
        }

        .sidebar-header {
            padding: 16px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .actions-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .back-btn {
            text-decoration: none;
            color: var(--accent-color);
            font-weight: 500;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .new-note-icon {
            color: var(--accent-color);
            font-size: 1.2rem;
            cursor: pointer;
        }

        /* Search Bar Simulation */
        .search-container {
            position: relative;
        }
        .search-input {
            width: 100%;
            background: #e3e3e8;
            border: none;
            border-radius: 10px;
            padding: 8px 30px;
            font-size: 0.9rem;
            color: var(--text-color);
            outline: none;
        }
        .search-icon {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 0.8rem;
        }

        /* Note List */
        .note-list {
            flex: 1;
            overflow-y: auto;
            padding: 0 10px;
        }

        .note-item {
            background: white;
            border-radius: 10px;
            padding: 12px 16px;
            margin-bottom: 8px;
            cursor: pointer;
            transition: all 0.1s;
            text-decoration: none;
            display: block;
            color: inherit;
            border: 1px solid transparent;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .note-item:hover { background: #fff; }

        .note-item.active {
            background-color: var(--active-item);
            border-color: #e6ce7e;
        }

        .note-title { font-weight: 700; font-size: 1rem; margin-bottom: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .note-preview { font-size: 0.85rem; color: var(--text-muted); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .note-date { font-size: 0.75rem; color: var(--text-muted); margin-right: 5px; }

        /* --- Editor (Right Panel) --- */
        .editor {
            flex: 1;
            display: flex;
            flex-direction: column;
            height: 100%;
            background: var(--editor-bg);
            position: relative;
        }

        .editor-toolbar {
            height: 50px;
            padding: 0 20px;
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .save-btn {
            background: none;
            border: none;
            color: var(--accent-color);
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            padding: 5px 10px;
        }
        .save-btn:hover { opacity: 0.8; }

        .editor-form {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 20px 40px;
            overflow-y: auto;
        }

        .input-title {
            font-size: 2rem;
            font-weight: 700;
            border: none;
            outline: none;
            width: 100%;
            margin-bottom: 10px;
            font-family: inherit;
        }

        .input-title::placeholder { color: #d1d1d6; }

        .date-display {
            text-align: center;
            color: var(--text-muted);
            font-size: 0.8rem;
            margin-bottom: 20px;
        }

        .input-content {
            flex: 1;
            border: none;
            outline: none;
            resize: none;
            font-size: 1.1rem;
            line-height: 1.6;
            font-family: inherit;
            color: #444;
        }

        /* Scrollbars */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-thumb { background: #d1d1d6; border-radius: 3px; }
        ::-webkit-scrollbar-track { background: transparent; }
    </style>
</head>
<body>

    <%
        // Get user session
        String user = (String) session.getAttribute("name");
        if(user == null) user = "Guest"; // Fallback to prevent crash if testing without login

        // Logic to handle "Selecting" a note
        String selectedId = request.getParameter("id");
        String currentTitle = "";
        String currentContent = "";

        // If an ID is selected, fetch that specific note to populate the form
        if(selectedId != null) {
            try (Connection conn = DatabaseUtil.getConnection()) {
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM notes WHERE id = ? AND username = ?");
                ps.setString(1, selectedId);
                ps.setString(2, user);
                ResultSet rs = ps.executeQuery();
                if(rs.next()) {
                    currentTitle = rs.getString("title");
                    currentContent = rs.getString("content");
                }
            } catch(Exception e) { e.printStackTrace(); }
        }
    %>

    <div class="sidebar">
        <div class="sidebar-header">
            <div class="actions-row">
                <a href="index.jsp" class="back-btn"><i class="fas fa-chevron-left"></i> Folders</a>
                <a href="notepad.jsp" class="new-note-icon" title="New Note"><i class="far fa-edit"></i></a>
            </div>
            <div class="search-container">
                <i class="fas fa-search search-icon"></i>
                <input type="text" class="search-input" placeholder="Search">
            </div>
        </div>

        <div class="note-list">
            <%
                try (Connection conn = DatabaseUtil.getConnection()) {
                    // I assumed there is an 'id' column. If not, you might need to rely on title only (risky)
                    PreparedStatement ps = conn.prepareStatement("SELECT * FROM notes WHERE username=? ORDER BY id DESC");
                    ps.setString(1, user);
                    ResultSet rs = ps.executeQuery();
                    while(rs.next()) {
                        String id = rs.getString("id"); // Assuming ID column exists
                        String title = rs.getString("title");
                        String isActive = (selectedId != null && selectedId.equals(id)) ? "active" : "";

                        // Create a preview snippet (first 30 chars of content)
                        String contentPreview = rs.getString("content");
                        if(contentPreview != null && contentPreview.length() > 30) {
                            contentPreview = contentPreview.substring(0, 30) + "...";
                        }
            %>
                <a href="notepad.jsp?id=<%= id %>" class="note-item <%= isActive %>">
                    <div class="note-title"><%= title %></div>
                    <div class="note-preview">
                        <span class="note-date">Today</span> <%= contentPreview %>
                    </div>
                </a>
            <%
                    }
                } catch(Exception e) {
            %>
                <div style="padding:20px; color:#999; text-align:center;">Error loading notes</div>
            <% } %>
        </div>
    </div>

    <div class="editor">
        <form action="note" method="post" class="editor-form">
            <% if(selectedId != null) { %>
                <input type="hidden" name="id" value="<%= selectedId %>">
            <% } %>

            <div class="date-display">
                <%= new java.util.Date().toString().substring(0, 10) %> at <%= new java.util.Date().toString().substring(11, 16) %>
            </div>

            <input type="text" name="title" class="input-title"
                   placeholder="New Note" value="<%= currentTitle %>" required autocomplete="off">

            <textarea name="content" class="input-content"
                      placeholder="Type your note here..."><%= currentContent %></textarea>

            <div style="position: absolute; top: 15px; right: 20px;">
                <button type="submit" class="save-btn">Done</button>
            </div>
        </form>
    </div>

</body>
</html>