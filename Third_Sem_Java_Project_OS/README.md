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
