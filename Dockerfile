# Use the official Python image as a base image
FROM python:3.9-slim

# Set environment variables to avoid some common issues
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file to the working directory
COPY requirements.txt /app/requirements.txt

# Install system dependencies
RUN apt-get update && apt-get install -y \
    chromium-driver \
    chromium-browser \
    wget \
    curl \
    unzip \
    xvfb \
    libnss3-dev \
    libxss1 \
    libappindicator1 \
    libindicator7 \
    fonts-liberation \
    libasound2 \
    libgbm1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the entire project to the container
COPY . /app

# Make Chromium accessible in the environment
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROMEDRIVER_BIN=/usr/bin/chromedriver

# Expose the port that Streamlit runs on
EXPOSE 8501

# Start Streamlit when the container launches
CMD ["streamlit", "run", "streamlit_app.py", "--server.port=8501", "--server.address=0.0.0.0"]
