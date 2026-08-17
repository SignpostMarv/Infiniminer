FROM mcr.microsoft.com/devcontainers/base:alpine

RUN apk update --no-cache && apk add \
	subversion \
	git-svn \
	--no-cache
