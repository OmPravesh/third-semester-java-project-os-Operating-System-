package com.project.servlet;

import com.project.dao.NotesDAO;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotesServlet", value = "/notes")
public class NotesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        NotesDAO dao = NotesDAO.getInstance();
        List<NotesDAO.Note> notes = dao.getNotesByUsername(user.getUsername());
        
        request.setAttribute("notes", notes);
        request.getRequestDispatcher("/views/notes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        NotesDAO dao = NotesDAO.getInstance();

        if ("create".equals(action)) {
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            dao.addNote(user.getUsername(), title, content);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteNote(id, user.getUsername());
        }

        response.sendRedirect("notes");
    }
}
