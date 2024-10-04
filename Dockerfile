# Stage 1: Build the Go binary using Go 1.22.5
FROM golang:1.22.5-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum to download dependencies
COPY go.mod go.sum ./

# Download all Go modules (dependencies)
RUN go mod download

# Copy the entire project into the container
COPY . .

# Build the Go application (assuming the main entry point is in cmd/main.go)
RUN go build -o main ./cmd

# Stage 2: Create a lightweight container to run the application
FROM alpine:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /app/main .

# Copy the .env file and app.env file
COPY .env .           
COPY cmd/app.env .      

# Expose the port your app will run on (as defined in your .env)
EXPOSE 8080

# Run the Go binary
CMD ["./main"]
