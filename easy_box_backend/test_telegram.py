import os
import requests
from dotenv import load_dotenv

print("--- Starting Telegram Test ---")

# 1. Load environment variables
print("1. Loading .env file...")
load_dotenv()
print("   .env file loaded.")

# 2. Read variables
TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")
TELEGRAM_CHAT_ID = os.getenv("TELEGRAM_CHAT_ID")

print(f'2. Reading variables...\n   - TELEGRAM_BOT_TOKEN is set: {bool(TELEGRAM_BOT_TOKEN)}\n   - TELEGRAM_CHAT_ID is set: {bool(TELEGRAM_CHAT_ID)}')

# 3. Check if variables are present
if not TELEGRAM_BOT_TOKEN or not TELEGRAM_CHAT_ID:
    print("\n[ERROR] Telegram credentials not set in .env file. Exiting.")
    exit()

# 4. Attempt to send message
message = "👋 This is a test message from your Easy Box server."
url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
payload = {
    "chat_id": TELEGRAM_CHAT_ID,
    "text": message,
    "parse_mode": "Markdown"
}

print(f'\n3. Preparing to send message to chat_id: {TELEGRAM_CHAT_ID}')

try:
    print("4. Sending request to Telegram API...")
    response = requests.post(url, json=payload)
    response.raise_for_status()  # Raise an exception for bad status codes (4xx or 5xx)
    print("\n[SUCCESS] Message sent successfully!")
    print(f"   - Response status code: {response.status_code}")
    print(f"   - Response body: {response.text}")
except requests.exceptions.RequestException as e:
    print(f"\n[ERROR] Failed to send Telegram notification: {e}")

print("--- Test Finished ---")
