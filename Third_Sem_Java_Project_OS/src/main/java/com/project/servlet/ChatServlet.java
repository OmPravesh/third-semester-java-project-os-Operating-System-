package com.project.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.project.dao.ChatRoomDAO;
import com.project.dao.MessageDAO;
import com.project.model.ChatRoom;
import com.project.model.Message;

@WebServlet(name = "ChatServlet", value = "/chat")
public class ChatServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        String roomId = request.getParameter("roomId");

        ChatRoomDAO roomDAO = ChatRoomDAO.getInstance();
        MessageDAO messageDAO = MessageDAO.getInstance();

        if ("room".equalsIgnoreCase(action) && roomId != null) {
            ChatRoom room = roomDAO.getChatRoomById(Integer.parseInt(roomId));
            List<Message> messages = messageDAO.getMessagesByRoomId(Integer.parseInt(roomId));
            request.setAttribute("room", room);
            request.setAttribute("messages", messages);
            request.getRequestDispatcher("/views/chatRoom.jsp").forward(request, response);
        } else {
            List<ChatRoom> rooms = roomDAO.getAllChatRooms();
            request.setAttribute("rooms", rooms);
            request.getRequestDispatcher("/views/chat.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        com.project.model.User user = (com.project.model.User) session.getAttribute("user");

        if ("createRoom".equalsIgnoreCase(action)) {
            String roomName = request.getParameter("roomName");
            String description = request.getParameter("description");
            ChatRoom room = new ChatRoom(roomName, user.getUsername(), description);
            ChatRoomDAO roomDAO = ChatRoomDAO.getInstance();
            roomDAO.createChatRoom(room);
            response.sendRedirect("chat");
        } else if ("sendMessage".equalsIgnoreCase(action)) {
            String roomId = request.getParameter("roomId");
            String messageContent = request.getParameter("messageContent");
            Message message = new Message(Integer.parseInt(roomId), user.getUsername(), messageContent);
            MessageDAO messageDAO = MessageDAO.getInstance();
            messageDAO.addMessage(message);
            response.sendRedirect("chat?action=room&roomId=" + roomId);
        }
    }
}
