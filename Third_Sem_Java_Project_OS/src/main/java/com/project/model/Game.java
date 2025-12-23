package com.project.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Game implements Serializable {
    private int gameId;
    private String username;
    private String gameType; // "Snake", "Puzzle", "Flappy Bird"
    private int score;
    private int timeSpent; // in seconds
    private String difficulty; // "Easy", "Medium", "Hard"
    private Timestamp playedAt;
    private String status; // "Won", "Lost", "In Progress"

    public Game() {}

    public Game(String username, String gameType, int score, int timeSpent, String difficulty, String status) {
        this.username = username;
        this.gameType = gameType;
        this.score = score;
        this.timeSpent = timeSpent;
        this.difficulty = difficulty;
        this.status = status;
    }

    // Getters and Setters
    public int getGameId() { return gameId; }
    public void setGameId(int gameId) { this.gameId = gameId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getGameType() { return gameType; }
    public void setGameType(String gameType) { this.gameType = gameType; }

    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }

    public int getTimeSpent() { return timeSpent; }
    public void setTimeSpent(int timeSpent) { this.timeSpent = timeSpent; }

    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }

    public Timestamp getPlayedAt() { return playedAt; }
    public void setPlayedAt(Timestamp playedAt) { this.playedAt = playedAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Game{" +
                "gameId=" + gameId +
                ", username='" + username + '\'' +
                ", gameType='" + gameType + '\'' +
                ", score=" + score +
                ", timeSpent=" + timeSpent +
                ", difficulty='" + difficulty + '\'' +
                ", playedAt=" + playedAt +
                ", status='" + status + '\'' +
                '}';
    }
}
