FROM alpine:latest as builder

RUN apk add --no-cache zig

WORKDIR /app

COPY . .

RUN zig build -Doptimize=ReleaseSafe

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/zig-out/bin/my_zap_project .

EXPOSE 3000

CMD ["./Zoe"]
