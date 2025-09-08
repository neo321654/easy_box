import logging
from .telegram_utils import send_telegram_notification

class TelegramLogHandler(logging.Handler):
    def emit(self, record):
        log_entry = self.format(record)
        send_telegram_notification(log_entry)
