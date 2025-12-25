package com.uniquedeveloper.registration;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String ctx = req.getContextPath();
        String uri = req.getRequestURI();

        boolean loggedIn = session != null && session.getAttribute("name") != null;
        boolean isLogin = uri.equals(ctx + "/login.jsp") || uri.equals(ctx + "/Login");
        boolean isRegister = uri.equals(ctx + "/registration.jsp") || uri.equals(ctx + "/register");
        boolean isLogout = uri.equals(ctx + "/logout");
        boolean isStatic = uri.startsWith(ctx + "/css")
                || uri.startsWith(ctx + "/js")
                || uri.startsWith(ctx + "/images")
                || uri.startsWith(ctx + "/fonts")
                || uri.startsWith(ctx + "/assets")
                || uri.endsWith(".ico");

        if (loggedIn || isLogin || isRegister || isLogout || isStatic) {
            chain.doFilter(request, response);
        } else {
            resp.sendRedirect(ctx + "/login.jsp");
        }
    }
}
