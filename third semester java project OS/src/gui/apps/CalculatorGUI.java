package gui.apps;

import util.ThemeManager;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class CalculatorGUI extends JFrame implements ActionListener {
    private final JTextField display;
    private String operator = "";
    private double firstOperand = 0;
    private boolean isNewCalculation = true;

    public CalculatorGUI() {
        setTitle("Calculator");
        setSize(400, 500);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);
        display = new JTextField();
        display.setEditable(false);
        display.setFont(new Font("Arial", Font.BOLD, 32));
        display.setHorizontalAlignment(JTextField.RIGHT);
        add(display, BorderLayout.NORTH);
        JPanel panel = new JPanel(new GridLayout(4, 4, 5, 5));
        String[] buttons = {"7", "8", "9", "/", "4", "5", "6", "*", "1", "2", "3", "-", "C", "0", "=", "+"};
        for (String text : buttons) {
            JButton button = new JButton(text);
            button.setFont(new Font("Arial", Font.BOLD, 24));
            button.addActionListener(this);
            panel.add(button);
        }
        add(panel, BorderLayout.CENTER);
        ThemeManager.applyThemeToAll();
        setVisible(true);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        String command = e.getActionCommand();
        if ("0123456789".contains(command)) {
            if (isNewCalculation) {
                display.setText(command);
                isNewCalculation = false;
            } else {
                display.setText(display.getText() + command);
            }
        } else if ("+-*/".contains(command)) {
            if (!display.getText().isEmpty()) {
                firstOperand = Double.parseDouble(display.getText());
                operator = command;
                isNewCalculation = true;
            }
        } else if ("=".equals(command) && !operator.isEmpty()) {
            double secondOperand = Double.parseDouble(display.getText());
            double result = 0;
            switch (operator) {
                case "+": result = firstOperand + secondOperand; break;
                case "-": result = firstOperand - secondOperand; break;
                case "*": result = firstOperand * secondOperand; break;
                case "/": result = secondOperand != 0 ? firstOperand / secondOperand : 0; break;
            }
            display.setText(String.valueOf(result));
            operator = "";
            isNewCalculation = true;
        } else if ("C".equals(command)) {
            display.setText("");
            firstOperand = 0;
            operator = "";
            isNewCalculation = true;
        }
    }
}