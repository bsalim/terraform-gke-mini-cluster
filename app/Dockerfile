FROM golang:1.22.6-alpine3.20

WORKDIR /app

COPY go.mod ./
COPY go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

COPY . .

RUN go build -o main .

# Expose port 8080 to the outside world
EXPOSE 8080

CMD ["./main"]