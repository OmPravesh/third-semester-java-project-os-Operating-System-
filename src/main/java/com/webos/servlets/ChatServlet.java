package com.webos.servlets;

import com.webos.utils.DatabaseUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.Timestamp;

@WebServlet("/chat")
public class ChatServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String user = (String) session.getAttribute("name");
        String message = request.getParameter("message");

        if (user != null && message != null && !message.trim().isEmpty()) {
            try (Connection conn = DatabaseUtil.getConnection()) {
                String sql = "INSERT INTO messages (username, message) VALUES (?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, user);
                ps.setString(2, message);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        String xhr = request.getHeader("X-Requested-With");
        if (xhr != null && xhr.equalsIgnoreCase("XMLHttpRequest")) {
            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("ok");
        } else {
            response.sendRedirect("chat.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        try (Connection conn = DatabaseUtil.getConnection()) {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT username, message, timestamp FROM messages ORDER BY timestamp ASC LIMIT 200");
            StringBuilder sb = new StringBuilder();
            sb.append("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) sb.append(",");
                first = false;
                String u = rs.getString("username");
                String m = rs.getString("message");
                Timestamp t = rs.getTimestamp("timestamp");
                String ts = t != null ? String.valueOf(t.getTime()) : String.valueOf(System.currentTimeMillis());
                sb.append("{\"username\":\"")
                  .append(escape(u))
                  .append("\",\"message\":\"")
                  .append(escape(m))
                  .append("\",\"timestamp\":")
                  .append(ts)
                  .append("}");
            }
            sb.append("]");
            response.getWriter().write(sb.toString());
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }

    private String escape(String s) {
        if (s == null) return "";
        StringBuilder out = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '\"': out.append("\\\""); break;
                case '\\': out.append("\\\\"); break;
                case '\b': out.append("\\b"); break;
                case '\f': out.append("\\f"); break;
                case '\n': out.append("\\n"); break;
                case '\r': out.append("\\r"); break;
                case '\t': out.append("\\t"); break;
                default:
                    if (c < 0x20 || c > 0x7E) {
                        String hex = Integer.toHexString(c);
                        out.append("\\u");
                        for (int j = hex.length(); j < 4; j++) out.append('0');
                        out.append(hex);
                    } else {
                        out.append(c);
                    }
            }
        }
        return out.toString();
    }
}
