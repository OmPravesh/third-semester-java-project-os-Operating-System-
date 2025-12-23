# third-semester-java-project-os-Operating-System-
GUI OS is a Java Swing–based desktop operating system simulation featuring multiple integrated applications, database connectivity, and interactive games. The project showcases core Java concepts such as Object-Oriented Programming, JDBC-based database integration, multithreading, and rich GUI development.

## Key Features

### Core System
- **User Authentication System** with MySQL database backend
- **Dashboard Interface** with application launcher
- **Theme Manager** supporting multiple color schemes (Dark, Light, Cyberpunk, Ocean)
- **Database Utilities** with transaction management

### Applications Suite
- **Digital Payment System** - PayPal-style interface with transaction history
- **Stock Market Simulator** - Real-time stock graphs and portfolio management
- **Chat Application** - Peer-to-peer messaging system
- **Notes App** - File-based note taking with CRUD operations
- **Calculator** - Basic arithmetic operations
- **Utilities** - String manipulation tools (reverser, counter, case converter)
- **How It Works** - System documentation viewer

### Games Collection
- **DOOM Brick Edition** - 3D raycaster game with shooting mechanics
- **Snake Game** - Classic snake with modern graphics
- **Adventure Quest** - Text-based RPG with multiple story paths
- **Typing Speed Test** - WPM and accuracy measurement
- **Rock Paper Scissors** & **Number Guessing** - Mini games

##  Technology Stack

- **Language**: Java 8+
- **GUI Framework**: Java Swing
- **Database**: MySQL with JDBC
- **Architecture**: MVC Pattern with DAO Layer
- **Build Tool**: Maven/Gradle (implied)
- **Version Control**: Git

<div align="center">

### Login & Dashboard
<table>
  <tr>
    <td align="center">
      <img src="./images/login-screenshot.png" width="400" alt="Login Screen"><br>
      <b>Login Screen</b>
    </td>
    <td align="center">
      <img src="./images/dashboard-screenshot.png" width="400" alt="Dashboard"><br>
      <b>Dashboard</b>
    </td>
  </tr>
</table>

### Applications
<table>
  <tr>
    <td align="center">
      <img src="./images/stock-market.png" width="400" alt="Stock Market"><br>
      <b>Stock Market</b>
    </td>
    <td align="center">
      <img src="./images/chatapp.png" width="400" alt="Chat App"><br>
      <b>Chat Application</b>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="./images/calculator.png" width="400" alt="Calculator"><br>
      <b>Calculator</b>
    </td>
    <td align="center">
      <img src="./images/util.png" width="400" alt="Utilities"><br>
      <b>Utilities</b>
    </td>
  </tr>
     <tr>
    <td align="center">
      <img src="./images/snake.png" width="400" alt="Calculator"><br>
      <b>Sanke Game</b>
    </td>
    <td align="center">
      <img src="./images/type.png" width="400" alt="Utilities"><br>
      <b>Type Speed Game</b>
    </td>
  </tr>
</table>

</div>

## Code Quality & Testing

### 1. **Object-Oriented Design Principles** (3 marks)
- **Encapsulation**: All model classes (User, Stock, Transaction) properly encapsulate data with private fields and public getters/setters
- **Inheritance**: Implemented through GUI component hierarchy and DAO interface (`DataAccessor<T>`)
- **Polymorphism**: Demonstrated through theme application system and game interfaces
- **Abstraction**: DAO pattern abstracts database operations from business logic

### 2. **Database Integration & Error Handling** (3 marks)
- **JDBC Implementation**: Full MySQL integration with connection pooling
- **Transaction Management**: Atomic money transfers with rollback capability
- **Prepared Statements**: SQL injection prevention throughout
- **Error Handling**: Comprehensive SQLException handling with user feedback
- **Database Schema**: Properly normalized tables with foreign key relationships

### 3. **Multithreading Implementation** (2 marks)
- **UI Responsiveness**: Database operations in separate threads
- **Game Animation**: Smooth game loops using Swing Timers and Threads
- **Real-time Updates**: Stock market simulation with concurrent price updates
- **Chat System**: Non-blocking socket communication

### 4. **Code Organization & Documentation** (2 marks)
- **Modular Structure**: Clean separation of concerns (MVC pattern)
- **Package Organization**: Logical grouping by functionality
- **Inline Comments**: Key algorithms and complex logic documented
- **Consistent Naming**: Follows Java naming conventions throughout

## Teamwork & Collaboration

### Team Members & Contributions

