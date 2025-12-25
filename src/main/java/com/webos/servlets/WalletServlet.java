package com.webos.servlets;

import com.webos.utils.DatabaseUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/wallet")
public class WalletServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String sender = (String) session.getAttribute("name"); // "name" comes from Login.java session
        String recipient = request.getParameter("recipient");
        double amount = Double.parseDouble(request.getParameter("amount"));

        if (sender != null) {
            boolean success = DatabaseUtil.transferFunds(sender, recipient, amount);
            if (success) {
                request.setAttribute("status", "success");
            } else {
                request.setAttribute("status", "failed");
            }
        }
        request.getRequestDispatcher("wallet.jsp").forward(request, response);
    }
}