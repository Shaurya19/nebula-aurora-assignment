# Part 2: Containerize the entire cluster with Docker-in-Docker and k3d
FROM docker:dind

# Install necessary tools
RUN apk add --no-cache \
    bash \
    curl \
    kubectl \
    python3 \
    py3-pip \
    git

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install k3d
RUN curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Set working directory
WORKDIR /workspace

# Copy wiki-service and wiki-chart
COPY wiki-service/ ./wiki-service/
COPY wiki-chart/ ./wiki-chart/

# Copy startup script
COPY start-cluster.sh /start-cluster.sh
RUN chmod +x /start-cluster.sh

# Expose port 8080
EXPOSE 8080

# Start the cluster
ENTRYPOINT ["/start-cluster.sh"]
