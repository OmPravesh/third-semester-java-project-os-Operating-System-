package com.project.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class Stock {
    public String symbol, name;
    public double price, previousPrice, openPrice;
    public double dayHigh, dayLow;
    public long volume;
    private final List<Double> priceHistory = new ArrayList<>();
    private final int MAX_HISTORY = 100;

    public Stock(String symbol, String name, double price) {
        this.symbol = symbol;
        this.name = name;
        this.price = price;
        this.previousPrice = price;
        this.openPrice = price;
        this.dayHigh = price;
        this.dayLow = price;
        this.priceHistory.add(price);
    }

    public void updatePrice(Random rand) {
        this.previousPrice = this.price;
        // Simulation logic: slightly more volatile for demo
        double changePercent = (rand.nextDouble() - 0.48) * 0.02;
        this.price *= (1 + changePercent);
        if (this.price < 0.1) this.price = 0.1;

        // Update High/Low/Vol
        if (this.price > dayHigh) dayHigh = this.price;
        if (this.price < dayLow) dayLow = this.price;
        this.volume += rand.nextInt(500);

        this.priceHistory.add(this.price);
        if (this.priceHistory.size() > MAX_HISTORY) {
            priceHistory.remove(0);
        }
    }

    public double getChangePercent() {
        return ((price - openPrice) / openPrice) * 100;
    }

    public List<Double> getPriceHistory() {
        return new ArrayList<>(priceHistory);
    }
}