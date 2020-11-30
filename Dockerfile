FROM golang:1.14 AS builder
LABEL stage=builder
WORKDIR /usr/src/app
COPY ./ /usr/src/app
RUN go build main.go
CMD ["./main"]

FROM golang:1.14 AS release
ENV USER_UID=1001 USER_NAME=opslevel ENV=local
COPY --from=builder /usr/src/app/main /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/main"]