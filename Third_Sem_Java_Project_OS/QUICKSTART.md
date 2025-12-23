# Quick Start Guide - Third Semester Java Project

## 🚀 Get Started in 5 Minutes

### Prerequisites Check
```
✓ Java 8 or higher installed
✓ MySQL Server running
✓ Maven installed
✓ Apache Tomcat 9.0+
```

## Step 1: Configure Database (2 minutes)

1. Open `src/main/java/com/project/util/DatabaseUtil.java`
2. Update your MySQL credentials:
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/project";
private static final String DB_USER = "root";
private static final String DB_PASS = "your_mysql_password";
```
3. Create an empty database:
```bash
mysql -u root -p
CREATE DATABASE project;
EXIT;
```

## Step 2: Build Project (2 minutes)

```bash
cd d:\Coding\Java\Third_Sem_Java_Project_OS
mvn clean install
```

## Step 3: Deploy & Run (1 minute)

**Option A: Using Tomcat Maven Plugin**
```bash
mvn tomcat7:run
```

**Option B: Manual Tomcat Deployment**
```bash
# Copy WAR file to Tomcat
mvn clean package
# Copy target/third-semester-web-project.war to TOMCAT_HOME/webapps/
```

## Step 4: Access Application

Open your browser and navigate to:
```
http://localhost:8080/third-semester-web-project
```

## Step 5: Login

Use these test credentials:
```
Username: admin
Password: admin123
```

---

## 🎮 Quick Feature Tour

### 1️⃣ Play Games
- Click "Games" → Choose "Snake" or "Puzzle"
- Try to get high scores
- Check "Leaderboard" to see top players

### 2️⃣ Send Messages
- Go to "Chat" → Create a new room
- Send messages to chat room
- Messages auto-refresh every 3 seconds

### 3️⃣ Make Payments
- Click "Payments" → Choose action
- Deposit: Add funds to wallet
- Transfer: Send money to another user
- History: View all transactions

### 4️⃣ View Dashboard
- Home page shows your balance
- Quick links to all features
- Account overview

### 5️⃣ Stock Market (Existing)
- View stock prices
- Buy/Sell stocks
- Check portfolio

---

## 📊 Default Test Data

### Admin Account
```
Username: admin
Password: admin123
Balance: $50,000
```

### Additional Accounts (Create as needed)
- Default balance: $10,000 per user
- Any username/password combination works
- Or login as admin and manage users

---

## ✨ Key Features at a Glance

| Feature | URL | Status |
|---------|-----|--------|
| Games | `/games` | ✅ Ready |
| Snake | `/games?gameType=snake` | ✅ Ready |
| Puzzle | `/games?gameType=puzzle` | ✅ Ready |
| Chat | `/chat` | ✅ Ready |
| Payments | `/digital-payment` | ✅ Ready |
| Dashboard | `/dashboard` | ✅ Ready |
| Stock | `/stock` | ✅ Ready |
| Logout | `/login` (DELETE) | ✅ Ready |

---

## 🆘 Troubleshooting

### "Connection Refused" Error
- Check MySQL is running
- Verify database name is "project"
- Check username/password in DatabaseUtil

### "Port 8080 already in use"
```bash
# Find process using port 8080
netstat -ano | findstr :8080

# Kill the process (Windows)
taskkill /PID <PID> /F

# Or use different port:
mvn tomcat7:run -Dtomcat.port=8081
```

### "Page not found (404)"
- Check URL matches servlet mapping in @WebServlet
- Verify JSP files are in `src/main/webapp/views/`
- Restart Tomcat server

### "NoSuchMethodError" or "ClassNotFoundException"
- Run: `mvn clean install`
- Delete target folder manually
- Rebuild project

---

## 💡 Pro Tips

1. **High Score Tracking**: Browser stores your high scores locally
   - Clear browser storage to reset
   - Located in Developer Tools → Application → LocalStorage

2. **Session Timeout**: You'll be logged out after 30 minutes of inactivity
   - Click "Logout" button to logout anytime

3. **Chat Auto-Refresh**: Messages update every 3 seconds
   - No need to manually refresh

4. **Payment Confirmations**: Check transaction history for proof
   - View Payment History page

5. **Leaderboard Updates**: Scores save automatically
   - Complete any game to add your score

---

## 📱 Browser Support

- Chrome 90+ ✅
- Firefox 88+ ✅
- Safari 14+ ✅
- Edge 90+ ✅
- Mobile browsers ✅

---

## 🔐 Security Notes

1. Default admin account should be changed in production
2. Passwords are stored as plain text (add encryption for production)
3. Session timeout is 30 minutes
4. All forms use CSRF protection (sessions)

---

## 📚 Project Structure Quick View

```
Project Root
├── src/main/java/com/project/
│   ├── model/          (5 model classes)
│   ├── dao/            (5 DAO classes)
│   ├── servlet/        (6 servlet classes)
│   ├── service/
│   └── util/
├── src/main/webapp/
│   ├── views/          (9 JSP files)
│   ├── css/            (1 stylesheet)
│   ├── js/             (1 main script)
│   └── WEB-INF/
└── pom.xml
```

---

## 🎯 Next Steps

1. ✅ Login to application
2. ✅ Explore all features
3. ✅ Play games and get on leaderboard
4. ✅ Test payment system
5. ✅ Create chat rooms
6. ✅ Transfer money between accounts
7. ✅ Check transaction history

---

## 📞 Need Help?

- **README.md** - Detailed project documentation
- **IMPLEMENTATION_GUIDE.md** - Complete implementation details
- **Code Comments** - Each class has detailed comments
- **JSP Files** - Include inline documentation

---

## 🎉 You're All Set!

Your complete Java web application is ready to use. Enjoy exploring all the features!

**Happy Coding!** 🚀

---

**Last Updated**: December 2025
**Version**: 1.0.0
