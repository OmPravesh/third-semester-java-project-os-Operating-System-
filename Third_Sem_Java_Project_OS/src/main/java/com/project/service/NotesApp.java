package com.project.service;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.logging.Logger;

import com.project.model.User;

public class NotesApp {
    private static final Logger LOGGER = Logger.getLogger(NotesApp.class.getName());
    private static final String NOTES_DIR = "console_os_notes/";

    public static File[] getUserNotes(User user) {
        try {
            Files.createDirectories(Paths.get(NOTES_DIR));
        } catch (IOException e) {
            LOGGER.severe("Error creating notes directory: " + e.getMessage());
        }
        File dir = new File(NOTES_DIR);
        return dir.listFiles((d, name) -> name.startsWith(user.getUsername() + "_") && name.endsWith(".txt"));
    }

    public static void createNoteWithContent(User user, String title, String content) {
        String safeTitle = title.replaceAll("[^a-zA-Z0-9.-]", "_");
        String filename = NOTES_DIR + user.getUsername() + "_" + safeTitle + ".txt";
        try (FileWriter writer = new FileWriter(filename)) {
            writer.write(content);
            LOGGER.info("Note created successfully: " + filename);
        } catch (IOException e) {
            LOGGER.severe("Error creating note: " + e.getMessage());
        }
    }

    public static String readNoteContent(File noteFile) {
        try {
            return new String(Files.readAllBytes(noteFile.toPath()));
        } catch (IOException e) {
            LOGGER.severe("Error reading note: " + e.getMessage());
            return "";
        }
    }

    public static boolean deleteNote(File noteFile) {
        try {
            return noteFile.delete();
        } catch (SecurityException e) {
            LOGGER.severe("Error deleting note: " + e.getMessage());
            return false;
        }
    }
}