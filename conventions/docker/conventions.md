# DOCKER & CONTAINER PACKAGING CONVENTIONS

## 1. DOCKERFILE BEST PRACTICES & SECURITY
- **Multi-Stage Builds**: Always use multi-stage builds. The final production image must contain only the compiled binary / runtime dependencies and zero build tools (compilers, git, dev-dependencies).
- **Non-Root Execution**:
  - Never run containers as `root` (UID 0).
  - Explicitly define and switch to an unprivileged user: `USER nonroot:nonroot` or `USER 10001:10001`.
- **Minimal Base Images**:
  - Use `distroless` (Google Container Tools), Alpine, or Debian Slim base images.
  - Pin exact base image versions and digests (e.g., `golang:1.24-alpine@sha256:...`); avoid rolling tags like `:latest`.

```dockerfile
# Build stage
FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /app/server ./cmd/server

# Production stage
FROM gcr.io/distroless/static-debian12:nonroot
WORKDIR /app
COPY --from=builder /app/server /app/server
USER nonroot:nonroot
EXPOSE 8080
ENTRYPOINT ["/app/server"]
```

## 2. LAYER CACHING & BUILD EFFICIENCY
- Order Dockerfile commands from least frequently changed to most frequently changed:
  1. System dependencies and OS packages.
  2. Package manifest files (`package.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`).
  3. Dependency installation (`npm ci`, `cargo fetch`, `go mod download`).
  4. Application source code and assets.
  5. Build step (`RUN npm run build`).

## 3. CONTAINER HEALTH & SIGNAL HANDLING
- **Init Systems & Signal Propagation**:
  - Ensure the PID 1 process handles `SIGTERM` and `SIGINT` properly to allow graceful shutdown without abrupt container killing after 10s.
  - If using Node.js or Python without an internal init handler, use `tini` or `dumb-init`.
- **Healthcheck Directives**: Define a lightweight `HEALTHCHECK` directive in the Dockerfile or Docker Compose file to assist container orchestrators.
- **Docker Compose Standards**:
  - Always commit a clean, working `docker-compose.yml` for local development.
  - Use named volumes for persistent data and bridge networks with custom names.
