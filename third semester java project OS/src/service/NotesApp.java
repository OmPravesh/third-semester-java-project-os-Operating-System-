package service;

import model.User;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class NotesApp {
    private static final String NOTES_DIR = "console_os_notes/";

    public static File[] getUserNotes(User user) {
        try {
            Files.createDirectories(Paths.get(NOTES_DIR));
        } catch (IOException e) {
            e.printStackTrace();
        }
        File dir = new File(NOTES_DIR);
        return dir.listFiles((d, name) -> name.startsWith(user.getUsername() + "_") && name.endsWith(".txt"));
    }

    public static void createNoteWithContent(User user, String title, String content) {
        String safeTitle = title.replaceAll("[^a-zA-Z0-9.-]", "_");
        String filename = NOTES_DIR + user.getUsername() + "_" + safeTitle + ".txt";
        try (FileWriter writer = new FileWriter(filename)) {
            writer.write(content);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}