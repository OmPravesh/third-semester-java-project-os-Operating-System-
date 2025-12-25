# WebOS - Java Servlet/JSP Web Operating System

WebOS is a browser-based desktop environment built with Java Servlet and JSP technologies. It simulates an operating system experience with applications including Wallet, Chat, Notepad, Calculator, Games, and a Live Stocks dashboard. The project demonstrates end-to-end Java web development including authentication, JDBC data access, servlet controllers, JSP views, UI theming, and real-time UI behaviors.

<div align="center">

## Core Screens

<table>
  <tr>
    <td align="center">
      <img src="./images/Browser.png" width="400" alt="Browser"><br>
      <b>Custom Browser</b>
    </td>
    <td align="center">
      <img src="./images/Dashboard.png" width="400" alt="Dashboard"><br>
      <b>Main Dashboard</b>
    </td>
  </tr>
</table>

## Authentication

<table>
  <tr>
    <td align="center">
      <img src="./images/Login.png" width="400" alt="Login"><br>
      <b>Login Page</b>
    </td>
    <td align="center">
      <img src="./images/settings.png" width="400" alt="Settings"><br>
      <b>Settings Panel</b>
    </td>
  </tr>
</table>

## Applications

<table>
  <tr>
    <td align="center">
      <img src="./images/calculator.png" width="400" alt="Calculator"><br>
      <b>Calculator App</b>
    </td>
    <td align="center">
      <img src="./images/chatapp.png" width="400" alt="Chat App"><br>
      <b>Chat Application</b>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="./images/notes.png" width="400" alt="Notes"><br>
      <b>Notes App</b>
    </td>
    <td align="center">
      <img src="./images/Paymentapp.png" width="400" alt="Payment App"><br>
      <b>Payment Application</b>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="./images/stockapp.png" width="400" alt="Stock App"><br>
      <b>Stock Market App</b>
    </td>
    <td align="center">
      <img src="./images/games.png" width="400" alt="Games Hub"><br>
      <b>Games Center</b>
    </td>
  </tr>
</table>

## Games

<table>
  <tr>
    <td align="center">
      <img src="./images/snake.png" width="400" alt="Snake Game"><br>
      <b>Snake Game</b>
    </td>
    <td align="center">
      <img src="./images/typing.png" width="400" alt="Typing Game"><br>
      <b>Typing Speed Game</b>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="./images/doom3d.png" width="400" alt="3D Shooter"><br>
      <b>3D FPS Game</b>
    </td>
  </tr>
</table>

</div>


## Features

- **Desktop Interface**: Home screen with app icons, taskbar, search functionality, and live clock
- **Theme Management**: Persistent theme settings applied across all pages
- **Application Suite**:
  - **Wallet**: Transfer funds with transaction logging
  - **Authentication**: Registration and session-based login system
  - **Chat**: WhatsApp-like interface with live message updates
  - **Notepad**: CRUD operations for notes
  - **Calculator**: Safe expression parser with keyboard support
  - **Snake Game**: Smooth animation with audio feedback
  - **Stocks Dashboard**: Live chart with random-walk simulation

## Architecture

- **Frontend**: JSP pages with CSS/JavaScript
- **Backend**: Java Servlets handling routes and business logic
- **Data Layer**: Direct JDBC for database operations
- **Security**: Session-based authentication with filter-based route protection
- **Client Storage**: Local settings persisted via `localStorage` and applied as CSS variables

## Prerequisites

- **Java**: JDK 17+ (Servlet 4.0 compatible)
- **Build Tool**: Maven 3.9.x
- **Database**: MySQL 8.x
- **Servlet Container** (choose one):
  - Tomcat 9/10 (recommended for annotation-based servlets)
  - Jetty 11 (Java 11+ compatible)

## Database Setup

1. Create a MySQL database named `project` (or use your preferred name)
2. Execute the following SQL statements:

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    balance DOUBLE DEFAULT 0.0,
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    sender VARCHAR(50) NOT NULL,
    recipient VARCHAR(50) NOT NULL,
    amount DOUBLE NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

3. Update database credentials in the project:
   - Edit `src/main/java/com/webos/utils/DatabaseUtil.java` lines 6-8 to match your database configuration
   - Ensure `src/main/java/com/uniquedeveloper/registration/Login.java` uses the correct database URL (standardize to use the same database as other modules)

## Installation and Deployment

### Build the Project

```bash
mvn clean package -DskipTests
```

### Deploy to Tomcat

1. Copy the generated `target/WebOs.war` file to your Tomcat `webapps/` directory
2. Start Tomcat server
3. Access the application at `http://localhost:8080/WebOs/`

