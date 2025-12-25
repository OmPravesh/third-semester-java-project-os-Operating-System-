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

@WebServlet("/note")
public class NoteServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String user = (String) session.getAttribute("name");
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "INSERT INTO notes (username, title, content) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user);
            ps.setString(2, title);
            ps.setString(3, content);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }

        response.sendRedirect("notepad.jsp");
    }
}