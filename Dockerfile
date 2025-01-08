FROM golang:1.22.4-alpine3.20 AS builder

RUN adduser -u 10001 -S steampipe
ADD . /go
RUN go build

FROM scratch

COPY --from=builder /go/steampipe /usr/bin/steampipe
RUN chmod +X /usr/bin/steampipe
COPY --from=builder /etc/passwd /etc/passwd
USER steampipe

RUN steampipe plugin install aws

ENTRYPOINT ["/usr/bin/steampipe"]
