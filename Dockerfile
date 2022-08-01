FROM golang:alpine AS builder

RUN apk add --no-cache --update git gcc rust

RUN mkdir -p /go/src/github.com/slicelife/go-supervisord

COPY . /go/src/github.com/slicelife/go-supervisord
WORKDIR /go/src/github.com/slicelife/go-supervisord

RUN CGO_ENABLED=0 go build -a -ldflags "-linkmode external -extldflags -static" -o /go/bin/supervisord github.com/slicelife/go-supervisord

FROM scratch

COPY --from=builder /go/bin/supervisord /usr/local/bin/supervisord

ENTRYPOINT ["/usr/local/bin/supervisord"]