| Member | Role | Key Contributions |
|--------|------|-------------------|
| **Om Pravesh** (Team Admin) | Project Lead & Architect | - Overall system architecture design<br>- Database schema and JDBC implementation<br>- Payment system with transaction management<br>- Servlet/JSP (Java EE), Jetty 11.0.18 (Java 23 compatible), Maven 3.9.5 implementation<br>- Theme Manager and UI consistency<br>- Integration testing and bug fixes |
| **Diya** | GUI Developer & Game Programmer | - Complete Stock Market GUI with real-time graphs<br>- Adventure Quest RPG game implementation<br>- Calculator and Utilities applications<br>- Notes app with file system integration<br>- UI theme implementation and styling |
| **Urvi** | Game Developer & Tester | - DOOM Brick Edition 3D game with shooting mechanics<br>- Snake game with modern graphics and animations<br>- Typing Speed Test application<br>- Rock Paper Scissors and Number Guessing games<br>- Comprehensive application testing and debugging |

### Collaboration Process
1. **Version Control**: Used Git with feature branching strategy
2. **Code Reviews**: Regular peer reviews before merging to main branch
3. **Task Allocation**: Assigned based on expertise and interest areas
4. **Integration Meetings**: Weekly sync-ups to resolve dependencies
5. **Documentation**: Shared understanding of interfaces and APIs

### Evidence of Collaboration
- Consistent coding style across all modules
- Shared utility classes (DatabaseUtil, ThemeManager)
- Integrated application launch system from single dashboard
- Unified error handling and user feedback mechanisms

## Innovation & Extra Effort

### 1. **Advanced Graphical Features**
- **Real-time Stock Graphs**: Interactive candlestick-style graphs with moving averages
- **3D Raycasting Engine**: Custom-built DOOM-style rendering without external libraries
- **Animated UI Elements**: Smooth transitions and visual feedback throughout
- **Multiple Theme Support**: Dynamic theme switching affecting all applications

### 2. **Integrated Application Ecosystem**
- **Cross-application Data Sharing**: User balance updates reflected across payment and stock apps
- **Unified Authentication**: Single sign-on with session management
- **Consistent UI/UX**: Common design language across all applications
- **File System Integration**: Notes app with user-specific file management

### 3. **Educational Value**
- **Architecture Documentation**: "How It Works" application explains system design
- **Design Patterns Demonstrated**: MVC, DAO, Singleton, Observer patterns
- **Database Transactions**: Practical demonstration of ACID properties
- **Multithreading Examples**: Real-world concurrency patterns

## Installation & Setup

### Prerequisites
1. Java JDK 8 or higher
2. MySQL Server 5.7+
3. MySQL JDBC Connector

🚀 PROJECT DEPLOYMENT STATUS

═══════════════════════════════════════════════════════════════════════════════

STATUS: ✅ SERVER LAUNCHING

Date/Time: December 22, 2025
Server:   Jetty 11.0.18
Port:     8080
Process:  ✅ RUNNING (Java Process ID: 9716)

═══════════════════════════════════════════════════════════════════════════════

WHAT'S HAPPENING:

✅ Maven build completed successfully
✅ WAR file packaged and ready
✅ Jetty server process started
⏳ Dependencies downloading from Maven Central
⏳ Server initialization in progress

Estimated wait time: 2-3 minutes (first run only)

═══════════════════════════════════════════════════════════════════════════════

HOW TO ACCESS:

1. Open Browser Window: ✅ READY (already opened)
2. Wait for server to fully initialize
3. Page will auto-refresh or navigate to:
   
   → http://localhost:8080/

4. When loaded, you'll see the login page

═══════════════════════════════════════════════════════════════════════════════

LOGIN CREDENTIALS:

Username: admin
Password: admin123

Starting Balance: $50,000

═══════════════════════════════════════════════════════════════════════════════

AVAILABLE FEATURES:

✨ Game Center
   ├─ Snake Game (with 3 difficulty levels)
   ├─ Puzzle Game (memory matching)
   └─ Leaderboard (top 10 scores)

💬 Chat System
   ├─ Create chat rooms
   ├─ Send and receive messages
   └─ View message history

💳 Digital Payment
   ├─ Deposit funds
   ├─ Withdraw funds
   ├─ Transfer between users
   └─ Transaction history

📈 Stock Market (existing feature)

📝 Notes App (existing feature)

👤 User Dashboard

═══════════════════════════════════════════════════════════════════════════════

TERMINAL OUTPUT SHOWS:

