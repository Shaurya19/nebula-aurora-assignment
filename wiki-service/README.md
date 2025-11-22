# Wiki Service - FastAPI Application

This directory contains the FastAPI application for the Wikipedia-like service.

## Building the Docker Image

To build the Docker image locally:

```bash
docker build . -t wiki-service:latest
```

Or with a custom tag:

```bash
docker build . -t <your-registry>/wiki-service:<tag>
```

## Running Locally

### With PostgreSQL (required)

```bash
docker run -p 8080:80 \
  -e DATABASE_URL="postgresql+asyncpg://user:password@host:5432/dbname" \
  wiki-service:latest
```

The application will be available at `http://localhost:8080`

## Environment Variables

- `DATABASE_URL`: PostgreSQL connection string (required)
  - Format: `postgresql+asyncpg://user:password@host:port/dbname`
  - Example: `postgresql+asyncpg://wiki_user:wiki_password@wiki-postgres:5432/wiki_db`

## API Endpoints

- `POST /users` - Create a new user
- `GET /user/{id}` - Get user by ID
- `POST /posts` - Create a new post
- `GET /posts/{id}` - Get post by ID
- `GET /metrics` - Prometheus metrics endpoint
- `GET /` - API information

## Database

The application uses SQLAlchemy with async support. Database tables are created automatically on startup using `Base.metadata.create_all()`. The `DATABASE_URL` environment variable must be set to a PostgreSQL connection string.

