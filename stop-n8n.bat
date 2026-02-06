@echo off
echo Stopping n8n...
docker compose stop
echo Done.
timeout /t 2