# Используем официальный образ Python
FROM python:3.10-slim

# Устанавливаем рабочую директорию в контейнере
# Теперь это будет корневая папка вашего проекта easy_box_backend
WORKDIR /easy_box_backend

# Копируем файл с зависимостями и устанавливаем их
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Копируем весь код приложения (папку app) в контейнер
# Теперь app будет подпапкой внутри /easy_box_backend
COPY ./app ./app

# Указываем команду для запуска приложения
# Теперь gunicorn может найти app.main:app, потому что app находится в WORKDIR
CMD ["gunicorn", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8000", "app.main:app"]