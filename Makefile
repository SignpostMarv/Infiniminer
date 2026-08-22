ARCHIVE_RESTORE = docker run --rm -it \
		-v /app/:/app/ \
		-v /archive/infiniminer/:/archive/infiniminer/ \
		-v /home/vscode/.gitconfig:/home/vscode/.gitconfig:ro \
		-v ./.devcontainer/.ash_history:/home/vscode/.ash_history \
		-e git_init_defaultbranch=$${git_init_defaultbranch:-main} \
		-w /app/archive-restore/ \
		-u vscode \
		archive-restore

MGCB = docker run --rm -it \
		-v /app/:/app/:ro \
		-v /app/csharp/:/app/csharp/:rw \
		-v /app/mgcb/:/app/mgcb/:rw \
		-w /app/mgcb/ \
		-u 1000:1000 \
		mgcb

devcontainer--postAttachCommand: \
	docker-build \
	build--msiextract \
	build--mgcb \
	echo "done setting up"

docker--build: \
	archive-restore--build \
	build--msiextract--build \
	build--mgcb--build \
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

build--mgcb--build:
	@docker build -t mgcb -f .devcontainer/mgcb.Dockerfile ./.devcontainer/.empty-directory-on-purpose

build--mgcb:
	@touch ./mgcb/.bash_history
	@rm -f ./mgcb/config.files
	@touch ./mgcb/config.files
	@cd /app/csharp/code/InfiniminerClient/Content/ && \
		find . -name "*.png" | while read png; \
			do echo "/build:$$png" >> /app/mgcb/config.files; \
			done;
	@${MGCB} \
		mgcb /@/config /@/config.files

build--clean:
	@cd /app/csharp/ && rm -fr \
		./bin/*.dll \
		./bin/*.exe \
		./bin/*.config \
		./bin/*.pdb \
		./bin/*.xml
	@sudo chown -R vscode:vscode /app/csharp/
	@rm -fr /app/csharp/vendor/*
	@dotnet restore /app/csharp/code/

build--InfiniminerClient:
	@dotnet restore /app/csharp/code/InfiniminerClient/InfiniminerClient.csproj
	@dotnet build /app/csharp/code/InfiniminerClient/InfiniminerClient.csproj

build--InfiniminerServer:
	@dotnet restore /app/csharp/code/InfiniminerServer/InfiniminerServer.csproj
	@dotnet build /app/csharp/code/InfiniminerServer/InfiniminerServer.csproj

build: \
	build--clean \
	build--InfiniminerClient \
	build--InfiniminerServer
	echo "done building"
