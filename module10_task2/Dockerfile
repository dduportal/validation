### Initial Image
# FROM golang:1.15.6-alpine
# RUN echo -e 'package main\n\nimport "fmt"\n\nfunc main() {\nfmt.Println("Hello World")\n}' > main.go
# RUN go build -o /helloworld
# ENTRYPOINT [ "/helloworld" ]

FROM golang:1.15.8-alpine AS builder

RUN apk add curl \
    && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin \
    && trivy filesystem --exit-code 1 --no-progress

RUN echo -e 'package main\n\nimport "fmt"\n\nfunc main() {\nfmt.Println("Hello World")\n}' > main.go
RUN go build -o /helloworld

FROM scratch AS runner
COPY --from=builder /helloworld /helloworld
ENTRYPOINT [ "/helloworld" ]
