FROM alpine:3.15

RUN apk update && apk add --no-cache \
	subversion \
	git-svn \
	make \
	perl-utils \
	python2

RUN addgroup -g 1000 vscode && adduser -u 1000 -G vscode -D vscode

USER vscode