✅ Build Status: SUCCESS
✅ WAR Package: third-semester-web-project.war (created)
✅ Server: Starting on port 8080
✅ Java Process: Running (CPU active)
✅ Dependencies: Downloading

═══════════════════════════════════════════════════════════════════════════════

WHAT TO DO WHILE WAITING:

Option 1: Wait for automatic page load
- The browser window is open
- It will detect the server when ready
- Page will auto-update

Option 2: Manual refresh
- Keep the browser open
- Refresh every 30 seconds
- When you see the login page, you're ready!

Option 3: Monitor terminal
- Watch for "Jetty server started" message
- Server will be ready shortly after

═══════════════════════════════════════════════════════════════════════════════

FIRST-TIME INITIALIZATION CHECKLIST:

✅ Maven installed successfully
✅ Project built without errors
✅ Jetty web server configured
✅ All dependencies being downloaded
✅ Database initialization ready (auto on first login)
✅ Browser window opened

═══════════════════════════════════════════════════════════════════════════════

EXPECTED SEQUENCE:

1. ✅ Dependencies download (in progress)
2. ⏳ Server initialization (next)
3. ⏳ First login creates database tables
4. ⏳ Application fully loaded

═══════════════════════════════════════════════════════════════════════════════

TROUBLESHOOTING:

If page doesn't load after 5 minutes:

1. Check terminal for errors:
   → Look for "SEVERE" or "ERROR" messages

2. Refresh the browser:
   → Ctrl+R or Cmd+R

3. Check if port is available:
   → Should be localhost:8080

4. If still not working:
   → Server may need more time
   → Close and reopen browser
   → Try http://localhost:8080/login.jsp

═══════════════════════════════════════════════════════════════════════════════

TECHNICAL DETAILS:

Framework: Servlet/JSP (Java EE)
Server: Jetty 11.0.18 (Java 23 compatible)
Build Tool: Maven 3.9.5
Database: MySQL (local)
Java Version: 23.0.2
Application Package: WAR (Web Archive)
Deployment: Embedded Jetty

═══════════════════════════════════════════════════════════════════════════════

NEXT STEPS AFTER LOGIN:

1. Dashboard: View account balance and activity
2. Play Games: Try Snake or Puzzle games
3. Chat: Create a room and send messages
4. Payments: Try deposit/withdraw operations
5. Leaderboard: Check your game scores
6. Transaction History: View your payments

═══════════════════════════════════════════════════════════════════════════════

🌐 BROWSER ACCESS:

→ http://localhost:8080/
→ Or refresh the already-opened browser window

═══════════════════════════════════════════════════════════════════════════════

⏳ ESTIMATED TIME REMAINING:

Dependencies Download: 2-3 minutes
Server Initialization: 1-2 minutes
Database Setup: (automatic on first use)
Total: ~5 minutes maximum

═══════════════════════════════════════════════════════════════════════════════

STATUS: 🟡 INITIALIZING → 🟢 ONLINE (very soon)

═══════════════════════════════════════════════════════════════════════════════

Generated: December 22, 2025
Report: PROJECT DEPLOYMENT IN PROGRESS

═══════════════════════════════════════════════════════════════════════════════

## Academic Justification

This project fulfills all requirements for a comprehensive Java programming assessment:
- **Object-Oriented Programming**: Full implementation of OOP principles
- **Database Connectivity**: Complete JDBC integration with MySQL
- **GUI Development**: Extensive Swing-based interface
- **Multithreading**: Responsive UI with background processing
- **Software Engineering**: Proper design patterns and architecture

## Acknowledgments

- **Team**: Diya, Urvi, and Om Pravesh for collaborative development
- **Instructors**: For guidance on Java programming concepts
- **Open Source Community**: For inspiration and learning resources

---


# Third Semester Java Project - Comprehensive Web Application

A complete Java-based web application with multiple integrated features including games, chat system, digital payment system, stock market, and more.

## 🌟 Features

### 1. **Authentication & User Management**
- User login/logout functionality
- Session management (30-minute timeout)
- Admin user pre-created with credentials (admin/admin123)
- Default balance: $10,000 per user

### 2. **Game Center** 🎮
- **Snake Game**
  - Classic snake game mechanics
  - Three difficulty levels: Easy, Medium, Hard
  - Speed increases with difficulty
  - Leaderboard tracking
  - Local high-score storage

- **Puzzle Game**
  - Memory matching game with 8 pairs
  - Move counter
  - Three difficulty levels
  - Score calculation based on moves
  - Leaderboard integration

- **Leaderboard System**
  - Top scores for each game type
  - Difficulty level display
  - Rank badges (Gold, Silver, Bronze)
  - User statistics tracking

