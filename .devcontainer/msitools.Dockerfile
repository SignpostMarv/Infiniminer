FROM alpine:3.24

RUN apk update && apk add --no-cache \
	msitools

RUN addgroup -g 1000 vscode && adduser -u 1000 -G vscode -D vscode

USER vscode

# we're mounting just the msitools directory as app here
ENV HISTFILE=/app/.ash_history
