// Main JavaScript for Third Semester Project

document.addEventListener('DOMContentLoaded', function() {
    initializeTheme();
    initializeNotifications();
    setupEventListeners();
});

// Theme Management
function initializeTheme() {
    const savedTheme = localStorage.getItem('theme') || 'light';
    applyTheme(savedTheme);
}

function applyTheme(theme) {
    document.body.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
}

function toggleTheme() {
    const currentTheme = document.body.getAttribute('data-theme') || 'light';
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    applyTheme(newTheme);
}

// Notifications
function initializeNotifications() {
    if ('Notification' in window && Notification.permission === 'default') {
        Notification.requestPermission();
    }
}

function showNotification(title, message) {
    if ('Notification' in window && Notification.permission === 'granted') {
        new Notification(title, {
            body: message,
            icon: 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><text y=".9em" font-size="90">🎮</text></svg>'
        });
    }
}

// Form Validation
function validateForm(formId) {
    const form = document.getElementById(formId);
    if (!form) return true;
    
    const inputs = form.querySelectorAll('input[required], select[required]');
    let isValid = true;

    inputs.forEach(input => {
        if (!input.value.trim()) {
            input.style.borderColor = '#ef4444';
            isValid = false;
        } else {
            input.style.borderColor = '';
        }
    });

    return isValid;
}

// AJAX Helper Functions
async function fetchData(url, options = {}) {
    try {
        const response = await fetch(url, {
            headers: {
                'Content-Type': 'application/json',
                ...options.headers
            },
            ...options
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        return await response.json();
    } catch (error) {
        console.error('Fetch error:', error);
        showNotification('Error', 'Failed to fetch data');
        return null;
    }
}

async function postData(url, data) {
    return await fetchData(url, {
        method: 'POST',
        body: JSON.stringify(data)
    });
}

// Stock Market Simulation
class StockSimulator {
    constructor() {
        this.stocks = [];
        this.updateInterval = null;
    }

    async loadStocks() {
        this.stocks = await fetchData('/api/stocks');
        this.renderStocks();
    }

    startLiveUpdates() {
        this.updateInterval = setInterval(() => {
            this.updateStockPrices();
        }, 5000); // Update every 5 seconds
    }

    updateStockPrices() {
        this.stocks.forEach(stock => {
            const change = (Math.random() - 0.5) * 2; // -1% to +1%
            stock.price = Math.max(1, stock.price * (1 + change / 100));
            stock.change = change;
        });
        this.renderStocks();
    }

    renderStocks() {
        const container = document.getElementById('stock-container');
        if (!container) return;

        container.innerHTML = this.stocks.map(stock => `
            <div class="stock-card">
                <div class="stock-symbol">${stock.symbol}</div>
                <div class="stock-price">$${stock.price.toFixed(2)}</div>
                <div class="stock-change ${stock.change >= 0 ? 'positive' : 'negative'}">
                    ${stock.change >= 0 ? '+' : ''}${stock.change.toFixed(2)}%
                </div>
            </div>
        `).join('');
    }

    stop() {
        if (this.updateInterval) {
            clearInterval(this.updateInterval);
        }
    }
}

// Utility Functions
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: 2
    }).format(amount);
}

function formatDate(dateString) {
    return new Date(dateString).toLocaleDateString('en-US', {
        day: '2-digit',
        month: 'short',
        year: 'numeric'
    });
}

function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.textContent = message;
    toast.style.cssText = `
        position: fixed;
        bottom: 20px;
        right: 20px;
        background: ${type === 'success' ? '#10b981' : type === 'error' ? '#ef4444' : '#3b82f6'};
        color: white;
        padding: 15px 20px;
        border-radius: 5px;
        z-index: 10000;
        animation: slideIn 0.3s ease-in;
    `;
    document.body.appendChild(toast);
    
    setTimeout(() => {
        toast.style.animation = 'slideOut 0.3s ease-out';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

// Event Listeners Setup
function setupEventListeners() {
    // Theme toggle
    const themeToggle = document.getElementById('theme-toggle');
    if (themeToggle) {
        themeToggle.addEventListener('click', toggleTheme);
    }

    // Form submissions
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!validateForm(this.id)) {
                e.preventDefault();
            }
        });
    });

    // Logout button
    const logoutBtn = document.getElementById('logout-btn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', function(e) {
            e.preventDefault();
            if (confirm('Are you sure you want to logout?')) {
                fetch('login', { method: 'DELETE' })
                    .then(() => window.location.href = 'login');
            }
        });
    }

    // Auto-update stock prices if on stock page
    if (window.location.pathname.includes('stock')) {
        const simulator = new StockSimulator();
        simulator.loadStocks();
        simulator.startLiveUpdates();

        // Cleanup on page unload
        window.addEventListener('beforeunload', () => {
            simulator.stop();
        });
    }
}

// Export functions for use in HTML
window.OSProject = {
    toggleTheme,
    showNotification,
    formatCurrency,
    formatDate
};
