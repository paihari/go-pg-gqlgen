FROM golang:latest

RUN mkdir /build
WORKDIR /build
RUN cd /build
RUN git clone https://github.com/paihari/go-pg-gqlgen.git
# RUN cd /build/go-pg-gqlgen
# RUN export GO111MODULE=on
# RUN go build server.go
# EXPOSE 8080
# ENTRYPOINT [ "/build/go-pg-gqlgen/server" ]
