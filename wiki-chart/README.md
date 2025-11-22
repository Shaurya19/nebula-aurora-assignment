# Wiki Chart

A Helm chart for deploying a Wikipedia-like FastAPI service with PostgreSQL, Prometheus, and Grafana on Kubernetes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- kubectl configured to access your Kubernetes cluster

## Installation

### 1. Build the Docker Image

First, build the FastAPI application Docker image:

```bash
cd wiki-service
docker build . -t <your-registry>/wiki:latest
```

Push the image to your registry (if using a remote registry):

```bash
docker push <your-registry>/wiki:latest
```

### 2. Update values.yaml

Before installing, update the `fastapi.image_name` in `values.yaml`:

```yaml
fastapi:
  image_name: <your-registry>/wiki:latest
```

Or set it during installation using `--set`:

```bash
helm install wiki ./wiki-chart --set fastapi.image_name=<your-registry>/wiki:latest
```

### 3. Install Dependencies

If using the PostgreSQL chart dependency, update dependencies:

```bash
helm dependency update ./wiki-chart
```

### 4. Install the Chart

Install the chart with the default values:

```bash
helm install wiki ./wiki-chart
```

Or with custom values:

```bash
helm install wiki ./wiki-chart -f values.yaml
```

Or with inline value overrides:

```bash
helm install wiki ./wiki-chart --set fastapi.image_name=my-registry/wiki:v1.0.0
```

## Configuration

The following table lists the configurable parameters and their default values:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `fastapi.image_name` | FastAPI Docker image name | `your-registry/wiki:latest` |
| `fastapi.replicaCount` | Number of FastAPI replicas | `1` |
| `fastapi.containerPort` | Container port | `80` |
| `fastapi.resources.requests.cpu` | CPU request | `250m` |
| `fastapi.resources.requests.memory` | Memory request | `256Mi` |
| `fastapi.resources.limits.cpu` | CPU limit | `1` |
| `fastapi.resources.limits.memory` | Memory limit | `1Gi` |
| `postgresql.enabled` | Enable PostgreSQL | `true` |
| `postgresql.auth.username` | PostgreSQL username | `wiki_user` |
| `postgresql.auth.password` | PostgreSQL password | `wiki_password` |
| `postgresql.auth.database` | PostgreSQL database name | `wiki_db` |
| `postgresql.primary.persistence.size` | PostgreSQL PVC size | `1Gi` |
| `prometheus.enabled` | Enable Prometheus | `true` |
| `grafana.enabled` | Enable Grafana | `true` |
| `grafana.adminUser` | Grafana admin username | `admin` |
| `grafana.adminPassword` | Grafana admin password | `admin` |
| `ingress.enabled` | Enable Ingress | `true` |
| `ingress.className` | Ingress class name | `nginx` |
| `ingress.hosts` | Ingress host configuration | See values.yaml |

## Testing

After installation, verify the deployment:

1. Check all pods are running:
   ```bash
   kubectl get pods
   ```

2. Port-forward the FastAPI service:
   ```bash
   kubectl port-forward svc/wiki-chart-fastapi 8080:80
   ```

3. Test the API:
   ```bash
   # Create a user
   curl -X POST http://localhost:8080/users \
     -H "Content-Type: application/json" \
     -d '{"name": "Test User"}'
   
   # Create a post
   curl -X POST http://localhost:8080/posts \
     -H "Content-Type: application/json" \
     -d '{"user_id": 1, "content": "Test post"}'
   
   # Get metrics
   curl http://localhost:8080/metrics
   ```

4. Access Grafana:
   ```bash
   kubectl port-forward svc/wiki-chart-grafana 3000:3000
   ```
   Then open: http://localhost:3000/grafana/d/creation-dashboard-678/creation
   Login: admin / admin

5. Access Prometheus:
   ```bash
   kubectl port-forward svc/wiki-chart-prometheus 9090:9090
   ```
   Then open: http://localhost:9090

## Uninstallation

To uninstall the chart:

```bash
helm uninstall wiki
```

## Resource Constraints

The default configuration is designed to fit within:
- ≤ 2 CPUs total
- ≤ 4 GB RAM total
- ≤ 5 GB disk total

Adjust resource requests and limits in `values.yaml` if needed for your cluster.

## Troubleshooting

### Pods not starting

Check pod logs:
```bash
kubectl logs <pod-name>
```

### Database connection issues

Verify the database secret:
```bash
kubectl get secret wiki-chart-db-secret -o yaml
```

Check database pod:
```bash
kubectl get pods -l app.kubernetes.io/component=postgresql
kubectl logs <postgresql-pod-name>
```

### Ingress not working

Verify ingress controller is installed:
```bash
kubectl get ingressclass
```

Check ingress status:
```bash
kubectl describe ingress wiki-chart-ingress
```