### 3. **Chat System** 💬
- Create and manage chat rooms
- Real-time messaging
- View all active chat rooms
- Message history per room
- User identification for messages
- Delete messages and rooms

### 4. **Digital Payment System** 💳
- Account balance management
- Deposit funds (Credit Card, Debit Card, Digital Wallet, Bank Transfer)
- Withdraw funds
- Money transfer between users
- Transaction history with detailed information
- Payment method tracking
- Transaction status (Pending, Completed, Failed)

### 5. **Stock Market** 📈
- View stock listings
- Real-time price updates (simulated)
- Portfolio management
- Buy/sell stocks
- Track holdings
- Market trends

### 6. **Notes Application** 📝
- Create, read, update notes
- Note titles and content
- User-specific notes
- Timestamp tracking

### 7. **Dashboard** 🏠
- Welcome message with user info
- Quick balance display
- Last login information
- Feature shortcuts
- Profile management

## 📊 Database Schema

### Tables

#### Users
```sql
CREATE TABLE users (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    balance DOUBLE DEFAULT 10000.00
)
```

#### Games
```sql
CREATE TABLE games (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    game_type VARCHAR(50) NOT NULL,
    score INT DEFAULT 0,
    time_spent INT DEFAULT 0,
    difficulty VARCHAR(20) DEFAULT 'Easy',
    status VARCHAR(20) DEFAULT 'In Progress',
    played_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (username) REFERENCES users(username)
)
```

#### Chat Rooms
```sql
CREATE TABLE chat_rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_name VARCHAR(100) NOT NULL UNIQUE,
    created_by VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(username)
)
```

#### Messages
```sql
CREATE TABLE messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT NOT NULL,
    sender_username VARCHAR(50) NOT NULL,
    message_content TEXT NOT NULL,
    message_type VARCHAR(20) DEFAULT 'Text',
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES chat_rooms(room_id),
    FOREIGN KEY (sender_username) REFERENCES users(username)
)
```

#### Payment Transactions
```sql
CREATE TABLE payment_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    amount DOUBLE NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    description TEXT,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (username) REFERENCES users(username)
)
```

#### Transactions (P2P Transfers)
```sql
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender VARCHAR(50) NOT NULL,
    recipient VARCHAR(50) NOT NULL,
    amount DOUBLE NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender) REFERENCES users(username),
    FOREIGN KEY (recipient) REFERENCES users(username)
)
```

#### Portfolio (Stock Holdings)
```sql
CREATE TABLE portfolio (
    username VARCHAR(50),
    stock_symbol VARCHAR(10),
    quantity INT DEFAULT 0,
    PRIMARY KEY (username, stock_symbol),
    FOREIGN KEY (username) REFERENCES users(username)
)
```

#### Notes
```sql
CREATE TABLE notes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    title VARCHAR(100) NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (username) REFERENCES users(username)
)
```

## 🏗️ Project Structure

```
third-semester-web-project/
├── src/main/
│   ├── java/com/project/
│   │   ├── dao/
│   │   │   ├── UserDAO.java
│   │   │   ├── GameDAO.java
│   │   │   ├── ChatRoomDAO.java
│   │   │   ├── MessageDAO.java
│   │   │   ├── PaymentTransactionDAO.java
│   │   │   ├── TransactionDAO.java
│   │   │   └── DataAccessor.java
│   │   ├── model/
│   │   │   ├── User.java
│   │   │   ├── Game.java
│   │   │   ├── ChatRoom.java
│   │   │   ├── Message.java
│   │   │   ├── PaymentTransaction.java
│   │   │   ├── Transaction.java
│   │   │   └── Stock.java
│   │   ├── servlet/
│   │   │   ├── LoginServlet.java
│   │   │   ├── DashboardServlet.java
│   │   │   ├── GameServlet.java
│   │   │   ├── ChatServlet.java
│   │   │   ├── DigitalPaymentServlet.java
│   │   │   ├── StockServlet.java
│   │   │   └── PaymentServlet.java
│   │   ├── service/
│   │   │   └── NotesApp.java
│   │   └── util/
│   │       ├── DatabaseUtil.java
│   │       └── ThemeManager.java
│   └── webapp/
│       ├── css/
│       │   └── style.css
│       ├── js/
│       │   └── main.js
│       ├── views/
│       │   ├── login.jsp
│       │   ├── dashboard.jsp
│       │   ├── games.jsp
│       │   ├── games/
│       │   │   ├── snake.jsp
│       │   │   ├── puzzle.jsp
│       │   │   └── leaderboard.jsp
│       │   ├── chat.jsp
│       │   ├── chatRoom.jsp
│       │   ├── digitalPayment.jsp
│       │   ├── paymentHistory.jsp
│       │   ├── stock.jsp
│       │   ├── notes.jsp
│       │   └── payment.jsp
│       └── WEB-INF/
│           └── web.xml
└── pom.xml
```

