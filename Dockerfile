FROM golang:alpine as builder
RUN mkdir /build 
ADD . /build/
WORKDIR /build 
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .
# Package into a new container
FROM scratch
COPY --from=builder /build/main /app/
ADD ca-certificates.crt /etc/ssl/certs/
WORKDIR /app
CMD ["./main"]
