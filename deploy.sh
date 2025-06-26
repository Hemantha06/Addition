#!/bin/bash

APP_DIR="/home/ubuntu/Addition"
APP_NAME="test"
SERVICE_NAME="fastapi.service"
PYTHON_ENV="$APP_DIR/venv"

# Stop existing service if running
sudo systemctl stop $SERVICE_NAME || true

# Install dependencies
cd $APP_DIR
python3 -m venv venv
source $PYTHON_ENV/bin/activate
pip install --upgrade pip
pip install fastapi uvicorn gunicorn

# Create or update systemd service
sudo tee /etc/systemd/system/$SERVICE_NAME > /dev/null <<EOF
[Unit]
Description=Gunicorn instance to serve FastAPI App
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=$APP_DIR
Environment="PATH=$PYTHON_ENV/bin"
ExecStart=$PYTHON_ENV/bin/gunicorn -k uvicorn.workers.UvicornWorker main:app --bind 127.0.0.1:8000

[Install]
WantedBy=multi-user.target
EOF

# Reload and restart systemd service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl restart $SERVICE_NAME

# Set permissions if needed
sudo chown -R ubuntu:www-data $APP_DIR