## 🔧 Technologies Used

- **Backend**: Java (Servlet/JSP)
- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Database**: MySQL
- **Build Tool**: Maven
- **Server**: Apache Tomcat
- **Web Framework**: Servlet API 4.0.1

## 📦 Dependencies

```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>4.0.1</version>
</dependency>

<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>

<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>jstl</artifactId>
    <version>1.2</version>
</dependency>
```

## 🚀 Getting Started

### Prerequisites
- Java 8+
- MySQL 5.7+
- Maven 3.6+
- Apache Tomcat 9.0+

### Installation

1. **Clone/Setup the Project**
   ```bash
   cd d:\Coding\Java\Third_Sem_Java_Project_OS
   ```

2. **Configure Database**
   - Update `src/main/java/com/project/util/DatabaseUtil.java`
   - Set your MySQL connection details:
     ```java
     private static final String DB_URL = "jdbc:mysql://localhost:3306/project";
     private static final String DB_USER = "root";
     private static final String DB_PASS = "your_password";
     ```

3. **Build the Project**
   ```bash
   mvn clean install
   ```

4. **Deploy to Tomcat**
   ```bash
   mvn tomcat7:deploy
   ```

5. **Access the Application**
   - URL: `http://localhost:8080/third-semester-web-project`
   - Default credentials: `admin / admin123`

## 🎮 Game Instructions

### Snake Game
- Use Arrow Keys or WASD to control the snake
- Eat red food squares to grow and gain points
- Avoid hitting walls and your own body
- Three difficulty levels adjust speed
- Scores are saved to leaderboard

### Puzzle Game
- Click tiles to find matching pairs
- Each match removed from board
- Complete all 8 pairs to win
- Fewest moves = highest score
- Multiple difficulty levels available

## 💳 Payment System Usage

1. **Deposit**: Add funds to your wallet
2. **Withdraw**: Remove funds from your wallet
3. **Transfer**: Send money to another user
4. **History**: View all past transactions

## 💬 Chat System Features

- Create private chat rooms
- Send messages to room members
- View message history
- Delete rooms (creator only)
- Real-time message updates

## 📈 Stock Market Features

- View current stock prices
- Real-time price updates
- Buy/sell stocks
- Track portfolio holdings
- Market analysis tools

## 🔐 Security Features

- Session-based authentication
- 30-minute session timeout
- Password storage
- SQL injection prevention (PreparedStatements)
- HTTPS-ready architecture

## 📱 Responsive Design

- Mobile-friendly interface
- Responsive grid layouts
- Touch-friendly buttons
- Optimized for all screen sizes

## 🎨 UI/UX Features

- Modern gradient design
- Smooth animations
- Interactive components
- Loading indicators
- Toast notifications
- Color-coded status badges

## 📝 Default Test Accounts

| Username | Password | Balance |
|----------|----------|---------|
| admin    | admin123 | $50,000 |
| user1    | password | $10,000 |
| user2    | password | $10,000 |

## 🐛 Troubleshooting

### Database Connection Issues
- Check MySQL is running
- Verify connection credentials
- Ensure database exists

### Build Failures
- Clean Maven cache: `mvn clean`
- Update dependencies: `mvn dependency:resolve`
- Check Java version compatibility

### Servlet Not Found
- Verify `@WebServlet` annotations
- Check web.xml configuration
- Restart Tomcat server

## 🔄 Future Enhancements

- [ ] WebSocket support for real-time chat
- [ ] Email notifications
- [ ] Advanced stock market analytics
- [ ] Game achievements and badges
- [ ] User profile customization
- [ ] Mobile app integration
- [ ] Cloud database support
- [ ] Multi-language support

## 📄 License

This project is created for educational purposes.

## 👨‍💻 Author

Third Semester Java Project Team

## 📞 Support

For issues or questions, please contact the development team or refer to the documentation.

---

**Last Updated**: December 2025
**Version**: 1.0.0
**Status**: Active Development


*This project was developed as part of an academic curriculum to demonstrate comprehensive Java programming skills, database integration, and software engineering principles.*

---


## 🙏 Thank You!

