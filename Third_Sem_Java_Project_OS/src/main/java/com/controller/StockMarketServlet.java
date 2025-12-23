package com.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.project.dao.UserDAO;
import com.project.model.User;

@WebServlet("/stockMarket")
public class StockMarketServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(StockMarketServlet.class.getName());
    
    // Simulating stock prices in memory
    private static final Map<String, Double> stockPrices = new HashMap<>();
    
    static {
        stockPrices.put("GOOGL", 2800.00);
        stockPrices.put("AAPL", 150.00);
        stockPrices.put("TSLA", 700.00);
        stockPrices.put("AMZN", 3300.00);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Randomly fluctuate prices slightly on every refresh
        fluctuatePrices();
        req.setAttribute("stocks", stockPrices);
        req.getRequestDispatcher("/views/stock.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        String username = user.getUsername();

        String action = req.getParameter("action");
        String symbol = req.getParameter("symbol");
        int quantity = Integer.parseInt(req.getParameter("quantity"));
        double price = stockPrices.getOrDefault(symbol, 0.0);
        double totalCost = price * quantity;

        // Simple Portfolio stored in Session for demo
        @SuppressWarnings("unchecked")
        Map<String, Integer> portfolio = (Map<String, Integer>) session.getAttribute("portfolio");
        if (portfolio == null) portfolio = new HashMap<>();

        UserDAO userDAO = UserDAO.getInstance();
        user = userDAO.getUserByUsername(username);

        if (user == null) {
            req.setAttribute("error", "User not found");
        } else {
            if ("buy".equals(action)) {
                if (user.getBalance() >= totalCost) {
                    user.setBalance(user.getBalance() - totalCost);
                    userDAO.updateUserBalance(username, user.getBalance());
                    portfolio.put(symbol, portfolio.getOrDefault(symbol, 0) + quantity);
                    LOGGER.info("Bought " + quantity + " of " + symbol + " for user: " + username);
                    req.setAttribute("message", "Bought " + quantity + " of " + symbol);
                } else {
                    req.setAttribute("error", "Insufficient Funds!");
                }
            } else if ("sell".equals(action)) {
                int currentQty = portfolio.getOrDefault(symbol, 0);
                if (currentQty >= quantity) {
                    user.setBalance(user.getBalance() + totalCost);
                    userDAO.updateUserBalance(username, user.getBalance());
                    portfolio.put(symbol, currentQty - quantity);
                    LOGGER.info("Sold " + quantity + " of " + symbol + " for user: " + username);
                    req.setAttribute("message", "Sold " + quantity + " of " + symbol);
                } else {
                    req.setAttribute("error", "Not enough shares to sell!");
                }
            }

            session.setAttribute("portfolio", portfolio);
        }

        doGet(req, resp); // Refresh page
    }

    private void fluctuatePrices() {
        Random rand = new Random();
        for (String key : stockPrices.keySet()) {
            double change = (rand.nextDouble() - 0.5) * 5; // +/- $2.5
            double newPrice = Math.max(1.0, stockPrices.get(key) + change);
            stockPrices.put(key, Math.round(newPrice * 100.0) / 100.0);
        }
    }
}