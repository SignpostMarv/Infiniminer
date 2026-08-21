ARCHIVE_RESTORE = docker run --rm -it \
		-v /app/:/app/ \
		-v /archive/infiniminer/:/archive/infiniminer/ \
		-v /home/vscode/.gitconfig:/home/vscode/.gitconfig:ro \
		-v ./.devcontainer/.ash_history:/home/vscode/.ash_history \
		-e git_init_defaultbranch=$${git_init_defaultbranch:-main} \
		-w /app/archive-restore/ \
		-u vscode \
		archive-restore

MONO_DOCKER_TEMPLATE = \
		-v /app/:/app/:ro \
		-v /app/csharp/:/app/csharp/:rw \
		-u vscode

MONO = docker run --rm -it \
		$(MONO_DOCKER_TEMPLATE) \
		-w /app/csharp/code/ \
		mono

MSITOOLS = docker run --rm -it \
		-v /app/:/app/:ro \
		-v /app/msitools/:/app/msitools/:rw \
		-w /app/msitools/ \
		-u vscode \
		msitools

devcontainer--postAttachCommand: \
	docker-build \
	build--msiextract \
	echo "done setting up"

docker--build: \
	build--init--mono \
	archive-restore--build \
	build--msiextract--build \
	echo "done building docker images"

archive-restore--build:
	@docker build -t archive-restore -f .devcontainer/archive-restore.Dockerfile ./.devcontainer/.empty-directory-on-purpose

archive-restore--init:
	@sudo chown -R vscode:vscode /archive/infiniminer/
	@touch ./.devcontainer/.ash_history

.PHONY: archive-restore
archive-restore: archive-restore--init
	@${ARCHIVE_RESTORE} \
		sh

svn2git: archive-restore--init
	@${ARCHIVE_RESTORE} \
		make svn2git

build--msiextract--build:
	@docker build -t msitools -f .devcontainer/msitools.Dockerfile ./.devcontainer/.empty-directory-on-purpose

build--msiextract:
	@touch ./msitools/.ash_history
	@ if [ ! -f "/app/msitools/xnafx40_redist.msi" ]; then wget -P ./msitools/ https://download.microsoft.com/download/a/c/2/ac2c903b-e6e8-42c2-9fd7-bebac362a930/xnafx40_redist.msi; fi
	@echo "9a233fd33fa535d0783ac4a97108166b860d7647998ce184e6e5103200a6c8522a5e4d035b85e02280f5176c092e0d3e61a60f228d7ca17f09fcf2fc5cdf5253 *./msitools/xnafx40_redist.msi" | shasum -b -a 512 -c
	@rm -fr ./msitools/xnafx40_redist/
	@${MSITOOLS} \
		msiextract --directory xnafx40_redist xnafx40_redist.msi
	@rsync -au /app/msitools/xnafx40_redist/Program\ Files/Microsoft\ XNA/XNA\ Game\ Studio/*.dll /app/csharp/vendor/xna/

build--init--mono:
	@docker build -t mono -f .devcontainer/mono.Dockerfile ./.devcontainer/.empty-directory-on-purpose

build--init:
	@touch ./.devcontainer/.bash_history

mono: build--init
	@${MONO} \
		bash

build--clean:
	@cd /app/csharp/ && rm -fr \
		./bin/*.dll \
		./bin/*.exe \
		./bin/*.config \
		./bin/*.pdb \
		./bin/*.xml

build--InfiniminerClient--skip-init:
	@${MONO} \
		msbuild InfiniminerClient/InfiniminerClient.csproj \
			/p:OutputPath=/app/csharp/bin/ \
			/p:TargetFramework=4.5

build--InfiniminerServer--skip-init:
	@${MONO} \
		msbuild InfiniminerServer/InfiniminerServer.csproj \
			/p:OutputPath=/app/csharp/bin/ \
			/p:TargetFramework=4.5

build--skip-init: build--InfiniminerClient--skip-init build--InfiniminerServer--skip-init

build: build--init build--clean build--skip-init
