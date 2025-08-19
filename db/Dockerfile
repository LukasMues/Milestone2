FROM postgres:15-alpine

# Copy initialization script
COPY init.sql /docker-entrypoint-initdb.d/

# Set environment variables
ENV POSTGRES_DB=milestone2
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password123

# Expose port 5432
EXPOSE 5432

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD pg_isready -U postgres -d milestone2 || exit 1 