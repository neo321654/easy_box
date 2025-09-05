import requests
import os
from dotenv import load_dotenv
import logging
import traceback
from fastapi import Request

load_dotenv()

TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")
TELEGRAM_CHAT_ID = os.getenv("TELEGRAM_CHAT_ID")

def send_telegram_error_notification(message: str):
    if not TELEGRAM_BOT_TOKEN or not TELEGRAM_CHAT_ID:
        print("Telegram credentials not set. Skipping notification.")
        return

    url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
    payload = {
        "chat_id": TELEGRAM_CHAT_ID,
        "text": message,
        "parse_mode": "Markdown"
    }
    try:
        response = requests.post(url, json=payload)
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        print(f"Failed to send Telegram notification: {e}")

class TelegramLogHandler(logging.Handler):
    def __init__(self):
        super().__init__()

    def emit(self, record: logging.LogRecord):
        try:
            msg = self.format(record)
            
            # Если есть информация об исключении, добавляем тип и значение ошибки
            if record.exc_info:
                exc_type, exc_value, _ = record.exc_info
                msg += f"\n**Exception**: `{exc_type.__name__}: {exc_value}`"

            # Обрезаем сообщение, чтобы не превысить лимиты Telegram
            if len(msg) > 4000:
                msg = msg[:4000] + "\n... (truncated)"

            send_telegram_error_notification(msg)
        except Exception:
            self.handleError(record)

def send_client_error_notification(request: Request, detail: str):
    """Formats and sends a notification about a client-side error (e.g., 4xx)."""
    message = (
        f"🔵 **Client Error Notification** 🔵\n\n"
        f"**Endpoint**: `{request.method} {request.url.path}`\n"
        f"**Client**: `{request.client.host}:{request.client.port}`\n"
        f"**Detail**: `{detail}`"
    )
    send_telegram_error_notification(message)

