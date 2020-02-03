#docker build -t kind-go-client -f nobuild.Dockerfile ./_builds/
FROM scratch
COPY ./app /app
ENTRYPOINT ["/app"]