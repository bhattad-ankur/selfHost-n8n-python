@echo off
echo Starting n8n...
docker compose up -d
echo.
echo n8n is running at http://localhost:5678
timeout /t 3