package gui.apps;

import model.User;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
// IMPORT THE CORRECT CLASSES EXPLICITLY TO AVOID ERRORS
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ChatSystemGUI extends JFrame {
    private final User currentUser;
    private JPanel chatContainer;
    private JTextField messageField;
    private JButton sendBtn;
    private JButton connectBtn;
    private JTextField hostField, portField;
    private JRadioButton serverRadio, clientRadio;

    private Socket socket;
    private ServerSocket serverSocket;
    private PrintWriter out;
    private BufferedReader in;
    private boolean isConnected = false;
    private String remoteUsername = "Contact";

    // WhatsApp Theme Colors
    private final Color WA_GREEN = new Color(7, 94, 84);
    private final Color WA_BG = new Color(229, 221, 213);
    private final Color BUBBLE_SENT = new Color(220, 248, 198);
    private final Color BUBBLE_RECEIVED = Color.WHITE;

    public ChatSystemGUI(User user) {
        this.currentUser = user;
        setTitle("WhatsApp Desktop - " + currentUser.getUsername());
        setSize(500, 700);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(new BorderLayout());

        add(createHeader(), BorderLayout.NORTH);

        chatContainer = new JPanel();
        chatContainer.setLayout(new BoxLayout(chatContainer, BoxLayout.Y_AXIS));
        chatContainer.setBackground(WA_BG);

        JScrollPane scrollPane = new JScrollPane(chatContainer);
        scrollPane.setBorder(null);
        add(scrollPane, BorderLayout.CENTER);

        add(createInputArea(), BorderLayout.SOUTH);

        connectBtn.addActionListener(e -> handleConnection());

        setVisible(true);
    }

    private JPanel createHeader() {
        JPanel header = new JPanel(new BorderLayout());
        header.setBackground(WA_GREEN);
        header.setPreferredSize(new Dimension(getWidth(), 90));
        header.setBorder(new EmptyBorder(10, 15, 10, 15));

        JLabel nameLabel = new JLabel(remoteUsername);
        nameLabel.setFont(new Font("Segoe UI", Font.BOLD, 18));
        nameLabel.setForeground(Color.WHITE);
        header.add(nameLabel, BorderLayout.WEST);

        JPanel controls = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        controls.setOpaque(false);

        serverRadio = new JRadioButton("S", true);
        clientRadio = new JRadioButton("C");
        ButtonGroup group = new ButtonGroup();
        group.add(serverRadio); group.add(clientRadio);

        hostField = new JTextField("localhost", 6);
        portField = new JTextField("5000", 4);
        connectBtn = new JButton("Connect");

        controls.add(serverRadio); controls.add(clientRadio);
        controls.add(hostField); controls.add(portField);
        controls.add(connectBtn);

        header.add(controls, BorderLayout.SOUTH);
        return header;
    }

    private JPanel createInputArea() {
        JPanel panel = new JPanel(new BorderLayout(10, 0));
        panel.setBackground(new Color(240, 240, 240));
        panel.setBorder(new EmptyBorder(10, 10, 10, 10));

        messageField = new JTextField();
        messageField.setEnabled(false);

        sendBtn = new JButton("Send");
        sendBtn.setBackground(WA_GREEN);
        sendBtn.setForeground(Color.WHITE);
        sendBtn.setFocusPainted(false);
        sendBtn.setEnabled(false);

        panel.add(messageField, BorderLayout.CENTER);
        panel.add(sendBtn, BorderLayout.EAST);

        // FIXED: Using the standard java.awt.event.ActionListener
        ActionListener sendAction = new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                sendMessage();
            }
        };

        sendBtn.addActionListener(sendAction);
        messageField.addActionListener(sendAction);

        return panel;
    }

    private void sendMessage() {
        String msg = messageField.getText().trim();
        if (isConnected && !msg.isEmpty()) {
            out.println(msg);
            addBubble("You", msg, true);
            messageField.setText("");
        }
    }

    private void addBubble(String sender, String message, boolean isSent) {
        SwingUtilities.invokeLater(() -> {
            JPanel bubbleWrapper = new JPanel(new FlowLayout(isSent ? FlowLayout.RIGHT : FlowLayout.LEFT));
            bubbleWrapper.setOpaque(false);

            JPanel bubble = new JPanel() {
                @Override
                protected void paintComponent(Graphics g) {
                    Graphics2D g2 = (Graphics2D) g.create();
                    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
                    g2.setColor(isSent ? BUBBLE_SENT : BUBBLE_RECEIVED);
                    g2.fillRoundRect(0, 0, getWidth(), getHeight(), 15, 15);
                    g2.dispose();
                }
            };
            bubble.setLayout(new BorderLayout());
            bubble.setOpaque(false);
            bubble.setBorder(new EmptyBorder(8, 12, 8, 12));

            JLabel text = new JLabel("<html><p style='width: 150px;'>" + message + "</p></html>");
            bubble.add(text, BorderLayout.CENTER);

            bubbleWrapper.add(bubble);
            chatContainer.add(bubbleWrapper);
            chatContainer.add(Box.createVerticalStrut(10));

            chatContainer.revalidate();
            chatContainer.repaint();
        });
    }

    private void handleConnection() {
        new Thread(() -> {
            try {
                if (serverRadio.isSelected()) {
                    serverSocket = new ServerSocket(Integer.parseInt(portField.getText()));
                    socket = serverSocket.accept();
                } else {
                    socket = new Socket(hostField.getText(), Integer.parseInt(portField.getText()));
                }
                setupConnection();
            } catch (Exception ex) {
                addBubble("System", "Error: " + ex.getMessage(), false);
            }
        }).start();
    }

    private void setupConnection() throws IOException {
        out = new PrintWriter(socket.getOutputStream(), true);
        in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        out.println("USERNAME:" + currentUser.getUsername());
        isConnected = true;
        SwingUtilities.invokeLater(() -> {
            messageField.setEnabled(true);
            sendBtn.setEnabled(true);
            connectBtn.setText("End");
        });
        listenForMessages();
    }

    private void listenForMessages() {
        new Thread(() -> {
            try {
                String msg;
                while ((msg = in.readLine()) != null) {
                    if (msg.startsWith("USERNAME:")) {
                        remoteUsername = msg.substring(9);
                    } else {
                        addBubble(remoteUsername, msg, false);
                    }
                }
            } catch (IOException e) { isConnected = false; }
        }).start();
    }
}