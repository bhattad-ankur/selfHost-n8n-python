# selfHost-n8n-python
A full implementation of n8n with python and external libraries. 

# n8n Automation Setup

A Docker-based n8n workflow automation environment with custom task runners and AI-powered content generation templates.

## 📋 Overview

This repository contains a complete n8n setup featuring:
- **n8n Core**: Workflow automation platform running on port 5678
- **Custom Task Runners**: JavaScript and Python execution environments with extended libraries
- **Content Generation Pipeline**: AI-powered templates for data analytics content creation
- **Easy Management**: Windows batch scripts for quick start/stop/update operations

## 🚀 Quick Start

### Prerequisites
- Docker Desktop (Windows)
- Docker Compose
- PowerShell or Command Prompt

### Starting the Environment

Run the start script:
```bash
.\start-n8n.bat
```

This will:
1. Build the custom runners Docker image
2. Start n8n service on `http://localhost:5678`
3. Start the task runners container
4. Create persistent storage for n8n data

**Access**: Open your browser and navigate to `http://localhost:5678`

### Stopping the Environment

```bash
.\stop-n8n.bat
```

Gracefully stops all running containers while preserving data volumes.

### Updating n8n

```bash
.\update-n8n.bat
```

Pulls the latest n8n version and task runner images, then restarts the services.

## 📁 Project Structure

```
├── docker-compose.yml              # Main container orchestration config
├── start-n8n.bat                   # Startup script
├── stop-n8n.bat                    # Shutdown script
├── update-n8n.bat                  # Update script
├── config/
│   └── n8n-task-runners.json       # Task runner configuration
├── runners/
│   ├── Dockerfile                  # Custom runners image definition
│   └── requirements.txt             # Python dependencies
└── Templates/
    └── content_generation/
        ├── content_generation.json # n8n workflow template
        └── prompts.md              # AI prompt templates
```

## 🔧 Configuration

### Docker Compose Setup

The `docker-compose.yml` defines two services:

**n8n Service**:
- Image: `docker.n8n.io/n8nio/n8n:2.4.6`
- Port: `5678`
- External task runners enabled
- Broker listening on port `5679`
- Timezone: Asia/Kolkata

**Runners Service**:
- Built from custom Dockerfile
- Connects to n8n broker
- JavaScript and Python task execution
- Health check ports: 5681 (JS), 5682 (Python)

### Task Runners Configuration

The `n8n-task-runners.json` defines two execution environments:

#### JavaScript Runner
- Command: `/usr/local/bin/node`
- Security flags: `--disallow-code-generation-from-strings --disable-proto=delete`
- Pre-installed modules: `moment`, `uuid`
- Health check port: 5681

#### Python Runner
- Command: Python 3 via virtual environment
- Pre-installed packages: `requests`, `pandas`, `numpy`
- Health check port: 5682
- Python path configured for runner modules

### Environment Variables

Key configuration variables in `docker-compose.yml`:

```yaml
N8N_RUNNERS_AUTH_TOKEN: "change-this-to-a-long-random-secret"  # ⚠️ Change in production
N8N_RUNNERS_TASK_BROKER_URI: "http://n8n:5679"
N8N_RUNNERS_STDLIB_ALLOW: "*"      # Allow standard library functions
N8N_RUNNERS_EXTERNAL_ALLOW: "*"    # Allow external packages
```

**⚠️ Security Note**: Change the `N8N_RUNNERS_AUTH_TOKEN` to a strong random secret before deploying to production.

## 📊 Templates

### Content Generation Pipeline

The `Templates/content_generation/` directory contains a complete workflow for generating AI-powered technical articles:

**Workflow Features**:
- Scheduled execution (Monday & Thursday at 9 AM IST)
- Trending topic discovery via SerpApi
- Topic research and aggregation
- AI-powered content generation with expert prompts
- Content quality evaluation and humanization

**Prompt Guidelines**:
- Focus on practical, actionable content
- Include real-world implementation challenges
- Provide specific examples and case studies
- Target senior data leaders and technical architects
- 1,800-2,000 word formatted articles

**To Use**:
1. Import `content_generation.json` into n8n
2. Configure SerpApi credentials
3. Set up AI model integrations (OpenAI, etc.)
4. Adjust schedule and content parameters as needed

## 🔌 Adding Custom Dependencies

### Python Packages

Edit `runners/requirements.txt` and add your packages:

```
requests
pandas
numpy
your-package-name
```

Then rebuild the runners image:
```bash
.\update-n8n.bat
```

### JavaScript Packages

Edit the Dockerfile to add npm packages:

```dockerfile
RUN cd /opt/runners/task-runner-javascript && pnpm add your-package-name
```

Then rebuild:
```bash
.\update-n8n.bat
```

## 📝 Workflow Development

1. **Create Workflows**: Use the n8n UI at `http://localhost:5678`
2. **Use Task Runners**: Add "Execute JavaScript" or "Execute Python" nodes for custom logic
3. **Save Workflows**: Export as JSON and store in `Templates/` for version control
4. **Schedule Execution**: Configure triggers and schedules via the UI

## 🐛 Troubleshooting

### Containers won't start
- Ensure Docker Desktop is running
- Check that ports 5678 and 5679 are not in use
- Run `docker ps` to see running containers

### Task runners not responding
- Check runner logs: `docker logs n8n-runners`
- Verify auth token matches between services
- Ensure runners service can reach n8n broker at `http://n8n:5679`

### Persistent data issues
- Verify `n8n_data` volume exists: `docker volume ls`
- Data persists across restarts at `/home/node/.n8n` in the volume
- To reset data, remove the volume: `docker volume rm n8n_data`

### Performance tuning
- Increase `N8N_RUNNERS_MAX_CONCURRENCY` for more parallel task execution
- Adjust `N8N_RUNNERS_TASK_TIMEOUT` for long-running tasks
- Monitor resource usage: `docker stats`

## 🔐 Security Considerations

- **Change Auth Token**: Modify `N8N_RUNNERS_AUTH_TOKEN` in production
- **Restrict External Packages**: Set `N8N_RUNNERS_EXTERNAL_ALLOW` to specific packages only
- **Use Network Policies**: In Kubernetes, add network policies to restrict inter-container communication
- **Secure Credentials**: Store API keys and secrets using n8n's credential management
- **Monitor Logs**: Regularly review container logs for unauthorized access attempts

## 📈 Scaling

### For High-Volume Workflows
- Increase runner concurrency in `docker-compose.yml`
- Add multiple runner containers and load balance
- Implement workflow queuing with database

### For Production
- Use environment variables from `.env` file
- Set up proper logging and monitoring
- Configure backup strategy for `n8n_data` volume
- Use reverse proxy (Nginx) for SSL/TLS

## 📚 Additional Resources

- [n8n Documentation](https://docs.n8n.io)
- [n8n Task Runners](https://docs.n8n.io/hosting/scaling/task-runners/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)

## 📄 License

See LICENSE file for details.

## 💬 Support

For issues or questions:
1. Check the Troubleshooting section above
2. Review n8n official documentation
3. Check Docker container logs
4. Verify configuration files match your setup

---

**Last Updated**: February 5, 2026  
**n8n Version**: 2.4.6
