      FROM golang:1.21 AS builder

      WORKDIR /app
      
      COPY go.mod go.sum ./
      RUN go mod download
      
      COPY . .
      
      RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o employee-api main.go

      FROM alpine:latest
      
      RUN apk --no-cache add ca-certificates
      
      WORKDIR /root/
      
      COPY --from=builder /app/employee-api .
      COPY --from=builder /app/config.yaml .
      
      ENTRYPOINT ["./employee-api"]
      
