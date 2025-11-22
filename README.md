# Nebula Aurora Assignment - Wiki Service

This repository contains a production-ready Helm-packaged FastAPI Wikipedia-like service with PostgreSQL, Prometheus, and Grafana.

## Project Structure

```
/
├── wiki-service/          # FastAPI application
│   ├── Dockerfile         # Docker image definition
│   ├── app/              # Application source code
│   ├── requirements.txt  # Python dependencies
│   └── README.md         # Service documentation
│
├── wiki-chart/           # Helm chart
│   ├── Chart.yaml        # Chart metadata
│   ├── values.yaml       # Default configuration values
│   ├── templates/        # Kubernetes manifests
│   ├── NOTES.txt         # Post-installation instructions
│   └── README.md         # Chart documentation
│
├── Dockerfile            # Part 2: Containerized cluster with k3d
└── start-cluster.sh      # Part 2: Cluster startup script
```

## Quick Start

### 1. Build the Docker Image

```bash
docker build -t my-wiki:local ./wiki-service
```

### 2. Install the Chart

```bash
helm install wiki ./wiki-chart --set fastapi.image_name=my-wiki:local
```

### 3. Access the Service

Use port-forwarding to access the FastAPI service:

```bash
kubectl port-forward svc/wiki-wiki-chart-fastapi 8080:8000
```

Then access: `http://localhost:8080`

## Part 2: Containerized Cluster with k3d

Part 2 packages the entire cluster in a Docker container using Docker-in-Docker and k3d.

### Build and Run Part 2

```bash
# From the repository root
# Build the Docker image
docker build -t wiki-cluster:latest .

# Run the container (requires --privileged flag for Docker-in-Docker)
docker run -d --name wiki-cluster --privileged -p 8080:8080 wiki-cluster:latest
```

### Access the Services

After the container starts (wait 1-2 minutes for cluster initialization), access services at:

- **FastAPI**: `http://localhost:8080/users`, `http://localhost:8080/posts`
- **Grafana Dashboard**: `http://localhost:8080/grafana/d/creation-dashboard-678/creation`
- **Metrics**: `http://localhost:8080/metrics`

### Check Container Status

```bash
# View logs
docker logs wiki-cluster

# Follow logs
docker logs -f wiki-cluster

# Stop the container
docker stop wiki-cluster

# Remove the container
docker rm wiki-cluster
```

