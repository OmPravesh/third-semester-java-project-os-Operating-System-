package com.project.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.project.dao.PaymentTransactionDAO;
import com.project.dao.UserDAO;
import com.project.model.PaymentTransaction;
import com.project.model.User;

@WebServlet(name = "DigitalPaymentServlet", value = "/digital-payment")
public class DigitalPaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        PaymentTransactionDAO transDAO = PaymentTransactionDAO.getInstance();

        if ("history".equalsIgnoreCase(action)) {
            List<PaymentTransaction> transactions = transDAO.getTransactionsByUsername(user.getUsername());
            request.setAttribute("transactions", transactions);
            request.getRequestDispatcher("/views/paymentHistory.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/views/digitalPayment.jsp").forward(request, response);
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

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String paymentMethod = request.getParameter("paymentMethod");

        PaymentTransactionDAO transDAO = PaymentTransactionDAO.getInstance();
        UserDAO userDAO = UserDAO.getInstance();

        if ("deposit".equalsIgnoreCase(action)) {
            // Add to balance
            user.setBalance(user.getBalance() + amount);
            userDAO.updateUser(user);

            PaymentTransaction trans = new PaymentTransaction(user.getUsername(), "Deposit", amount, paymentMethod, "Completed");
            trans.setDescription("Deposit to wallet");
            transDAO.addTransaction(trans);

            // Update session
            session.setAttribute("user", user);
            response.sendRedirect("digital-payment?action=history");

        } else if ("withdraw".equalsIgnoreCase(action)) {
            if (user.getBalance() >= amount) {
                // Deduct from balance
                user.setBalance(user.getBalance() - amount);
                userDAO.updateUser(user);

                PaymentTransaction trans = new PaymentTransaction(user.getUsername(), "Withdrawal", amount, paymentMethod, "Completed");
                trans.setDescription("Withdrawal from wallet");
                transDAO.addTransaction(trans);

                // Update session
                session.setAttribute("user", user);
                response.sendRedirect("digital-payment?action=history");
            } else {
                request.setAttribute("error", "Insufficient balance");
                request.getRequestDispatcher("/views/digitalPayment.jsp").forward(request, response);
            }
        } else if ("transfer".equalsIgnoreCase(action)) {
            String recipient = request.getParameter("recipient");
            User recipientUser = userDAO.getUserByUsername(recipient);

            if (recipientUser == null) {
                request.setAttribute("error", "Recipient not found");
                request.getRequestDispatcher("/views/digitalPayment.jsp").forward(request, response);
            } else if (user.getBalance() < amount) {
                request.setAttribute("error", "Insufficient balance");
                request.getRequestDispatcher("/views/digitalPayment.jsp").forward(request, response);
            } else {
                // Deduct from sender
                user.setBalance(user.getBalance() - amount);
                userDAO.updateUser(user);

                // Add to recipient
                recipientUser.setBalance(recipientUser.getBalance() + amount);
                userDAO.updateUser(recipientUser);

                // Record transactions
                PaymentTransaction senderTrans = new PaymentTransaction(user.getUsername(), "Transfer", amount, "Wallet Transfer", "Completed");
                senderTrans.setDescription("Transfer to " + recipient);
                transDAO.addTransaction(senderTrans);

                PaymentTransaction recipientTrans = new PaymentTransaction(recipient, "Transfer", amount, "Wallet Transfer", "Completed");
                recipientTrans.setDescription("Transfer from " + user.getUsername());
                transDAO.addTransaction(recipientTrans);

                // Update session
                session.setAttribute("user", user);
                response.sendRedirect("digital-payment?action=history");
            }
        }
    }
}
