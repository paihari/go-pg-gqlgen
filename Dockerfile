FROM golang
RUN mkdir /app

ADD . /app

WORKDIR /app

RUN go run ./server.go




