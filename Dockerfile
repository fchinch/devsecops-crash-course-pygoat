FROM python:3.11-slim-buster

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y \
    libpq-dev \
    python3-dev \
    dnsutils \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN python -m pip install --no-cache-dir pip==22.0.4
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

WORKDIR /app/pygoat
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "6", "pygoat.wsgi"]
