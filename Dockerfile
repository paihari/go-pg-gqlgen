FROM golang:latest

RUN mkdir /build

WORKDIR /build/go-pg-gqlgen

# RUN go install github.com/paihari/go-pg-gqlgen@latest

RUN cd /build && git clone https://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8@github.com/paihari/go-pg-gqlgen.git

RUN cd /build/go-pg-gqlgen

RUN export GO111MODULE=on

# RUN go mod init github.com/paihari/go-pg-gqlgen

RUN go build server.go

# RUN /build/go-pg-gqlgen && go build server.go

EXPOSE 8080

ENTRYPOINT [ "/build/go-pg-gqlgen/server" ]

