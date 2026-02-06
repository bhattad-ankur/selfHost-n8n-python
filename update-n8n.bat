@echo off
echo Updating n8n to the latest version...
docker compose pull
docker compose up -d
echo.
echo Update complete!
pause