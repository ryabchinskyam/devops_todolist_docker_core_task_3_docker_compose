# Stage 1: Build Stage
ARG PYTHON_VERSION=3.10
FROM python:${PYTHON_VERSION} as builder

WORKDIR /app

# Спочатку копіюємо тільки requirements.txt для кешування
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Потім копіюємо весь код
COPY . .

# Stage 2: Run Stage
FROM python:${PYTHON_VERSION} as run

WORKDIR /app
ENV PYTHONUNBUFFERED=1

COPY --from=builder /app .

EXPOSE 8000

# Запускаємо міграції і сервер
ENTRYPOINT ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]