### Deploy to Jetty

1. Copy the WAR file to Jetty's `webapps/` directory
2. Start Jetty server
3. Access the application at `http://localhost:8080/WebOs/`

## Project Structure

```
WebOS/
├── pom.xml
├── README.md
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       ├── uniquedeveloper/
│       │       │   └── registration/
│       │       │       ├── AuthFilter.java
│       │       │       ├── Login.java
│       │       │       └── Logout.java
│       │       └── webos/
│       │           ├── servlets/
│       │           │   ├── ChatServlet.java
│       │           │   ├── NoteServlet.java
│       │           │   ├── RegistrationServlet.java
│       │           │   └── WalletServlet.java
│       │           └── utils/
│       │               └── DatabaseUtil.java
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml
│           ├── index.jsp
│           ├── login.jsp
│           ├── registration.jsp
│           ├── settings.jsp
│           ├── wallet.jsp
│           ├── notepad.jsp
│           ├── chat.jsp
│           ├── calculator.jsp
│           ├── game.jsp
│           ├── stock.jsp
│           ├── assets/
│           │   └── img/
│           ├── css/
│           │   ├── index-styles.css
│           │   └── style.css
│           ├── js/
│           │   ├── main.js
│           │   └── scripts.js
│           ├── fonts/
│           ├── images/
│           └── scss/
└── target/
    └── WebOs.war
```

## Key Components

### Database Utility
- Location: `src/main/java/com/webos/utils/DatabaseUtil.java`
- Handles database connections and fund transfer operations with transaction support

### Authentication System
- **Login Servlet**: `src/main/java/com/uniquedeveloper/registration/Login.java`
- **Auth Filter**: `src/main/java/com/uniquedeveloper/registration/AuthFilter.java`
- **Registration**: `src/main/java/com/webos/servlets/RegistrationServlet.java`

### Application Servlets
- **Wallet**: `src/main/java/com/webos/servlets/WalletServlet.java`
- **Notes**: `src/main/java/com/webos/servlets/NoteServlet.java`
- **Chat**: `src/main/java/com/webos/servlets/ChatServlet.java`

## Getting Started

1. Deploy the application to your servlet container
2. Access the application in your browser
3. Register a new user account
4. Log in with your credentials
5. Explore the desktop interface and applications

## Technical Implementation Details

### Servlet Configuration
Controllers are mapped using `@WebServlet` annotations:
- Registration: `@WebServlet("/register")`
- Wallet: `@WebServlet("/wallet")`
- Chat: `@WebServlet("/chat")`
- Notes: `@WebServlet("/note")`

### Security
- Route protection implemented via `AuthFilter`
- Unauthenticated users are redirected to login page
- Session-based user state management

### Real-time Features
- Chat uses AJAX polling for message updates
- Stocks dashboard simulates live data with random-walk algorithm
- Theme changes are immediately reflected across all open applications

## Development Notes

### Database Connection Standardization
- Ensure all database connections use the same database URL
- Update the connection string in `Login.java` if it differs from `DatabaseUtil.java`

### Production Considerations
- Externalize database credentials to environment variables or configuration files
- Implement proper error handling and logging
- Consider connection pooling for production deployment

## Troubleshooting

### Common Issues

1. **HTTP 500 Error on JSP Pages**
   - Avoid using `${...}` expressions inside JavaScript template strings in JSP files
   - Use string concatenation instead

2. **Missing Timestamp Columns**
   - Ensure all timestamp columns have proper DEFAULT values in database schema

3. **Servlet Container Compatibility**
   - For Servlet 4.0 features, use Tomcat 9/10 or Jetty 11
   - Update Maven plugin configuration if using embedded containers

4. **Database Connection Errors**
   - Verify MySQL service is running
   - Check database credentials in `DatabaseUtil.java`
   - Ensure database schema matches expected structure

## Educational Value

This project demonstrates:
- Core Java web application development with Servlets and JSP
- Direct JDBC usage with transaction management
- Client/server integration patterns (AJAX, JSON, polling)
- UI state management with CSS variables and localStorage
- Software engineering principles and testing strategies

## Team Contributions

- **Om Pravesh**: System architecture, database design, payment system, servlet controllers, theme manager, integration testing
- **Diya**: Desktop UI polishing, calculator redesign, accessibility improvements, keyboard navigation
- **Urvi**: Chat UI implementation, game development, theme persistence, stocks dashboard, error handling

## License and Acknowledgments

This project was developed as part of an academic curriculum to demonstrate comprehensive Java programming skills, database integration, and software engineering principles.
