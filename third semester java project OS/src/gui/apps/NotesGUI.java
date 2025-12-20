package gui.apps;

import model.User;
import service.NotesApp;
import util.ThemeManager;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

public class NotesGUI extends JFrame {
    private final User currentUser;
    private final JList<String> noteList;
    private final JTextArea noteContent;
    private final DefaultListModel<String> listModel;
    private File[] noteFiles;

    public NotesGUI(User user) {
        this.currentUser = user;
        setTitle("Notes App - " + currentUser.getUsername());
        setSize(800, 600);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);
        listModel = new DefaultListModel<>();
        noteList = new JList<>(listModel);
        noteContent = new JTextArea();
        noteContent.setFont(new Font("Monospaced", Font.PLAIN, 14));
        JScrollPane listScrollPane = new JScrollPane(noteList);
        JScrollPane contentScrollPane = new JScrollPane(noteContent);
        listScrollPane.setPreferredSize(new Dimension(250, 0));
        JSplitPane splitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, listScrollPane, contentScrollPane);
        splitPane.setDividerLocation(250);
        JPanel buttonPanel = new JPanel();
        JButton btnNew = new JButton("New");
        JButton btnSave = new JButton("Save");
        JButton btnDelete = new JButton("Delete");
        buttonPanel.add(btnNew);
        buttonPanel.add(btnSave);
        buttonPanel.add(btnDelete);
        add(splitPane, BorderLayout.CENTER);
        add(buttonPanel, BorderLayout.SOUTH);
        noteList.addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting()) displaySelectedNote();
        });
        btnNew.addActionListener(e -> {
            noteContent.setText("");
            noteList.clearSelection();
        });
        btnSave.addActionListener(e -> saveNote());
        btnDelete.addActionListener(e -> deleteSelectedNote());
        loadNoteList();
        ThemeManager.applyThemeToAll();
        setVisible(true);
    }

    private void loadNoteList() {
        listModel.clear();
        noteFiles = NotesApp.getUserNotes(currentUser);
        if (noteFiles != null) {
            for (File file : noteFiles) {
                String title = file.getName().replace(currentUser.getUsername() + "_", "").replace(".txt", "");
                listModel.addElement(title.replaceAll("_", " "));
            }
        }
    }

    private void displaySelectedNote() {
        int selectedIndex = noteList.getSelectedIndex();
        if (selectedIndex != -1 && selectedIndex < noteFiles.length) {
            try {
                String content = new String(Files.readAllBytes(noteFiles[selectedIndex].toPath()));
                noteContent.setText(content);
                noteContent.setCaretPosition(0);
            } catch (IOException e) {
                noteContent.setText("Error reading file: " + e.getMessage());
            }
        }
    }

    private void saveNote() {
        int selectedIndex = noteList.getSelectedIndex();
        String currentTitle = (selectedIndex != -1) ? listModel.getElementAt(selectedIndex) : "";
        String title = JOptionPane.showInputDialog(this, "Enter note title:", currentTitle);
        if (title == null || title.trim().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Title cannot be empty.", "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }
        if (selectedIndex != -1 && !title.equals(currentTitle)) {
            noteFiles[selectedIndex].delete();
        }
        NotesApp.createNoteWithContent(currentUser, title, noteContent.getText());
        JOptionPane.showMessageDialog(this, "Note saved successfully!");
        loadNoteList();
    }

    private void deleteSelectedNote() {
        int selectedIndex = noteList.getSelectedIndex();
        if (selectedIndex != -1) {
            if (JOptionPane.showConfirmDialog(this, "Are you sure?", "Confirm Deletion", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
                if (noteFiles[selectedIndex].delete()) {
                    loadNoteList();
                    noteContent.setText("");
                } else {
                    JOptionPane.showMessageDialog(this, "Failed to delete the note file.", "Error", JOptionPane.ERROR_MESSAGE);
                }
            }
        } else {
            JOptionPane.showMessageDialog(this, "Please select a note to delete.", "Warning", JOptionPane.WARNING_MESSAGE);
        }
    }
}