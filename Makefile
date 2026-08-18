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
		-v /app/:/app/ \
		-v /archive/infiniminer/:/archive/infiniminer/ \
		-v /app/bin/:/archive/infiniminer/git/bin/ \
		-v /home/vscode/.gitconfig:/home/vscode/.gitconfig:ro \
		-w /archive/infiniminer/git/code/ \
		-u vscode \
		mono

MSITOOLS = docker run --rm -it \
		-v /app/msitools/:/app/ \
		-w /app/ \
		-u vscode \
		msitools

archive-restore--init:
	@docker build -t archive-restore - < .devcontainer/archive-restore.Dockerfile
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
	@docker build -t msitools - < .devcontainer/msitools.Dockerfile
	@touch ./msitools/.ash_history
	@ if [ ! -f "/app/msitools/xnafx30_redist.msi" ]; then wget -P ./msitools/ https://download.microsoft.com/download/0/f/f/0ff8780d-f50a-41ef-a31a-09db7c0589a2/xnafx30_redist.msi; fi
	@echo "51701be931330a55214c7ad72dc06b50014b4348b330ad5a88fad7113c6093972856cb81bf6f8bdc71894cce816ba1470472c2e2ddee11137d526b58bbfbd7dd *./msitools/xnafx30_redist.msi" | shasum -b -a 512 -c
	@rm -fr ./msitools/xnafx30_redist/
	@${MSITOOLS} \
		msiextract --directory xnafx30_redist xnafx30_redist.msi


build--init: build--msiextract
	@docker build -t mono - < .devcontainer/mono.Dockerfile
	@sudo chown -R vscode:vscode /archive/infiniminer/
	@touch ./.devcontainer/.bash_history
	@ if [ ! -d "/archive/infiniminer/git/.git" ]; then echo "It looks like you have not run \`make svn2git\`!" >&2; exit 1; fi

build: build--init
	@rm -fr ./bin/*.dll ./bin/*.exe ./bin/*.ico ./bin/*.config ./bin/*.pdb ./bin/*.xml
	@${MONO} \
		msbuild InfiniminerClient/InfiniminerClient.csproj /p:TargetFramework=4.5
	@${MONO} \
		msbuild InfiniminerServer/InfiniminerServer.csproj /p:TargetFramework=4.5
