FROM python:3.12-slim

WORKDIR /app

# Install runtime dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app ./app

# Expose the port the app listens on
EXPOSE 8080

# Use a production web server (gunicorn)
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app.main:app"]

