# WebOs — Java Servlet/JSP “Web OS” 

WebOs is a browser-based “desktop OS” built with Java Servlet/JSP. It simulates an operating system experience with apps like Wallet, Chat, Notepad, Calculator, Games, and a Live Stocks dashboard. The project demonstrates end‑to‑end Java web development: authentication, JDBC data access, servlet controllers, JSP views, UI theming, and real-time UI behaviors.

## Overview
- Desktop-like home with app icons, taskbar, search, and live clock
- Persistent theme manager applied across pages
- Feature apps:
  - Wallet transfers with transaction logging
  - Registration and session-based login
  - WhatsApp-like Chat UI with live updates
  - Notepad CRUD
  - Calculator with safe expression parser
  - Snake game with smooth animation
  - Live Stocks chart with random-walk simulation

## Architecture
- Servlet controllers handle routes and server actions
- JSP pages render UI and call controllers
- JDBC is used directly for data access
- Session-based authentication and filter-based route protection
- Local settings persisted via `localStorage` and applied as CSS variables

Key references:
- DB connection helper: `src/main/java/com/webos/utils/DatabaseUtil.java:6-21`
- Auth filter: `src/main/java/com/uniquedeveloper/registration/AuthFilter.java:10-37`
- Login servlet: `src/main/java/com/uniquedeveloper/registration/Login.java:10-58`
- Registration servlet: `src/main/java/com/webos/servlets/RegistrationServlet.java:11-59`
- Wallet servlet: `src/main/java/com/webos/servlets/WalletServlet.java:12-30`
- Note servlet: `src/main/java/com/webos/servlets/NoteServlet.java:12-33`
- Chat servlet: `src/main/java/com/webos/servlets/ChatServlet.java:15-35,36-113`

## Prerequisites
- Java: JDK 17+ recommended (Servlet 4.0 compatible). Works on newer Java (Jetty 11 supports 11+; Tomcat 9/10 supports 8+/11+)
- Maven: 3.9.x
- MySQL: 8.x
- A servlet container:
  - Tomcat 9/10 (recommended for annotation-based servlets)
  - Jetty 11 (Java 11+; Java 23 compatible)

## Database Setup
Create a database (default name `project`) and tables:
- `users` — columns: `id` INT PK, `username` VARCHAR(50), `password` VARCHAR(255), `balance` DOUBLE, `email` VARCHAR(100), `phone` VARCHAR(20)
- `messages` — columns: `id` INT PK, `username` VARCHAR(50), `message` TEXT, `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
- `notes` — columns: `id` INT PK, `username` VARCHAR(50), `title` VARCHAR(200), `content` TEXT, `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
- `transactions` — columns: `id` INT PK, `sender` VARCHAR(50), `recipient` VARCHAR(50), `amount` DOUBLE, `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP

Update DB credentials:
- Edit `src/main/java/com/webos/utils/DatabaseUtil.java:6-8` (`DB_URL`, `DB_USER`, `DB_PASS`) to match your environment
- `Login.java` uses a separate connection URL (`jdbc:mysql://localhost:3306/youtube`) — align it with the same schema or update to `project`

## Run Locally
Build:
- `mvn clean package -DskipTests`

Deploy options:
- Tomcat 9/10:
  - Copy `target/WebOs.war` to `tomcat/webapps/`
  - Start Tomcat and open `http://localhost:8080/WebOs/`
- Jetty 11:
  - Start Jetty and deploy the WAR via `webapps` directory or `jetty-deploy`
  - Open `http://localhost:8080/WebOs/`

Development server (Tomcat Maven plugin):
- The project includes `tomcat7-maven-plugin` in `pom.xml`. For Servlet 4.0 features, prefer Tomcat 9/10 or Jetty 11. Consider upgrading the plugin or deploy the WAR to an external container.

## Features
- Wallet transfers with transaction logging (`DatabaseUtil.transferFunds`): `src/main/java/com/webos/utils/DatabaseUtil.java:24-60`
- Registration with validation and default balance: `src/main/java/com/webos/servlets/RegistrationServlet.java:24-59`
- Login with session and filter-driven protection: `src/main/java/com/uniquedeveloper/registration/Login.java:10-58`, `AuthFilter.java:10-37`
- Chat with WhatsApp-style UI and AJAX updates:
  - UI: `src/main/webapp/chat.jsp`
  - JSON feed & AJAX post: `src/main/java/com/webos/servlets/ChatServlet.java:36-113`
