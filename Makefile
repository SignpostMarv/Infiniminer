ARCHIVE_RESTORE = docker run --rm -it \
		-v /app/:/app/ \
		-v /archive/infiniminer/:/archive/infiniminer/ \
		-v /home/vscode/.gitconfig:/home/vscode/.gitconfig:ro \
		-v ./.devcontainer/.ash_history:/home/vscode/.ash_history \
		-e git_init_defaultbranch=$${git_init_defaultbranch:-main} \
		-w /app/archive-restore/ \
		-u vscode \
		archive-restore

MONO = docker run --rm -it \
		-v /app/:/app/:ro \
		-v /app/csharp/:/app/csharp/:rw \
		-w /app/csharp/code/ \
		-u vscode \
		mono

MSITOOLS = docker run --rm -it \
		-v /app/:/app/:ro \
		-v /app/msitools/:/app/msitools/:rw \
		-w /app/msitools/ \
		-u vscode \
		msitools

archive-restore--init:
	@docker build -t archive-restore -f .devcontainer/archive-restore.Dockerfile ./.devcontainer/.empty-directory-on-purpose
	@sudo chown -R vscode:vscode /archive/infiniminer/
	@touch ./.devcontainer/.ash_history

.PHONY: archive-restore
archive-restore: archive-restore--init
	@${ARCHIVE_RESTORE} \
		sh

svn2git: archive-restore--init
	@${ARCHIVE_RESTORE} \
		make svn2git

build--msiextract:
	@docker build -t msitools -f .devcontainer/msitools.Dockerfile ./.devcontainer/.empty-directory-on-purpose
	@touch ./msitools/.ash_history
	@ if [ ! -f "/app/msitools/xnafx30_redist.msi" ]; then wget -P ./msitools/ https://download.microsoft.com/download/0/f/f/0ff8780d-f50a-41ef-a31a-09db7c0589a2/xnafx30_redist.msi; fi
	@echo "51701be931330a55214c7ad72dc06b50014b4348b330ad5a88fad7113c6093972856cb81bf6f8bdc71894cce816ba1470472c2e2ddee11137d526b58bbfbd7dd *./msitools/xnafx30_redist.msi" | shasum -b -a 512 -c
	@rm -fr ./msitools/xnafx30_redist/
	@${MSITOOLS} \
		msiextract --directory xnafx30_redist xnafx30_redist.msi
	@rsync -au /app/msitools/xnafx30_redist/Program\ Files/Microsoft\ XNA/XNA\ Game\ Studio/*.dll /app/csharp/vendor/xna/

build--init: build--msiextract
	@docker build -t mono -f .devcontainer/mono.Dockerfile ./.devcontainer/.empty-directory-on-purpose
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
