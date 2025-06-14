FROM python:3.11-slim-buster

# Set work directory
WORKDIR /app

# Install system dependencies (no specific versions)
RUN apt-get update && apt-get install --no-install-recommends -y \
    dnsutils \
    libpq-dev \
    python3-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install Python dependencies
RUN python -m pip install --no-cache-dir pip==22.0.4
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Run DB migrations (optional in container)
RUN python3 manage.py migrate

# Expose the web server port
EXPOSE 8000

# Set working directory and start Gunicorn
WORKDIR /app/pygoat
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "6", "pygoat.wsgi"]