- Notepad: `src/main/webapp/notepad.jsp`, `NoteServlet.java:12-33`
- Calculator:
  - Safe evaluator (no `eval`), keyboard support, history, memory: `src/main/webapp/calculator.jsp`
- Snake game:
  - Interpolated movement, D-pad, wrap toggle, audio feedback: `src/main/webapp/game.jsp`
- Live Stocks dashboard:
  - Multiple companies, random-walk pricing, rescaled chart window: `src/main/webapp/stock.jsp`
- Theme Manager:
  - Global CSS variables, settings persistence: `src/main/webapp/settings.jsp`, applied in `index.jsp` and app pages

## Project Structure
- `src/main/java` — servlets, filters, utilities
- `src/main/webapp` — JSPs, assets, CSS/JS, `WEB-INF/web.xml`
- `pom.xml` — dependencies and build
- `target` — compiled classes and WAR

## Team & Contributions
- Team Admin: Om Pravesh
  - Overall system architecture design
  - Database schema and JDBC implementation
  - Payment system with transaction management
  - Servlet/JSP (Java EE) controllers and flows
  - Theme Manager and UI consistency
  - Integration testing and bug fixes
- Team Member: Diya
  - Desktop UI polishing (home, taskbar, search)
  - Calculator redesign and safe parser implementation
  - Accessibility review and keyboard navigation across apps
- Team Member: Urvi
  - Chat UI (WhatsApp-like) and AJAX integration
  - Snake game animation and controls
  - Settings page with theme persistence and accent presets
  - Stocks dashboard simulation and chart stabilization
  - Error handling improvements and JSP compilation fixes

## Educational Value
- Teaches core Java web app skills: Servlets, JSP, filters, sessions
- Demonstrates direct JDBC usage with transactions and rollback
- Shows how to structure UI state with CSS variables and `localStorage`
- Highlights client/server integration: AJAX endpoints, JSON, and polling
- Illustrates testing strategies and iterative UI refinement

## Quality & Execution
- Request/response flows are explicit and easy to trace
- App-specific controllers follow single-responsibility patterns
- UI keeps consistent visual design via the Theme Manager
- Chat/Stocks demonstrate real-time UI patterns (polling, sliding windows)

## Innovation / Extra Effort
- WhatsApp-like chat experience built on simple servlet back end
- Live market simulation with Gaussian noise, dynamic rescaling
- Snake with interpolated movement and audio feedback for events
- Calculator with safe evaluation (shunting-yard parsing)

## Servlet Implementation
- Controller mapping via `@WebServlet` annotations:
  - `RegisterServlet` (`/register`)
  - `WalletServlet` (`/wallet`)
  - `ChatServlet` (`/chat`)
  - `NoteServlet` (`/note`)
- Filter-based route guarding:
  - `AuthFilter` redirects unauthenticated users to `login.jsp`

## Setup Notes
- Align database connections:
  - `Login.java` uses `jdbc:mysql://localhost:3306/youtube` — standardize to the same DB as other modules
- Avoid hardcoded credentials in production; externalize them via env vars or properties

## How To Run “OS” In Browser
- Build and deploy WAR to Tomcat/Jetty (see Run Locally)
- Visit `http://localhost:8080/WebOs/`
- Register a user (`registration.jsp`) and log in (`login.jsp`)
- Explore apps from `index.jsp` desktop

## Testing
- Manual integration testing across flows (register → login → wallet → chat)
- Verify database inserts and transactions for wallet and notes
- Check UI theming propagation from Settings to app pages

## Troubleshooting
- HTTP 500 on JSP:
  - Avoid `${...}` inside JS template strings in JSP; use string concatenation
- Missing `timestamp` in `messages`:
  - Add `timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP`
- Container mismatch:
  - For Servlet 4.0 and annotations, use Tomcat 9/10 or Jetty 11

## License
MIT (or your chosen license)
